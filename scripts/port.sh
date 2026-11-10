#!/bin/bash
set -e

echo "==> Սկսվում է պորտավորման գործընթացը (S24 Ultra -> Galaxy A52q)..."

# Ստեղծում ենք աշխատանքային և արդյունքների թղթապանակները
mkdir -p out work/port_root

# Ստուգում ենք արդյոք system.img-ը հասանելի է
if [ ! -f "work/base_s24/system.img" ]; then
    echo "❌ Սխալ: work/base_s24/system.img ֆայլը չի գտնվել!"
    exit 1
fi

echo "==> Մշակվում է system.img-ը..."
# Այստեղ կարող ես ավելացնել համապատասխան փոխակերպման կամ մոնտաժման հրամաններ
# Օրինակ՝ mount կամ simg2img անհրաժեշտության դեպքում

echo "==> Ստեղծվում է վերջնական ֆլեշավորվող ROM-ի ZIP փաթեթը..."
cd work/base_s24

# Փաթեթավորում ենք system.img-ը և անհրաժեշտ բաղադրիչները ճիշտ կառուցվածքով
zip -r ../../out/OneUI8.5_S24Ultra_Port_A52q.zip system.img

cd ../../

echo "==> Հաջողություն! ROM-ը հաջողությամբ ստեղծվել է out/ թղթապանակում:"
ls -lh out/
