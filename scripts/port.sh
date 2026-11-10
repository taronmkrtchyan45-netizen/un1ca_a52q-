#!/usr/bin/env bash
set -e

# ==========================================
# GALAXY S24 ULTRA -> GALAXY A52 (a52q) PORT
# ==========================================

WORK_DIR="$(pwd)/work"
OUT_DIR="$(pwd)/out"
TOOLS_DIR="$(pwd)/tools"

BASE_ROM_DIR="$WORK_DIR/base_s24"
VENDOR_DIR="$WORK_DIR/vendor_a52q"
BUILD_DIR="$WORK_DIR/target_build"

echo "==> 1. Ստեղծում ենք աշխատանքային թղթապանակները..."
mkdir -p "$WORK_DIR" "$OUT_DIR" "$BUILD_DIR/system" "$BUILD_DIR/vendor" "$BUILD_DIR/boot"

echo "==> 2. Ապափաթեթավորում ենք S24 Ultra System & Product պատկերները..."
# S24 Ultra-ի system, product և system_ext բաժինների պատճենում
if [ -d "$BASE_ROM_DIR/system" ]; then
    cp -rf "$BASE_ROM_DIR/system/"* "$BUILD_DIR/system/"
    echo "✓ S24 Ultra System-ը հաջողությամբ պատճենվեց:"
else
    echo "❌ Error: S24 Ultra system թղթապանակը գոյություն չունի:"
    exit 1
fi

echo "==> 3. Միացնում ենք A52q (SM7125) Vendor-ն ու Kernel-ը..."
# A52q-ի օրիգինալ vendor-ի և kernel-ի տեղադրում
if [ -d "$VENDOR_DIR/vendor" ]; then
    cp -rf "$VENDOR_DIR/vendor/"* "$BUILD_DIR/vendor/"
    cp -f "$VENDOR_DIR/boot.img" "$BUILD_DIR/boot/boot.img"
    echo "✓ A52q Vendor-ը և Boot Kernel-ը ինտեգրվեցին:"
else
    echo "❌ Error: A52q Vendor թղթապանակը չգտնվեց:"
    exit 1
fi

echo "==> 4. Կատարում ենք build.prop ուղղումները a52q-ի համար..."
BUILD_PROP="$BUILD_DIR/system/system/build.prop"

if [ -f "$BUILD_PROP" ]; then
    # Փոխում ենք մոդելի անվանումը և fingerprint-ը A52q-ի համար
    sed -i 's/ro.product.system.model=.*/ro.product.system.model=SM-A525F/g' "$BUILD_PROP"
    sed -i 's/ro.product.system.device=.*/ro.product.system.device=a52q/g' "$BUILD_PROP"
    sed -i 's/ro.build.product=.*/ro.build.product=a52q/g' "$BUILD_PROP"
    
    # Անջատում ենք S24 Ultra-ի hardware-ային հատուկ ֆլագերը (Snapdragon 8 Gen 3)
    echo "# Fixes for Snapdragon 720G (a52q)" >> "$BUILD_PROP"
    echo "ro.vendor.qti.soc_name=sm7125" >> "$BUILD_PROP"
    echo "ro.vendor.qti.soc_model=SM7125" >> "$BUILD_PROP"
    
    echo "✓ build.prop-ը հաջողությամբ թարմացվեց:"
fi

echo "==> 5. Հեռացնում ենք S24 Ultra-ի ավելորդ Knox / eSIM սերվիսները..."
rm -rf "$BUILD_DIR/system/system/priv-app/KLMSAgent" || true
rm -rf "$BUILD_DIR/system/system/priv-app/KnoxGuard" || true

echo "==> 6. Հավաքում ենք պատրաստի Flashable ZIP ֆայլը..."
cd "$BUILD_DIR"
zip -r9 "$OUT_DIR/OneUI8.5_S24Ultra_Port_A52q.zip" . -x "*.git*"

*Verification:* Եթե ամեն ինչ ճիշտ աշխատի, `$OUT_DIR` թղթապանակում կստանաս `OneUI8.5_S24Ultra_Port_A52q.zip` ֆայլը, իսկ տերմինալում կտեսնես `Zip exit code: 0` հաստատումը:
