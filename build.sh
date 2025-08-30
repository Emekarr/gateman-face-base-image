#!/bin/bash

# Gateman Face Base Image Build Script
# This script builds the base image locally for testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="gateman-face-base"
TAG="${1:-latest}"

echo -e "${GREEN}🚀 Building Gateman Face Base Image${NC}"
echo -e "${YELLOW}Image: ${IMAGE_NAME}:${TAG}${NC}"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Build the image
echo -e "${YELLOW}📦 Building Docker image...${NC}"
docker build \
    --platform linux/amd64 \
    --memory=8g \
    --memory-swap=8g \
    -t "${IMAGE_NAME}:${TAG}" \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Image built successfully!${NC}"
    echo ""
    echo -e "${YELLOW}📊 Image details:${NC}"
    docker images "${IMAGE_NAME}:${TAG}"
    echo ""
    echo -e "${YELLOW}🧪 To test the image:${NC}"
    echo "docker run -it ${IMAGE_NAME}:${TAG} /bin/bash"
    echo ""
    echo -e "${YELLOW}🔍 To verify installations:${NC}"
    echo "docker run ${IMAGE_NAME}:${TAG} pkg-config --modversion opencv4"
    echo "docker run ${IMAGE_NAME}:${TAG} pkg-config --modversion dlib-1"
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi
