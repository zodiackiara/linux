#! /bin/bash

#前置操作：设置好vasp.sh中的节点数和核数
#前置操作：将初始POSCAR复制到relax文件夹，在relax文件夹使用vaspkit生成KPOINTS和POTCAR
#pwd==/vasp/relax/
#目前包含relax scf dos band opt 文件夹，后续根据需要添加

#复制vasp.sh到所有文件夹
echo ../*/ | xargs -n 1 cp -v vasp.sh

#提取vasp.sh文件中的节点数N=$NPAR，替换所有文件夹内INCAR的NPAR值，并输出NPAR值
NPAR=$(grep '#SBATCH -N' vasp.sh | awk '{print $3}')
echo "NPAR = $NPAR"
sed -i "/NPAR = /c\NPAR = $NPAR" ../*/INCAR


#提取POSCAR包含的原子个数nat，当nat大于等于20时，设置所有文件夹内INCAR的LREAL = Auto，并输出nat值
nat=$(awk 'NR==7{sum=0; for(i=1; i<=NF; i++) sum+=$i} END{print sum}' POSCAR)
echo "nat = $nat"
if [[ "$nat" -ge 20 ]]; then
    sed -i "/LREAL = /c\LREAL = Auto" ../*/INCAR
fi

#提取POTCAR中的所有ENMAX，找出最大的ENMAX，赋值ENCUT=1.3*ENMAX，替换所有文件夹内INCAR的ENCUT值，并输出ENCUT值
#awk求最大值命令行：awk 'BEGIN{ max = 0} {if ($1 > max) max = $1; fi} END{printf "Max = %.1f\n",max}' data
ENMAX=$(grep ENMAX POTCAR | awk '{print $3}' | awk -F';' '{print $1}') 
ENCUT=$(echo "$ENMAX" | awk 'BEGIN{ max = 0} {if ($1 > max) max = $1; fi} END{print 1.3*max}')
echo "ENCUT = $ENCUT"
sed -i "/ENCUT = /c\ENCUT = $ENCUT" ../*/INCAR 

#将POTCAR复制到所有文件夹
echo ../*/ | xargs -n 1 cp -v POTCAR 


