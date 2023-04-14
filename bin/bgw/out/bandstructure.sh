#! /bin/bash
#前置操作：inteqp计算完成，查看bandstructure.dat确定能量上下限值
#目的：根据计算参数修改bandstructure.py脚本

#提取inteqp.inp的价带数，替换nv值
nv=$(grep "number_val_bands_coarse" inteqp.inp | awk '{print ($2)}')
sed -i "/nv = /c\nv = $nv" bandstructure.py

#根据bandstructure.dat确定emin和emax替换emin和emax数值
read -p "emin = " emin && read -p "emax = " emax
sed -i "/emin, emax = /c\emin, emax = $emin, $emax" bandstructure.py

#根据scf.in文件中布拉维格子类型，修改k点数以及对应高对称点
#hp高对称路径：G-M-K-G
#cf高对称路径：G-X-W-K-G
#op高对称路径：G-X-S-Y-G
#mp高对称路径：G-Y-C-E-A
type=$(grep bravais ../../qe/scf.in | awk '{print $5}')
if [ $type == "hp" ]; then
    sed -i "/k_special_index = /c\k_special_index = np.array([0, 50, 100, 150])" bandstructure.py
    sed -i "/k_special_label = /c\k_special_label = np.array(['G', 'M', 'K', 'G'])" bandstructure.py
elif [ $type == "cf" ]; then
    sed -i "/k_special_index = /c\k_special_index = np.array([0, 50, 100, 150, 200])" bandstructure.py
    sed -i "/k_special_label = /c\k_special_label = np.array(['G', 'X', 'W', 'K', 'G'])" bandstructure.py
elif [ $type == "op" ]; then
    sed -i "/k_special_index = /c\k_special_index = np.array([0, 50, 100, 150, 200])" bandstructure.py
    sed -i "/k_special_label = /c\k_special_label = np.array(['G', 'X', 'S', 'Y', 'G'])" bandstructure.py
elif [ $type == "op" ]; then
    sed -i "/k_special_index = /c\k_special_index = np.array([0, 50, 100, 150, 200])" bandstructure.py
    sed -i "/k_special_label = /c\k_special_label = np.array(['G', 'Y', 'C', 'E', 'A'])" bandstructure.py	
fi