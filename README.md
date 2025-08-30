# Gateman Face Service Base Image

A pre-built Docker base image containing all heavy dependencies for the Gateman Face Service, optimized to speed up application builds.

## Overview

This base image includes pre-compiled versions of heavy dependencies that are commonly used in computer vision and machine learning applications:

- **OpenCV** with contrib modules (optimized build)
- **dlib** (optimized build with AVX/SSE4 instructions)
- **Crow HTTP framework** (v1.0+5)
- **BLAS/LAPACK** (OpenBLAS optimized build)
- **Boost libraries** (system and thread)
- **OpenSSL, cURL, SQLite, and other runtime dependencies**

## Architecture

This image uses a multi-stage build:
- **Builder stage**: Installs build dependencies and compiles libraries from source
- **Runtime stage**: Minimal Ubuntu image with only necessary runtime dependencies

## Included Dependencies

### System Packages (Build)
- build-essential, cmake, git, pkg-config
- libssl-dev, libcurl4-openssl-dev, libhiredis-dev
- libtbb-dev, libopencv-dev, libopencv-contrib-dev
- libdlib-dev, nlohmann-json3-dev, libasio-dev
- libblas-dev, liblapack-dev, libatlas-base-dev
- libsqlite3-dev, libboost-system-dev, libboost-thread-dev

### Runtime Dependencies
- libcurl4, libssl3, libhiredis0.14, libtbb2
- libopencv-core4.5d, libopencv-imgproc4.5d, libopencv-imgcodecs4.5d
- libopencv-highgui4.5d, libopencv-objdetect4.5d, libopencv-calib3d4.5d
- libdlib19, libboost-system1.74.0, libboost-thread1.74.0
- libblas3, liblapack3, libatlas3-base, libsqlite3-0

### Build Tools
- curl, wget, bzip2, unzip

### Compiled Libraries
- Crow HTTP framework (v1.0+5)
- dlib (v19.24, optimized)
- OpenCV (v4.5.5 with contrib modules)
- OpenBLAS (v0.3.21)

## Usage

### Using the Pre-built Image

```dockerfile
FROM ghcr.io/emekarr/gateman-infra/gateman-face-base-image:latest

# Copy your application code
COPY . /app

# Build your application
RUN cmake . && make

# Run your application
CMD ["./your-face-service"]
```

### Building Locally

```bash
# Build the image locally
./build.sh

# Build and push to registry
./build.sh --push

# Build with specific tag
./build.sh --push --tag v1.0.0

# Build without cache
./build.sh --no-cache
```

## Environment Variables

The image sets the following environment variables:
- `DEBIAN_FRONTEND=noninteractive`
- `CMAKE_BUILD_TYPE=Release`
- `MAKEFLAGS="-j$(nproc)"`

## Image Size Optimization

- Multi-stage build reduces final image size
- Only essential runtime dependencies included
- Build artifacts cleaned up in intermediate stages
- Optimized compilation flags used for all libraries

## CI/CD

The image is automatically built and pushed to GitHub Container Registry when:
- Code is pushed to the `main` branch
- A new tag is created (following semantic versioning)
- Pull requests are opened (builds for testing only)

### Version Tags

- `latest`: Latest build from main branch
- `v{major}.{minor}.{patch}`: Specific version tags
- `v{major}.{minor}`: Major.minor version tags
- `pr-{number}`: Pull request builds

## Development

### Prerequisites

- Docker
- Git

### Local Development

1. Clone the repository
2. Make changes to the Dockerfile or build scripts
3. Test locally: `./build.sh`
4. Push changes to trigger CI/CD

### Testing the Image

The GitHub Actions workflow includes a test build that verifies:
- Image builds successfully
- Required packages are installed
- Build tools are available
- Basic functionality works

## Troubleshooting

### Build Issues

If you encounter build issues:

1. Clear Docker cache: `docker system prune -a`
2. Rebuild without cache: `./build.sh --no-cache`
3. Check available disk space

### Runtime Issues

If your application fails at runtime:
- Verify all required dependencies are included in the base image
- Check that your application links correctly against the installed libraries
- Ensure environment variables are set correctly

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Submit a pull request

## License

This project is part of the Gateman infrastructure and follows the same licensing terms.

