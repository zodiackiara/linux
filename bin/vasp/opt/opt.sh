#! /bin/bash

#前置操作：自洽计算已完成
#pwd==/vasp/opt

#复制自洽计算生成的WAVECAR和CHGCAR
ln -sfrv ../scf/WAVECAR .
ln -sfrv ../scf/CHGCAR .

#提取scf计算生成OUTCAR文件中的NBANDS值，将该值的2倍赋值给NBANDS并输出，然后替换INCAR的NBANDS值
NBANDS=$(grep NBANDS ../scf/OUTCAR | awk '{print 2*$NF}')
echo "NBANDS = $NBANDS"
sed -i "/NBANDS = /c\NBANDS = $NBANDS" INCAR


