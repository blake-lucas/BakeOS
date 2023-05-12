#!/bin/bash
pip install --prefix=/usr bs4
pip install --prefix=/usr requests
python3 /tmp/download-firmware.py
#If downloaded firmware is less than 100mb throw an error and quit bash
if [ $(stat -c%s "/tmp/linux-firmware.rpm") -lt 100000000 ]; then \
    echo "Error: File size of /tmp/linux-firmware.rpm is less than 100MB. The download likely failed or something else is wrong."
    exit 1
fi
mkdir /tmp/rocky-firmware
rpm2cpio /tmp/linux-firmware.rpm | cpio -idmv -D /tmp/rocky-firmware
mv -f /tmp/rocky-firmware/usr/lib/firmware/* /lib/firmware/
ls /lib/firmware
echo "After rocky-firmware.sh: $(sha256sum /lib/firmware/amd-ucode/microcode_amd.bin.xz)"