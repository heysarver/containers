# B43 Firmware Cutter

Docker container to extract Broadcom b43 wireless firmware for offline Ubuntu installations.

## Purpose

This container extracts proprietary Broadcom wireless firmware that's required for certain wireless cards (especially older Broadcom BCM43xx series) during Ubuntu installations where internet connectivity isn't available.

## What it does

- Downloads Broadcom wireless driver source (`broadcom-wl-5.100.138.tar.bz2`)
- Uses `b43-fwcutter` to extract firmware files from the proprietary driver
- Outputs firmware files ready for manual installation

## Usage

### Build the container
```bash
docker build -t b43-fwcutter .
```

### Extract firmware to local directory
```bash
docker run --rm -v $(pwd)/firmware-output:/host-output b43-fwcutter
```

This creates a `firmware-output/b43/` directory containing the extracted firmware files.

## Using during Ubuntu installation

1. **Extract firmware** using this container on a machine with internet access
2. **Copy to USB**: Copy the entire `b43/` directory to a USB drive
3. **During Ubuntu installation**:
   - Mount the USB drive
   - Copy firmware files to `/lib/firmware/b43/`
   - Load the b43 kernel module

### Manual installation commands
```bash
# Mount USB (adjust device path as needed)
sudo mkdir /mnt/usb
sudo mount /dev/sdb1 /mnt/usb

# Copy firmware files
sudo mkdir -p /lib/firmware
sudo cp -r /mnt/usb/b43 /lib/firmware/

# Load the b43 module
sudo modprobe b43
```

## Supported hardware

This firmware works with Broadcom wireless cards that use the b43 driver, including:
- BCM4306, BCM4311, BCM4318, BCM4321, BCM4322, BCM4331
- And other legacy Broadcom wireless chipsets

## Files extracted

The container extracts multiple firmware files to `b43/` directory:
- `ucode*.fw` - Microcode files
- `b0g0*.fw` - Firmware variants
- `lp0*.fw` - Low-power variants
- `n0*.fw` - N-PHY variants

## Alternative solutions

- Install `bcmwl-kernel-source` package if you have internet connectivity
- Use `firmware-b43-installer` package for automatic extraction
- Download firmware manually from manufacturer

## Troubleshooting

**No wireless interface detected:**
- Verify your card uses b43 driver: `lspci | grep -i broadcom`
- Check if firmware loaded: `dmesg | grep b43`
- Try reloading module: `sudo modprobe -r b43 && sudo modprobe b43`

**Permission issues:**
- Ensure firmware files have correct ownership: `sudo chown -R root:root /lib/firmware/b43`
- Verify permissions: `sudo chmod -R 644 /lib/firmware/b43` 
