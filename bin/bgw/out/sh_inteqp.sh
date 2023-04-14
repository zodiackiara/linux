#!/bin/bash
#前置操作：sigma计算完成，f-bands和f-pw2bgw计算完成生成WFN_fi文件
#目的：生成inteqp.inp用于能带结构计算

#复制eqp1.dat和WFN文件软链接，作为inteqp计算输入文件
ln -sfrv eqp1.dat eqp_co.dat
ln -sfrv WFN WFN_co

#提取scf.out文件中的价带数val
val=$(grep "number of electrons" ../../qe/scf.out | awk '{print ($5)*0.5}') 
echo "number_val_bands_coarse $val" > inteqp.inp
echo "number_val_bands_fine $val" >> inteqp.inp

#提取sig.inp的band_index_max，减去价带数为粗网格导带数
#提取f-bands.in的nbnd，减去价带数为细网格导带数
#粗网格导带数需要大于细网格导带数
coarse=$(grep max sigma.inp | awk '{print $2-'$val'}')
echo "number_cond_bands_coarse $coarse" >> inteqp.inp
fine=$(grep nbnd ../f-bands.in | awk '{print $3-'$val'}')
echo "number_cond_bands_fine $fine" >> inteqp.inp
echo "use_symmetries_coarse_grid" >> inteqp.inp
echo "no_symmetries_fine_grid" >> inteqp.inp
