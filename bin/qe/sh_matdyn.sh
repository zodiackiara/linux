#! /bin/bash

echo "&input" > matdyn.in
echo "    asr = 'crystal'" >> matdyn.in

#提取scf.in中prefix的值=$prefix
prefix=$(grep 'prefix = ' scf.in | awk '{print $3}' | awk -F"[']" '{print $2}')

echo "    flfrc = '$prefix.fc'" >> matdyn.in
echo "    flfrq = '$prefix.freq'" >> matdyn.in
echo "    q_in_band_form = true" >> matdyn.in
echo "    q_in_cryst_coord = true" >> matdyn.in
echo "/" >> matdyn.in

#根据scf.in中布拉维格子类型，写入不同高对称q点路径
#hp高对称路径：G-M-K-G
#cf高对称路径：G-X-W-K-G
#op高对称路径：G-X-S-Y-G
#mp高对称路径：G-Y-C-E-A
type=$(grep bravais scf.in | awk '{print $5}')
if [ $type == "hp" ]; then
    echo "4" >> matdyn.in
    echo "0.00  0.00  0.00  50" >> matdyn.in
    echo "0.50  0.00  0.00  50" >> matdyn.in
    echo "0.33  0.33  0.00  50" >> matdyn.in
	echo "0.00  0.00  0.00  50" >> matdyn.in
elif [ $type == "cf" ]; then
    echo "5" >> matdyn.in
	echo "0.00  0.00  0.00  50" >> matdyn.in
	echo "0.50  0.00  0.50  50" >> matdyn.in
	echo "0.50  0.25  0.75  50" >> matdyn.in
    echo "0.375 0.375 0.75  50" >> matdyn.in
    echo "0.00  0.00  0.00  50" >> matdyn.in
elif [ $type == "op" ]; then
    echo "5" >> matdyn.in
    echo "0.00  0.00  0.00  50" >> matdyn.in
	echo "0.50  0.00  0.00  50" >> matdyn.in
	echo "0.50  0.50  0.00  50" >> matdyn.in
	echo "0.00  0.50  0.00  50" >> matdyn.in
    echo "0.00  0.00  0.00  50" >> matdyn.in
elif [ $type == "mp" ]; then
    echo "5" >> matdyn.in
    echo "0.00  0.00  0.00  50" >> matdyn.in
	echo "0.50  0.00  0.00  50" >> matdyn.in
	echo "0.50  0.50  0.00  50" >> matdyn.in
	echo "-0.50 0.50  0.50  50" >> matdyn.in
	echo "-0.50 0.00  0.50  50" >> matdyn.in
fi	