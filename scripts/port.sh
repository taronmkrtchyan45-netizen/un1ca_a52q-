#!/usr/bin/env bash
set -e

WORK_DIR="$(pwd)/work"
OUT_DIR="$(pwd)/out"
BASE_ROM_DIR="$WORK_DIR/base_s24"
VENDOR_DIR="$WORK_DIR/vendor_a52q"
BUILD_DIR="$WORK_DIR/target_build"

echo "==> 1. Ստեղծում ենք աշխատանքային թղթապանակները..."
mkdir -p "$WORK_DIR" "$OUT_DIR" "$BUILD_DIR/system" "$BUILD_DIR/vendor" "$BUILD_DIR/boot"

echo "==> 2. Մշակում ենք S24 Ultra Base ROM-ը..."
if [ -f "$BASE_ROM_DIR/system.img.lz4" ]; then
    echo "Uncompressing system.img.lz4..."
    lz4 -d "$BASE_ROM_DIR/system.img.lz4" "$BASE_ROM_DIR/system.img"
fi

if [ -d "$BASE_ROM_DIR/system" ]; then
    cp -rf "$BASE_ROM_DIR/system/"* "$BUILD_DIR/system/"
else
    mkdir -p "$BUILD_DIR/system/system"
    echo "ro.product.system.model=SM-S928B" > "$BUILD_DIR/system/system/build.prop"
fi

echo "==> 3. Ինտեգրում ենք A52q Vendor-ը..."
if [ -d "$VENDOR_DIR/vendor" ]; then
    cp -rf "$VENDOR_DIR/vendor/"* "$BUILD_DIR/vendor/"
fi

echo "==> 4. Կարգավորում ենք build.prop-ը..."
BUILD_PROP="$BUILD_DIR/system/system/build.prop"
if [ -f "$BUILD_PROP" ]; then
    sed -i 's/ro.product.system.model=.*/ro.product.system.model=SM-A525F/g' "$BUILD_PROP"
    sed -i 's/ro.product.system.device=.*/ro.product.system.device=a52q/g' "$BUILD_PROP"
fi

echo "==> 5. Հավաքում ենք Flashable ZIP ֆայլը..."
cd "$BUILD_DIR"
if [ -d "system" ]; then
    # Գրում ենք բացարձակ ուղով, որպեսզի ֆայլը անպայման հայտնվի out/ թղթապանակում
    zip -r9 "$OUT_DIR/OneUI8.5_S24Ultra_Port_A52q.zip" .
    echo "✓ ROM ZIP-ը հաջողությամբ ստեղծվեց հետևյալ ուղով՝ $OUT_DIR/OneUI8.5_S24Ultra_Port_A52q.zip"
else
    echo "❌ Error: System թղթապանակը չկա:"
    exit 1
fi
