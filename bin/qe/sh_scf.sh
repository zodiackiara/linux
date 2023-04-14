#! /bin/bash
#前置操作：relax计算完成
#目的：更改计算类型，删除electrons和ions行，将晶胞参数和原子位置替换为优化后的数据

#复制relax.in，更改calculation类型，删除结构优化参数
cp -v relax.in scf.in 
sed -i "/calculation/c\    calculation = 'scf'" scf.in
sed -i '/mixing_beta/,/cell_dynamics/{//!d;}' scf.in
sed -i '/cell_dynamics/d' scf.in

#使用优化结构替换原本的晶胞参数和原子位置
sed -i '/CELL_PARAMETERS/,$d' scf.in
awk  '/Begin final coordinates/,/End final coordinates/{print $0}' relax.out > temp
sed -i '1,4d' temp && sed -i '5d' temp && sed -i '$d' temp
cat temp >> scf.in && rm temp
tail -n 2 relax.in >> scf.in


