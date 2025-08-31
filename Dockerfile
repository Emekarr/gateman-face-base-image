# Gateman Face Service Base Image
# Multi-stage build for optimized base image with all dependencies

FROM ubuntu:22.04 as builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_BUILD_TYPE=Release
ENV MAKEFLAGS="-j$(nproc)"

# Install system packages and build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libhiredis-dev \
    libtbb-dev \
    libopencv-dev \
    libopencv-contrib-dev \
    libdlib-dev \
    libdlib19 \
    nlohmann-json3-dev \
    libasio-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    libsqlite3-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    curl \
    wget \
    bzip2 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Build Crow HTTP framework from source
RUN git clone https://github.com/CrowCpp/Crow.git /tmp/crow \
    && cd /tmp/crow \
    && mkdir build && cd build \
    && cmake .. -DCROW_BUILD_EXAMPLES=OFF -DCROW_BUILD_TESTS=OFF \
    && make -j$(nproc) \
    && make install \
    && ldconfig

# Build optimized dlib
RUN git clone https://github.com/davisking/dlib.git /tmp/dlib \
    && cd /tmp/dlib \
    && mkdir build && cd build \
    && cmake .. -DUSE_AVX_INSTRUCTIONS=ON -DUSE_SSE4_INSTRUCTIONS=ON \
    && make -j$(nproc) \
    && make install \
    && ldconfig

# Build OpenCV with contrib modules
RUN git clone https://github.com/opencv/opencv.git /tmp/opencv \
    && git clone https://github.com/opencv/opencv_contrib.git /tmp/opencv_contrib \
    && cd /tmp/opencv \
    && mkdir build && cd build \
    && cmake .. \
        -DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DWITH_CUDA=OFF \
        -DWITH_OPENCL=OFF \
    && make -j$(nproc) \
    && make install \
    && ldconfig

# Runtime stage
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libcurl4 \
    libssl3 \
    libhiredis0.14 \
    libtbb2 \
    libopencv-core4.5d \
    libopencv-imgproc4.5d \
    libopencv-imgcodecs4.5d \
    libopencv-highgui4.5d \
    libopencv-objdetect4.5d \
    libopencv-calib3d4.5d \
    libdlib19 \
    libboost-system1.74.0 \
    libboost-thread1.74.0 \
    libblas3 \
    liblapack3 \
    libatlas3-base \
    libsqlite3-0 \
    libavcodec58 \
    libavformat58 \
    libavutil56 \
    libswscale5 \
    && rm -rf /var/lib/apt/lists/*

# Copy built libraries from builder stage
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include

# Update library cache
RUN ldconfig

# Set working directory
WORKDIR /app

# Default command
CMD ["/bin/bash"]
