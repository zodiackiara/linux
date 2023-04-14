#! /bin/bash

#前置操作：自洽计算已完成；手动生成高对称k点路径文件KPOINTS用于能带计算
#pwd==/vasp/band

#复制自洽计算生成的WAVECAR和CHGCAR
ln -sfrv ../scf/WAVECAR .
ln -sfrv ../scf/CHGCAR .

#将scf.sh复制的KPOINTS重命名为KPOINTS-scf，新建KPOINTS文件并根据输入的布拉维格子类型写入高对称K点路径
mv -v KPOINTS KPOINTS-scf
echo "kpath for band-structure calculation" > KPOINTS
echo "40" >> KPOINTS
echo "line-mode" >> KPOINTS 
echo "reciprocal" >> KPOINTS


#hp高对称路径：G-M-K-G
#cf高对称路径：G-X-W-K-G
#op高对称路径：G-X-S-Y-G
#mp高对称路径：G-Y-C-E-A
#oc高对称路径：G-S-R-Z-G
read -p "bravais lattice type= " type
if [ $type == "hp" ]; then
echo "" >> KPOINTS
elif [ $type == "cf" ]; then
echo "" >> KPOINTS
elif [ $type == "op" ]; then
echo "" >> KPOINTS
elif [ $type == "op" ]; then
echo "" >> KPOINTS
elif [ $type == "mp" ]; then
    echo "0.00  0.00  0.00  G" >> KPOINTS
    echo "0.50  0.00  0.00  Y" >> KPOINTS
    echo "" >> KPOINTS
    echo "0.50  0.00  0.00  Y" >> KPOINTS
    echo "0.50  0.50  0.00  C" >> KPOINTS
    echo "" >> KPOINTS
    echo "0.50  0.50  0.00  C" >> KPOINTS
    echo "-0.50 0.50  0.50  E" >> KPOINTS
    echo "" >> KPOINTS
    echo "-0.50 0.50  0.50  E" >> KPOINTS
    echo "-0.50 0.00  0.50  A" >> KPOINTS
elif [ $type == "oc" ]; then
    echo "0.00  0.00  0.00  G" >> KPOINTS
    echo "0.00  0.50  0.00  S" >> KPOINTS
    echo "" >> KPOINTS
    echo "0.00  0.50  0.00  S" >> KPOINTS
    echo "0.00  0.50  0.50  R" >> KPOINTS
    echo "" >> KPOINTS
    echo "0.00  0.50  0.50  R" >> KPOINTS
    echo "0.00  0.00  0.50  Z" >> KPOINTS
    echo "" >> KPOINTS
    echo "0.00  0.00  0.50  Z" >> KPOINTS
    echo "0.00  0.00  0.00  G" >> KPOINTS
fi	