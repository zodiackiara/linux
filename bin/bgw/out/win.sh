#!/bin/bash

#SBATCH -p amd_512       #指定分区
#SBATCH -N 1             #预处理算力低单节点-wannier
#SBATCH -n 128           #指定核数，一般n=128*N

source /public1/soft/modules/module.sh  #加载module工具
module load qe/7.0.0-oneAPI.2022.1      #加载qe运行所需软件
wannier90.x -pp eig.win                 #wannier90预处理命令
