# Quick Setup Guide

## 🚀 Getting Started

### 1. Prerequisites
- Docker installed and running
- GitHub repository with this code
- Cloudflare R2 account

### 2. Cloudflare R2 Setup
1. Go to [Cloudflare R2](https://dash.cloudflare.com/)
2. Create a new R2 bucket
3. Generate API tokens with Object Read/Write permissions
4. Note your Account ID, Access Key ID, and Secret Access Key

### 3. GitHub Secrets Configuration
Add these secrets to your GitHub repository:
```
CLOUDFLARE_R2_ENDPOINT=https://your-account-id.r2.cloudflarestorage.com
CLOUDFLARE_R2_ACCESS_KEY_ID=your-access-key-id
CLOUDFLARE_R2_SECRET_ACCESS_KEY=your-secret-access-key
```

### 4. Build and Deploy
1. Push to main branch or create a release tag
2. GitHub Actions will automatically build and push to R2
3. Monitor the workflow in Actions tab

### 5. Local Testing
```bash
# Build locally
./build.sh

# Test the image
./test-image.sh

# Run interactive shell
docker run -it gateman-face-base:latest /bin/bash
```

## 📦 Using the Base Image

### In your Dockerfile:
```dockerfile
FROM your-account-id.r2.cloudflarestorage.com/gateman-face-base:latest
# Your application code here
```

### Pull from R2:
```bash
docker login your-account-id.r2.cloudflarestorage.com
docker pull your-account-id.r2.cloudflarestorage.com/gateman-face-base:latest
```

## 🔧 Troubleshooting

### Build Issues:
- Ensure Docker has 8GB+ memory allocated
- Check internet connection for package downloads
- Verify all GitHub secrets are set correctly

### Runtime Issues:
- Run `./test-image.sh` to verify all dependencies
- Check library paths with `ldconfig -p`
- Ensure proper linking flags in your build

## 📞 Support
- Check the main README.md for detailed documentation
- Create issues for bugs or questions
- Review example/ directory for usage patterns
