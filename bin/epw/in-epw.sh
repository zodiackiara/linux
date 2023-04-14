#!/bin/bash

#SBATCH -p amd_512       #指定分区
#SBATCH -N 5             #计算量高提高节点数-epw
#SBATCH -n 640           #指定核数，一般n=128*N
#SBATCH --exclusive     #独占节点，用于内存消耗大的计算-epw

source /public1/soft/modules/module.sh                #加载module工具
module load qe/7.0.0-oneAPI.2022.1                    #加载qe运行所需软件
mpirun -np 600 epw.x -nk 600 < in-epw.in > in-epw.out #并行运行epw命令np=nk，计算核数少于申请核数提升内存
