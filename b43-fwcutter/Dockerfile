FROM ubuntu:24.04

# Install required packages
RUN apt-get update && apt-get install -y \
    b43-fwcutter \
    wget \
    curl \
    tar \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /firmware

# Download the Broadcom firmware source
RUN wget https://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2

# Extract the firmware archive
RUN tar xjf broadcom-wl-5.100.138.tar.bz2

# Create output directory for firmware files
RUN mkdir -p /output/lib/firmware

# Extract firmware using b43-fwcutter
RUN b43-fwcutter -w /output/lib/firmware broadcom-wl-5.100.138/linux/wl_apsta.o

# List the extracted firmware files
RUN ls -la /output/lib/firmware/b43/

# Set up entrypoint to copy files to mounted volume
COPY <<EOF /entrypoint.sh
#!/bin/bash
echo "Copying b43 firmware files to /host-output..."
cp -r /output/lib/firmware/b43 /host-output/
echo "Firmware files copied successfully!"
echo "Files copied:"
ls -la /host-output/b43/
EOF

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
