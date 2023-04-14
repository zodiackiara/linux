#!/bin/bash

#SBATCH -p amd_512       #指定分区
#SBATCH -N 1             #算力消耗低使用单节点-q2r
#SBATCH -n 128           #n=128*N

source /public1/soft/modules/module.sh          #加载module工具
module purge                                    #移除所有加载的软件
module load qe/7.0.0-oneAPI.2022.1              #加载qe运行所需软件
mpirun -np 128 q2r.x -nk 64 < q2r.in > q2r.out  #并行运行qe命令