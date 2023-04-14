#!/bin/bash
#前置操作：c-bands计算完成

#复制c-bands.in，提取并输出scf.out的价带数量val，修改nbnd数值
#能带结构计算需要的导带数不多，val不大于20时nbnd=2*val，val大于20时nbnd=val+20
cp -v c-bands.in f-bands.in
val=$(grep "number of electrons" ../qe/scf.out | awk '{print ($5)*0.5}')
if [[ "$val" -le 20 ]]; then
    nbnd=$(($val*2)) && echo "nbnd = $nbnd"
else
    nbnd=$(($val+20)) && echo "nbnd = $nbnd"
fi
sed -i "/nbnd = /c\    nbnd = $nbnd" f-bands.in

#删除K_POINTS之后所有行
sed -i '/K_POINTS/,$d' f-bands.in 
echo "K_POINTS crystal_b" >> f-bands.in

#根据scf.in文件中布拉维格子类型，输入不同高对称k点路径
#hp高对称路径：G-M-K-G
#cf高对称路径：G-X-W-K-G
#op高对称路径：G-X-S-Y-G
#mp高对称路径：G-Y-C-E-A
type=$(grep bravais ../qe/scf.in | awk '{print $5}')
if [ $type == "hp" ]; then
    echo "4" >> f-bands.in
    echo "0.00  0.00  0.00  50" >> f-bands.in
    echo "0.50  0.00  0.00  50" >> f-bands.in
    echo "0.33  0.33  0.00  50" >> f-bands.in
	echo "0.00  0.00  0.00  50" >> f-bands.in
elif [ $type == "cf" ]; then
    echo "5" >> f-bands.in
	echo "0.00  0.00  0.00  50" >> f-bands.in
	echo "0.50  0.00  0.50  50" >> f-bands.in
	echo "0.50  0.25  0.75  50" >> f-bands.in
    echo "0.375 0.375 0.75  50" >> f-bands.in
    echo "0.00  0.00  0.00  50" >> f-bands.in
elif [ $type == "op" ]; then
    echo "5" >> f-bands.in
    echo "0.00  0.00  0.00  50" >> f-bands.in
	echo "0.50  0.00  0.00  50" >> f-bands.in
	echo "0.50  0.50  0.00  50" >> f-bands.in
	echo "0.00  0.50  0.00  50" >> f-bands.in
    echo "0.00  0.00  0.00  50" >> f-bands.in
elif [ $type == "mp" ]; then
    echo "5" >> f-bands.in
    echo "0.00  0.00  0.00  50" >> f-bands.in
    echo "0.50  0.00  0.00  50" >> f-bands.in
    echo "0.50  0.50  0.00  50" >> f-bands.in
    echo "-0.50 0.50  0.50  50" >> f-bands.in
	echo "-0.50 0.00  0.50  50" >> f-bands.in
fi	