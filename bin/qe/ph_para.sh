#! /bin/bash

#为生成ph-para.sh多节点声子计算脚本，首先需要获取体系的不可约q点数=节点数
#获取不可约q点数目：运行30s单节点ph计算得到dyn0，将dyn0文件包含的不可约q点数赋值为N
jobid=$(sbatch ph.sh | awk '{print $4}')
sleep 30s && $(echo "scancel $jobid")
rm slurm-$jobid.out
N=$(sed -n '2p' *.dyn0 | awk '{print $1}')

#修改脚本文件使用节点数N=$N
cp -v  ph.sh ph-para.sh
sed -i "/#SBATCH -N/c\#SBATCH -N $N" ph-para.sh

#修改脚本文件使用核数n=$((N * 128))
n=$((N * 128))
sed -i "/#SBATCH -n/c\#SBATCH -n $n" ph-para.sh

#修改运行命令使用的节点数ni=$N和核数np=$((N * 128))
sed -i "/mpirun/c\mpirun -np $n ph.x -ni $N -nk 64 < ph-para.in > ph-para.out" ph-para.sh

