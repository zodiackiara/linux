#!/bin/bash

#SBATCH -p amd_512       #指定分区
#SBATCH -N 1             #为保证多节点声子计算自洽使用单节点-scf
#SBATCH -n 128           #n=128*N

source /public1/soft/modules/module.sh         #加载module工具
module load qe/7.0.0-oneAPI.2022.1             #加载qe运行所需软件
mpirun -np 128 pw.x -nk 64 < scf.in > scf.out  #并行运行qe命令
