# Use Ubuntu 12.04
FROM ubuntu:12.04

# Avoid interactive dialog during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Update package list for old Ubuntu
RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

# Install essential build tools and dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    g++ \
    cmake \
    pkg-config \
    wget \
    git \
    libx11-dev \
    # Qt4 packages
    libqt4-dev \
    libqt4-xml \
    libqtcore4 \
    libqtgui4 \
    qt4-dev-tools \
    # OpenCV packages
    libopencv-dev \
    libcv-dev \
    libhighgui-dev \
    # Additional dependencies for Qxt
    libssl-dev \
    libdb-dev \
    # Debug tools
    gdb \
    strace \
    valgrind \
    # Additional required libraries
    libicu48 \
    libdc1394-22 \
    libdc1394-22-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install Qxt 0.6.2
RUN wget https://bitbucket.org/libqxt/libqxt/get/v0.6.2.tar.gz && \
    tar xf v0.6.2.tar.gz && \
    cd libqxt-libqxt-* && \
    ./configure -prefix /usr -no-db -no-zeroconf && \
    make && \
    make install && \
    cd .. && \
    rm -rf libqxt-libqxt-* v0.6.2.tar.gz

# Install additional font and image dependencies
RUN apt-get update && \
    apt-get install -y \
    fontconfig \
    libfontconfig1 \
    libfreetype6 \
    ttf-dejavu \
    libpng12-0 \
    && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/fonts/truetype && \
    fc-cache -f -v

# Set environment variable for Qt debugging
ENV QT_DEBUG_PLUGINS=1

# Create symbolic links for OpenCV
RUN ln -sf /usr/lib/libopencv_core.so.2.3 /usr/lib/libcxcore.so.4 && \
    ln -sf /usr/lib/libopencv_imgproc.so.2.3 /usr/lib/libcv.so.4 && \
    ln -sf /usr/lib/libopencv_highgui.so.2.3 /usr/lib/libhighgui.so.4 && \
    ln -sf /usr/lib/libopencv_calib3d.so.2.3 /usr/lib/libcvaux.so.4 && \
    ldconfig

# Copy your configure script and existing Lib directory
COPY configure.sh /app/
COPY Lib/ /app/Lib/

# Make the configure script executable and modify it to ignore existing links
RUN chmod +x /app/configure.sh && \
    sed -i 's/ln -s/ln -sf/g' /app/configure.sh

# Run the configure script
RUN ./configure.sh

# Set display environment variable
ENV DISPLAY=:0

# Default command
CMD ["/bin/bash"]

