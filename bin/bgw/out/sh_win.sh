#! /bin/bash
#前置操作：sigma计算完成
#前置操作：vasp的dos计算完成，分析PDOS图像确认投影轨道，以确认num_wann数值
#目的：通过wannier90预处理计算生成eig.nnkp，用于sig2wan计算

#根据投影轨道输入num_wann值，提取sigma的band_index_max值赋值给num_bands
#关系式：band_index_max(sigma)=nbands(sig2wan)=num_bands(eig.win)=nbnd(nscf)>nbndsub(epw)
read -p "num_wann=" wann
echo "num_wann = $wann" > eig.win
bands=$(grep max sigma.inp | awk '{print $2}')
echo "num_bands = $bands" >> eig.win

#提取c-bands中的晶胞参数
echo "begin unit_cell_cart" >> eig.win
echo "ang" >> eig.win
line=$(sed -n '/CELL_PARAMETERS/=' ../c-bands.in)
sed -n "$((line+1)),$((line+3))p" ../c-bands.in >> eig.win
echo "end unit_cell_cart" >> eig.win

#提取c-bands.in的原子位置
echo "begin atoms_frac" >> eig.win
sed -n '/ATOMIC_POSITIONS/,/K_POINTS/p' ../c-bands.in | sed '1d;$d' >> eig.win 
echo "end atoms_frac" >> eig.win

#提取c-kgrid.in的k点网格
grid=$(head -n1 ../c-kgrid.in)
echo "mp_grid = $grid" >> eig.win

#添加c-kgrid.out文件中所有的k点
echo "begin kpoints" >> eig.win
sed '1,2d' ../c-kgrid.out > temp
sed -i 's/...$//' temp           
cat temp >> eig.win && rm temp
echo "end kpoints" >> eig.win