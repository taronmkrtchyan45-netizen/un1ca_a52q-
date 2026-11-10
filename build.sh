#!/bin/bash

# A52q One UI Port Build Script
# Ստեղծված է մեր նախագծի համար

set -e

ROM_NAME="UN1CA-A52Q-OneUI-Port.zip"
OUT_DIR="out"
WORK_DIR=$(pwd)

echo "=== Սկսում ենք ROM-ի հավաքման գործընթացը ==="

# Մաքրում ենք նախորդ հավաքման մնացորդները
rm -rf $OUT_DIR
mkdir -p $OUT_DIR

echo "[1/3] Ստուգում ենք անհրաժեշտ բաժանումները..."
if [ ! -f "boot.img" ]; then
    echo "Սխալ: boot.img ֆայլը չի գտնվել արմատային պապկայում։"
    exit 1
fi

echo "[2/3] Հավաքում ենք ֆայլերը ZIP արխիվի մեջ..."
mkdir -p build_temp

# Տեղափոխում ենք անհրաժեշտ բաղադրիչները
cp boot.img build_temp/
cp -r META-INF/ build_temp/ 2>/dev/null || echo "META-INF-ը բացակայում է, ստեղծեք այն"

# Եթե կան համակարգային img ֆայլեր
[ -f "system.img" ] && cp system.img build_temp/
[ -f "vendor.img" ] && cp vendor.img build_temp/

cd build_temp
zip -r9 "../$OUT_DIR/$ROM_NAME" ./*
cd ..

rm -rf build_temp

echo "=== Հաջողությամբ ավարտվեց! ==="
echo "Ձեր պատրաստի ROM-ը գտնվում է: $OUT_DIR/$ROM_NAME"
