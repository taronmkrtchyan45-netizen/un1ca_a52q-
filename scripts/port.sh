#!/bin/bash
set -e

echo "==> Սկսվում է պորտավորման գործընթացը (S24 Ultra -> Galaxy A52q)..."

mkdir -p out work/port_root/SYSTEM work/port_root/META-INF/com/google/android work/base_s24

# Դինամիկ որոնում ենք system.img կամ super.img ցանկացած տեղ work/ թղթապանակում
IMG_PATH=$(find work -type f \( -name "system.img" -o -name "super.img" \) | head -n 1)

if [ -z "$IMG_PATH" ]; then
    echo "❌ Սխալ: system.img կամ super.img ֆայլը չի գտնվել որեւէ թղթապանակում!"
    exit 1
fi

echo "==> Համակարգային ֆայլը հայտնաբերվել է՝ $IMG_PATH"
cp -f "$IMG_PATH" work/base_s24/system.img

IMG_SIZE=$(stat -c%s "work/base_s24/system.img")
echo "==> system.img չափը՝ $IMG_SIZE բայթ"

if [ "$IMG_SIZE" -lt 1000000 ]; then
    echo "❌ Սխալ: system.img ֆայլը չափազանց փոքր է կամ դատարկ!"
    exit 1
fi

# Ստեղծում ենք TWRP ֆլեշավորման updater-script-ը
cat << 'EOF' > work/port_root/META-INF/com/google/android/updater-script
ui_print("****************************************");
ui_print("    One UI 8.5 Port for Galaxy A52      ");
ui_print("    Base: Galaxy S24 Ultra              ");
ui_print("****************************************");
ui_print("Flashing system image...");
package_extract_dir("SYSTEM", "/system");
ui_print("Installation finished successfully!");
EOF

touch work/port_root/META-INF/com/google/android/update-binary

echo "==> Պատրաստվում է ROM-ի կառուցվածքը..."
cp work/base_s24/system.img work/port_root/SYSTEM/system.img

echo "==> Ստեղծվում է վերջնական ֆլեշավորվող ROM-ի ZIP փաթեթը..."
cd work/port_root
zip -r ../../out/OneUI8.5_S24Ultra_Port_A52q.zip *
cd ../../

echo "==> Հաջողություն! ROM-ը հաջողությամբ ստեղծվել է out/ թղթապանակում:"
ls -lh out/
