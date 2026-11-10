#!/bin/bash
set -e

echo "=== 1. AIK (Android Image Kitchen) ներբեռնում ==="
git clone https://github.com/OSR-GFX/Android-Image-Kitchen.git aik
cd aik

echo "=== 2. Boot.img-ի ներբեռնում curl-ով ==="
# Փոխարինեք ներքևի URL-ը ձեր boot.img-ի իրական (ուղիղ) հղումով
BOOT_URL="https://example.com/path/to/your/boot.img"
curl -L -o boot.img "$BOOT_URL"

echo "=== 3. Boot.img-ի քանդում ==="
chmod +x unpackimg.sh repackimg.sh bin/magicmontage bin/mkbootimg bin/unpackbootimg
./unpackimg.sh boot.img

echo "=== 4. RAMDisk / fstab փոփոխություն A52 4G-ի համար ==="
# Փոխում ենք fstab-ի տողերը Dynamic Partitions-ին համապատասխանեցնելու համար
if [ -f "ramdisk/fstab.qcom" ]; then
    sed -i 's|/system|/system_root|g' ramdisk/fstab.qcom
    echo "fstab.qcom-ը հաջողությամբ փոխվեց:"
elif [ -f "ramdisk/default.prop" ]; then
    echo "ro.mount.fs.options.system=ro" >> ramdisk/default.prop
fi

echo "=== 5. Նոր Boot.img-ի հավաքում ==="
./repackimg.sh

echo "=== 6. Ֆայլի տեղափոխում ==="
cp image-new.img ../patched_boot.img
cd ..

echo "=== Պրոցեսն ավարտվեց։ patched_boot.img-ը պատրաստ է։ ==="
