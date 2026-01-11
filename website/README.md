# CheerLens Website

This is the website for CheerLens, hosted on GitHub Pages.

## Setup Instructions for GitHub Pages

### Step 1: Create a GitHub Repository

1. Go to [GitHub](https://github.com) and create a new repository
2. Name it `cheerlens` or `cheerlens-website`
3. Make it public (required for free GitHub Pages)
4. Don't initialize with README (we already have one)

### Step 2: Upload Files

1. Open Terminal/Command Prompt
2. Navigate to this website folder:
   ```bash
   cd /Users/linchiakand/Desktop/SmileDetectionApp/website
   ```

3. Initialize git and push to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial website commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/cheerlens.git
   git push -u origin main
   ```
   (Replace `YOUR_USERNAME` with your GitHub username)

### Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under **Source**, select **Deploy from a branch**
4. Select **main** branch and **/ (root)** folder
5. Click **Save**

### Step 4: Configure Custom Domain (cheerlens.com)

1. In your GitHub repository, go to **Settings** → **Pages**
2. Under **Custom domain**, enter: `cheerlens.com`
3. Click **Save**

4. In GoDaddy (or your domain registrar):
   - Go to DNS Management
   - Add/Edit DNS records:
     - **Type:** A
     - **Name:** @
     - **Value:** 185.199.108.153
     - **TTL:** 600
   
     - **Type:** A
     - **Name:** @
     - **Value:** 185.199.109.153
     - **TTL:** 600
   
     - **Type:** A
     - **Name:** @
     - **Value:** 185.199.110.153
     - **TTL:** 600
   
     - **Type:** A
     - **Name:** @
     - **Value:** 185.199.111.153
     - **TTL:** 600
   
     - **Type:** CNAME
     - **Name:** www
     - **Value:** YOUR_USERNAME.github.io
     - **TTL:** 600

   (Replace `YOUR_USERNAME` with your GitHub username)

5. Wait 24-48 hours for DNS propagation

### Step 5: Verify Setup

1. Visit `https://YOUR_USERNAME.github.io/cheerlens` (or your custom domain)
2. The website should be live!

## File Structure

```
website/
├── index.html          # Homepage
├── privacy.html        # Privacy Policy page
├── support.html        # Support/FAQ page
├── styles.css          # Stylesheet
└── README.md           # This file
```

## Updating the Website

To update the website:

1. Edit files locally
2. Commit and push changes:
   ```bash
   git add .
   git commit -m "Update website content"
   git push
   ```
3. Changes will be live within a few minutes

## Notes

- GitHub Pages automatically serves `index.html` as the homepage
- All links are relative, so they work on both GitHub Pages and custom domain
- The website is mobile-responsive
- No build process required—just HTML, CSS, and static files

## App Store Links

Update the App Store links in `index.html` once your app is published:
- Replace `https://apps.apple.com/app/cheerlens` with your actual App Store URL

## Support

For questions about the website setup, refer to [GitHub Pages documentation](https://docs.github.com/en/pages).

