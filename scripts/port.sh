#!/bin/bash
set -e

echo "==> Սկսվում է պորտավորման գործընթացը (S24 Ultra -> Galaxy A52q)..."

mkdir -p out work/port_root/SYSTEM work/port_root/META-INF/com/google/android

# Ստուգում ենք արդյոք system.img-ը հասանելի է և չափը մեծ է
if [ ! -f "work/base_s24/system.img" ]; then
    echo "❌ Սխալ: work/base_s24/system.img ֆայլը չի գտնվել!"
    exit 1
fi

IMG_SIZE=$(stat -c%s "work/base_s24/system.img")
echo "==> system.img չափը՝ $IMG_SIZE բայթ"

if [ "$IMG_SIZE" -lt 1000000 ]; then
    echo "❌ Սխալ: system.img ֆայլը չափազանց փոքր է կամ դատարկ!"
    exit 1
fi

echo "==> Պատրաստվում է ROM-ի կառուցվածքը..."
cp work/base_s24/system.img work/port_root/SYSTEM/system.img

echo "==> Ստեղծվում է վերջնական ֆլեշավորվող ROM-ի ZIP փաթեթը..."
cd work/port_root
zip -r ../../out/OneUI8.5_S24Ultra_Port_A52q.zip *
cd ../../

echo "==> Հաջողություն! ROM-ը հաջողությամբ ստեղծվել է out/ թղթապանակում:"
ls -lh out/
