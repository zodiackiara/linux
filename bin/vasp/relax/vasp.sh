#!/bin/bash

#SBATCH -p amd_512         #指定分区
#SBATCH -N 64              #多节点不满核提升内存-vasp
#SBATCH -n 256             #n=4*N提升内存-vasp

source /public1/soft/modules/module.sh      #加载module工具
module purge                                #移除所有加载的软件
module load mpi/intel/17.0.7-thc            #加载vasp运行所需软件
export PATH=~/zodiac/vasp.5.4.4:$PATH       #声明vasp运行环境
ulimit -c unlimited                         #core dump文件无限制提升内存-vasp 
ulimit -s unlimited                         #进程的栈空间无限制-vasp
srun vasp_std                               #srun直接使用sbatch声明的并行参数