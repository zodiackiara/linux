#! /bin/bash
#前置操作：wannier90预计算完成，生成eig.nnkp文件
#前置操作：sigma计算完成生成sigma_hp.log和eqp1.dat
#目的：生成本征电子能量文件prefix.eig用于epw计算

echo "sigma_hp.log" > sig2wan.inp 
echo "1" >> sig2wan.inp 
echo "1" >> sig2wan.inp
echo "eig.nnkp" >> sig2wan.inp 

#提取c-band.in中prefix的值
prefix=$(grep 'prefix = ' ../c-bands.in | awk '{print $3}' | awk -F"[']" '{print $2}')
echo "$prefix.eig" >> sig2wan.inp

#提取eig.win文件中的能带值赋值给nbnd
nbnd=$(grep num_bands eig.win | awk '{print ($3)}') #提取eig.win中num_bands的值
echo "$nbnd" >> sig2wan.inp
echo "1" >> sig2wan.inp