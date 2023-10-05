#!/bin/bash
pip install --prefix=/usr bs4
pip install --prefix=/usr requests

for i in {1..3}; do
    python3 /tmp/download-firmware.py

    # If downloaded firmware is less than 100mb, retry after 15 seconds
    if [ $(stat -c%s "/tmp/linux-firmware.rpm") -lt 100000000 ]; then \
        echo "Error: File size of /tmp/linux-firmware.rpm is less than 100MB. Retrying in 15 seconds..."
        sleep 15
    else
        break
    fi
done

# If the download still fails after 3 attempts, throw an error and quit bash
if [ $(stat -c%s "/tmp/linux-firmware.rpm") -lt 100000000 ]; then \
    echo "Error: File size of /tmp/linux-firmware.rpm is less than 100MB after 3 attempts. The download likely failed or something else is wrong."
    exit 1
fi

mkdir /tmp/rocky-firmware
rpm2cpio /tmp/linux-firmware.rpm | cpio -idmv -D /tmp/rocky-firmware
mv -f /tmp/rocky-firmware/usr/lib/firmware/* /lib/firmware/
ls /lib/firmware
echo "After rocky-firmware.sh: $(sha256sum /lib/firmware/amd-ucode/microcode_amd.bin.xz)"
