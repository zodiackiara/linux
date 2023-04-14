#! /bin/bash

#前置操作：结构优化完成
#pwd==/vasp/scf

#复制原始relax/POSCAR为relax/POSCAR-init，将CONTCAR重命名为POSCAR，并复制到所有文件夹中
cp -v ../relax/POSCAR ../relax/POSCAR-init
mv -v ../relax/CONTCAR ../relax/POSCAR
echo ../*/ | xargs -n 1 cp -v ../relax/POSCAR

#复制原始relax/KPOINTS为relax/KPOINTS-init，复制relax/KPOINTS，并将K点修改为原来的两倍后，复制KPOINTS到所有文件夹
cp -v ../relax/KPOINTS ../relax/KPOINTS-init
cp -v ../relax/KPOINTS .
awk 'NR==4{for(i=1;i<=NF;i++) $i*=2}1' KPOINTS > temp && mv temp KPOINTS
echo ../*/ | xargs -n 1 cp -v KPOINTS

