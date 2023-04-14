#!/bin/bash

#SBATCH -p amd_512       #指定分区
#SBATCH -N 1             #指定节点数量，每个节点128个核
#SBATCH -n 128           #指定核数，一般n=128*N

source /public1/soft/modules/module.sh         #加载module工具
module purge                                   #移除所有加载的软件
module load qe/7.0.0-oneAPI.2022.1             #加载qe运行所需软件
mpirun -np 128 xxx.x -nk 64 < xxx.in > xxx.out #并行运行qe命令