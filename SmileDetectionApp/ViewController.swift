// ViewController.swift
// SmileDetectionApp
// Created by 林家康 on 2025/8/24.

import UIKit
import AVFoundation
import MLKitVision
import MLKitFaceDetection

// MARK: - UIImage Extension for Orientation Fix
extension UIImage {
    func fixOrientation(for deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> UIImage {
        let targetOrientation = imageOrientation(deviceOrientation: deviceOrientation, cameraPosition: cameraPosition)
        
        // If the image is already in the correct orientation, return it
        if self.imageOrientation == targetOrientation {
            return self
        }
        
        // Create a graphics context with the correct orientation
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        // Apply the correct transformation
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // Apply the transformation based on target orientation
        switch targetOrientation {
        case .right:
            context?.translateBy(x: self.size.width, y: 0)
            context?.rotate(by: .pi / 2)
        case .left:
            context?.translateBy(x: 0, y: self.size.height)
            context?.rotate(by: -.pi / 2)
        case .down:
            context?.translateBy(x: self.size.width, y: self.size.height)
            context?.rotate(by: .pi)
        case .upMirrored:
            context?.translateBy(x: self.size.width, y: 0)
            context?.scaleBy(x: -1, y: 1)
        case .downMirrored:
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1, y: -1)
        case .leftMirrored:
            context?.translateBy(x: self.size.width, y: self.size.height)
            context?.rotate(by: .pi)
            context?.scaleBy(x: -1, y: 1)
        case .rightMirrored:
            context?.translateBy(x: 0, y: 0)
            context?.rotate(by: .pi / 2)
            context?.scaleBy(x: -1, y: 1)
        default:
            break
        }
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        context?.restoreGState()
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
    
    private func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        default:
            return .up
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let cleanupRequested = Notification.Name("cleanupRequested")
}

class ViewController: UIViewController {
    
    // MARK: - Properties (No Data Storage)
    private var captureSession: AVCaptureSession!
    private var faceDetector: FaceDetector!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraPosition: AVCaptureDevice.Position = .front // Track camera position
    
    // UI Elements
    private var smileLabel: UILabel!
    private var colorView: UIView!
    private var sensitivitySlider: UISlider!
    private var sensitivityLabel: UILabel!
    
    // Performance management (no accumulation)
    private var lastUpdateTime: TimeInterval = 0
    private var updateInterval: TimeInterval = 0.1 // Reduced back to 0.1 for faster response
    private var isProcessing = false
    private var shouldStopProcessing = false
    
    // Cleanup state
    private var isCleanedUp = false
    
    // Sensitivity control (persist user preference only)
    private var smileThreshold: Float = UserDefaults.standard.float(forKey: "smileThreshold")
    
    // Initialize with default if no saved value
    private var initialSmileThreshold: Float {
        let saved = UserDefaults.standard.float(forKey: "smileThreshold")
        return saved > 0 ? saved : 0.5 // Default to 0.5 if no saved value
    }
    
    // Callback for smile detection
    var smileCallback: ((Float) -> Void)?
    
    // Frame rate control
    private let frameProcessingInterval: TimeInterval = 1.0 / 15.0 // Back to 15 FPS for faster response
    private var lastFrameProcessTime: TimeInterval = 0
    
    // Simple state tracking
    private var lastFaceDetected = false
    private var lastSmileProbability: Float = 0.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🎯 DEBUG: ViewController - viewDidLoad called")
        print("🎯 DEBUG: ViewController - View: \(String(describing: view))")
        print("🎯 DEBUG: ViewController - View bounds: \(view.bounds)")
        
        print("🎯 DEBUG: ViewController - About to call setupUI")
        setupUI()
        print("🎯 DEBUG: ViewController - setupUI completed, about to call setupCamera")
        setupCamera()
        print("🎯 DEBUG: ViewController - setupCamera completed, about to call setupNotifications")
        setupNotifications()
        print("🎯 DEBUG: ViewController - All setup completed successfully")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🎯 DEBUG: ViewController - viewWillAppear called")
        shouldStopProcessing = false
        isCleanedUp = false
        
        // Force layout update
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        startCaptureSession()
        print("🎯 DEBUG: ViewController - Capture session started")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("🎯 DEBUG: ViewController - viewWillDisappear called")
        cleanup()
    }
    
    deinit {
        print("🎯 DEBUG: ViewController - deinit called")
        cleanup()
    }
    
    // MARK: - Cleanup (Aggressive - No Data Retention)
    private func cleanup() {
        guard !isCleanedUp else {
            print("🧹 DEBUG: ViewController - Already cleaned up")
            return
        }
        
        print("🧹 DEBUG: ViewController - Starting aggressive cleanup")
        
        // Stop processing immediately
        shouldStopProcessing = true
        isProcessing = false
        
        // Stop capture session
        if let session = captureSession, session.isRunning {
            session.stopRunning()
            print("🧹 DEBUG: ViewController - Capture session stopped")
        }
        
        // Reset all state (no data retention)
        lastUpdateTime = 0
        isCleanedUp = true
        
        // Clear any UI state
        DispatchQueue.main.async {
            self.colorView?.backgroundColor = .systemRed
            self.smileLabel?.text = "No face detected"
        }
        
        print("🧹 DEBUG: ViewController - Aggressive cleanup completed - no data retained")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Only update preview layer frame if it's different to avoid infinite layout loops
        if let previewLayer = previewLayer, !previewLayer.frame.equalTo(view.bounds) {
            previewLayer.frame = view.bounds
            print("🎯 DEBUG: ViewController - Preview layer frame updated to: \(previewLayer.frame)")
        }
        
        // Update orientation when layout changes (important for iPad)
        updateCameraOrientation()
        
        // REMOVED: view.setNeedsLayout() and view.layoutIfNeeded() calls that were causing infinite loop
    }
    
    private func updateCameraOrientation() {
        if let connection = previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                // Use current device orientation for proper face detection
                let currentOrientation = UIDevice.current.orientation
                switch currentOrientation {
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                default:
                    connection.videoOrientation = .portrait
                }
            }
            // Don't manually set mirroring - let it auto-adjust
        }
    }
    
    @objc private func orientationChanged() {
        DispatchQueue.main.async {
            self.updateCameraOrientation()
        }
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCleanupRequest),
            name: .cleanupRequested,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMLKitCleanup),
            name: Notification.Name("MLKitCleanupRequested"),
            object: nil
        )
    }
    
    @objc private func handleCleanupRequest() {
        print("🧹 DEBUG: ViewController - Cleanup request received")
        cleanup()
    }
    
    @objc private func handleMLKitCleanup() {
        print("🧹 DEBUG: ViewController - ML Kit cleanup request received")
        
        // 强制清理ML Kit相关资源
        autoreleasepool {
            // 清理可能的图像处理缓存
            if faceDetector != nil {
                // 尝试释放检测器资源
                faceDetector = nil
            }
            
            // 清理可能的图像缓冲区
            for _ in 0..<10 {
                let _ = Data(count: 10000)
            }
        }
        
        // 强制重新初始化ML Kit存储
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                // 尝试重新初始化ML Kit存储
                if self.faceDetector != nil {
                    // 强制重新创建检测器
                    self.faceDetector = nil
                    self.setupFaceDetector()
                }
            }
        }
        
        print("🧹 DEBUG: ViewController - ML Kit cleanup completed")
    }
    
    private func setupCamera() {
        print("🎯 DEBUG: ViewController - Setting up camera")
        setupFaceDetector()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ DEBUG: ViewController - Failed to get front camera")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("❌ DEBUG: ViewController - Failed to create video input: \(error)")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("❌ DEBUG: ViewController - Failed to add video input")
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("❌ DEBUG: ViewController - Failed to add video output")
            return
        }
        
        // Setup preview layer immediately
        setupCameraPreview()
        
        print("🎯 DEBUG: ViewController - Camera setup completed")
    }
    
    private func startCaptureSession() {
        print("🎯 DEBUG: ViewController - Starting capture session")
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession.startRunning()
                print("🎯 DEBUG: ViewController - Capture session started")
            }
        }
    }
    
    private func setupFaceDetector() {
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate // Use accurate mode as in reference
        options.landmarkMode = .all // Enable landmarks as in reference
        options.classificationMode = .all // Must have this for smileProbability
        options.minFaceSize = 0.1
        options.isTrackingEnabled = true
        options.contourMode = .none
        
        faceDetector = FaceDetector.faceDetector(options: options)
        print("🎯 DEBUG: ViewController - Face detector configured with accurate mode, landmarks: all, classification: all")
    }
    
    private func setupUI() {
        print("🎯 DEBUG: ViewController - setupUI() FUNCTION CALLED!")
        print("🎯 DEBUG: ViewController - Starting UI setup")
        
        guard view != nil else {
            print("❌ DEBUG: ViewController - View is nil!")
            return
        }
        
        // Initialize smileThreshold with saved value or default
        smileThreshold = initialSmileThreshold
        print("🎯 DEBUG: ViewController - Smile threshold: \(smileThreshold)")
        
        // Create UI elements
        smileLabel = UILabel()
        smileLabel.text = "Initializing Face Detection..."
        smileLabel.textAlignment = .center
        smileLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        smileLabel.textColor = .white
        smileLabel.numberOfLines = 0
        smileLabel.backgroundColor = UIColor.clear
        smileLabel.layer.cornerRadius = 0
        smileLabel.layer.shadowColor = UIColor.black.cgColor
        smileLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        smileLabel.layer.shadowOpacity = 0.9
        smileLabel.layer.shadowRadius = 2
        smileLabel.translatesAutoresizingMaskIntoConstraints = false
        smileLabel.isHidden = false
        smileLabel.alpha = 1.0
        view.addSubview(smileLabel)
        print("🎯 DEBUG: ViewController - Smile label added to view with clean styling")
        
        colorView = UIView()
        colorView.backgroundColor = .systemRed // Start with red
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorView)
        print("🎯 DEBUG: ViewController - Color view added to view")
        
        sensitivitySlider = UISlider()
        sensitivitySlider.minimumValue = 0.1
        sensitivitySlider.maximumValue = 0.9
        sensitivitySlider.value = smileThreshold
        sensitivitySlider.addTarget(self, action: #selector(sensitivityChanged), for: .valueChanged)
        sensitivitySlider.setThumbImage(createSmallThumbImage(), for: .normal)
        sensitivitySlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sensitivitySlider)
        print("🎯 DEBUG: ViewController - Sensitivity slider added to view")
        
        sensitivityLabel = UILabel()
        sensitivityLabel.text = String(format: "Sensitivity: %.2f", smileThreshold)
        sensitivityLabel.textAlignment = .center
        sensitivityLabel.font = UIFont.systemFont(ofSize: 14)
        sensitivityLabel.textColor = .white
        sensitivityLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sensitivityLabel)
        print("🎯 DEBUG: ViewController - Sensitivity label added to view")
        
        setupConstraints()
        print("🎯 DEBUG: ViewController - Constraints setup completed")
        
        // Set initial state immediately
        smileLabel.text = "No Face Detected"
        colorView.backgroundColor = .systemRed
        smileLabel.isHidden = false
        smileLabel.alpha = 1.0
        
        // Test view removed - no longer needed for debugging
        
        print("🎯 DEBUG: ViewController - Initial UI state set with text: '\(smileLabel.text ?? "nil")'")
        print("🎯 DEBUG: ViewController - UI setup completed")
    }
    
    private func setupConstraints() {
        print("🎯 DEBUG: ViewController - Setting up constraints")
        view.backgroundColor = .black
        
        // Color view constraints (at the top) - Increased height to 120
        colorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        print("🎯 DEBUG: ViewController - Color view constraints set")
        
        // Smile label constraints (inside the color view) - FIXED POSITIONING
        smileLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
        smileLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        smileLabel.leadingAnchor.constraint(greaterThanOrEqualTo: colorView.leadingAnchor, constant: 20).isActive = true
        smileLabel.trailingAnchor.constraint(lessThanOrEqualTo: colorView.trailingAnchor, constant: -20).isActive = true
        smileLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        smileLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Force the label to be on top of everything
        view.bringSubviewToFront(smileLabel)
        
        // Clean styling - no background, text directly on color bar
        smileLabel.backgroundColor = UIColor.clear
        smileLabel.layer.borderWidth = 0
        smileLabel.layer.borderColor = UIColor.clear.cgColor
        
        print("🎯 DEBUG: ViewController - Smile label constraints set with fixed positioning")
        
        // Sensitivity slider constraints (at the bottom)
        sensitivitySlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        sensitivitySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        sensitivitySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        print("🎯 DEBUG: ViewController - Sensitivity slider constraints set")
        
        // Sensitivity label constraints (below slider)
        sensitivityLabel.topAnchor.constraint(equalTo: sensitivitySlider.bottomAnchor, constant: 10).isActive = true
        sensitivityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        sensitivityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        print("🎯 DEBUG: ViewController - Sensitivity label constraints set")
        
        print("🎯 DEBUG: ViewController - All constraints setup completed")
    }
    
    @objc private func sensitivityChanged() {
        smileThreshold = sensitivitySlider.value
        sensitivityLabel.text = String(format: "Sensitivity: %.2f", smileThreshold)
        
        // Persist the new value
        UserDefaults.standard.set(smileThreshold, forKey: "smileThreshold")
        print("🎯 DEBUG: ViewController - Sensitivity changed to: \(smileThreshold) and saved")
    }
    
    // MARK: - Helper Methods
    private func createSmallThumbImage() -> UIImage {
        let size = CGSize(width: 12, height: 12)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    private func setupCameraPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        // Set proper orientation for iPad
        if let connection = previewLayer.connection {
            if connection.isVideoOrientationSupported {
                // Use current device orientation instead of forcing portrait
                let currentOrientation = UIDevice.current.orientation
                switch currentOrientation {
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                default:
                    connection.videoOrientation = .portrait
                }
            }
            // Don't manually set mirroring - let it auto-adjust
        }
        
        view.layer.insertSublayer(previewLayer, at: 0)
        print("🎯 DEBUG: ViewController - Preview layer added to view")
    }
    
    // MARK: - Orientation Handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Update preview layer frame
            self.previewLayer?.frame = self.view.bounds
            
            // Update video orientation based on new device orientation
            if let connection = self.previewLayer?.connection, connection.isVideoOrientationSupported {
                let currentOrientation = UIDevice.current.orientation
                switch currentOrientation {
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                default:
                    connection.videoOrientation = .portrait
                }
                print("🎯 DEBUG: ViewController - Video orientation updated to: \(connection.videoOrientation.rawValue)")
            }
        })
    }
    
    // MARK: - Image Orientation Helper
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        default:
            return .up
        }
    }
    
    private func stopCamera() {
        captureSession.stopRunning()
        print("Camera stopped")
    }
    
    // MARK: - Face Detection
    private func processImage(_ image: UIImage) {
        // Check if we should stop processing
        guard !shouldStopProcessing else {
            print("🛑 DEBUG: ViewController - Processing stopped by cleanup request")
            return
        }
        
        // Prevent multiple simultaneous processing
        guard !isProcessing else {
            return // Skip if already processing
        }
        
        isProcessing = true
        
        print("🎯 DEBUG: ViewController - Starting face detection for image: \(image.size.width) x \(image.size.height)")
        
        // Create VisionImage and set correct orientation
        let visionImage = VisionImage(image: image)
        visionImage.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: .front
        )
        print("🎯 DEBUG: ViewController - VisionImage orientation set to: \(visionImage.orientation.rawValue) for device orientation: \(UIDevice.current.orientation.rawValue)")
        
        faceDetector.process(visionImage) { [weak self] faces, error in
            // OPTIMIZED: Process face detection results on background thread first
            DispatchQueue.global(qos: .userInteractive).async {
                guard let self = self, !self.shouldStopProcessing else {
                    return
                }
                
                if let error = error {
                    print("❌ DEBUG: ViewController - Face detection error: \(error)")
                    DispatchQueue.main.async {
                        self.isProcessing = false
                    }
                    return
                }
                
                guard let faces = faces, !faces.isEmpty else {
                    DispatchQueue.main.async {
                        self.isProcessing = false
                        self.updateSmileDisplay(probability: 0, faceDetected: false)
                    }
                    return
                }
                
                print("🎯 DEBUG: ViewController - Face detected! Count: \(faces.count)")
                
                // Process the first detected face
                let face = faces.first!
                let smileProbability: Float
                let faceDetected = true
                
                if face.hasSmilingProbability {
                    smileProbability = Float(face.smilingProbability)
                } else {
                    smileProbability = 0.0 // Send 0.0 for faces without smile data
                }
                
                // OPTIMIZED: Batch UI updates on main thread
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.updateSmileDisplay(probability: smileProbability, faceDetected: faceDetected)
                    
                    // CRITICAL FIX: Send notification for ALL face detections (including 0.0 probability)
                    // This ensures continuous data flow for Results screen
                    NotificationCenter.default.post(
                        name: .smileProbabilityUpdated,
                        object: nil,
                        userInfo: [
                            "probability": smileProbability,
                            "faceDetected": faceDetected
                        ]
                    )
                }
            }
        }
    }
    
    
    private func updateSmileDisplay(probability: Float, faceDetected: Bool) {
        guard !shouldStopProcessing else { return }
        
        // OPTIMIZED: Only update if there's a significant change (reduced threshold for smoother updates)
        let significantChange = abs(probability - lastSmileProbability) > 0.05 || faceDetected != lastFaceDetected
        
        if !significantChange {
            return
        }
        
        // Update tracking variables
        lastFaceDetected = faceDetected
        lastSmileProbability = probability
        
        // Determine color and message
        let color: UIColor
        let message: String
        
        if !faceDetected {
            color = .systemRed
            message = "No Face Detected"
        } else {
            if probability > smileThreshold {
                color = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // Dark Green
                message = "Face Detected - Good Smile!"
            } else if probability > (smileThreshold * 0.5) {
                color = .systemOrange
                message = "Face Detected - Some Smile"
            } else {
                color = .systemBlue
                message = "Face Detected - No Smile"
            }
        }
        
        // OPTIMIZED: Batch UI updates to reduce main thread blocking
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Disable animations for immediate updates
        
        colorView.backgroundColor = color
        smileLabel.text = message
        
        // Force text to be visible with padding
        smileLabel.isHidden = false
        smileLabel.alpha = 1.0
        
        // OPTIMIZED: Reduce layout calls
        smileLabel.sizeToFit()
        view.bringSubviewToFront(smileLabel)
        
        // Clean styling - no background, text directly on color bar
        smileLabel.backgroundColor = UIColor.clear
        smileLabel.layer.borderWidth = 0
        smileLabel.layer.borderColor = UIColor.clear.cgColor
        
        CATransaction.commit()
        
        print("🎯 DEBUG: ViewController - Updated UI - Face: \(faceDetected), Smile: \(probability), Message: '\(message)'")
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastFrameProcessTime >= frameProcessingInterval else { return }
        lastFrameProcessTime = currentTime
        
        guard CMSampleBufferIsValid(sampleBuffer) else {
            print("Invalid sample buffer")
            return
        }
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer")
            return
        }
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        guard !ciImage.extent.isEmpty else {
            print("CIImage has empty extent")
            return
        }
        
        guard ciImage.extent.width > 0 && ciImage.extent.height > 0 else {
            print("CIImage has invalid dimensions: \(ciImage.extent)")
            return
        }
        
        print("Image captured: \(ciImage.extent.width) x \(ciImage.extent.height)")
        
        let context = CIContext(options: [.useSoftwareRenderer: false])
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("Failed to create CGImage from CIImage")
            return
        }
        
        let image = UIImage(cgImage: cgImage)
        
        guard image.size.width > 0 && image.size.height > 0 else {
            print("UIImage has invalid size: \(image.size)")
            return
        }
        
        print("UIImage created successfully: \(image.size.width) x \(image.size.height)")
        
        processImage(image)
    }
}



