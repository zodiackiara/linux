#!/bin/bash

#SBATCH -p amd_512      #指定分区
#SBATCH -N 4            #计算量高使用多节点-bgw
#SBATCH -n 512          #指定核数，一般n=128*N
#SBATCH --exclusive     #独占节点，用于内存消耗大的计算-bgw

source /public1/soft/modules/module.sh                                  #加载module工具
module purge                                                            #移除所有加载的软件
module load mpi/intel/17.0.7-thc fftw/3.3.8-mpi hdf5/1.10.5-ips17       #加载bgw运行所需软件
export PATH=~/BerkeleyGW-3.0.1/install/bin:$PATH                        #声明bgw运行环境
export LD_LIBRARY_PATH=~/BerkeleyGW-3.0.1/install/lib:$LD_LIBRARY_PATH  #声明环境变量
export INCLUDE=~/BerkeleyGW-3.0.1/install/include:$INCLUDE              #声明环境变量
mpirun -np 512 epsilon.cplx.x < epsilon.inp > epsilon.out               #并行运行bgw命令，bgw不支持并行参数

