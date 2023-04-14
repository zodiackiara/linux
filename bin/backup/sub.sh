#!/bin/bash
#旧的vasp提交任务脚本，留作备份。

#SBATCH --job-name=sbsnsc #提交任务名称xxx
#SBATCH --output=sbsnsc.out #任务输出信息xxx.out
#SBATCH --error=sbsnsc.err  #错误信息xxx.err
#SBATCH -p amd_512 #不用变
#SBATCH -N 64 #代表的使用的计算节点个数:1个计算节点有128个CPU
#SBATHC -n 32 #代表使用的CPU数量
#SBATCH -t 144:00:00 #代表计算时间：小时:分钟:秒

source /public1/soft/modules/module.sh
module load mpi/intel/17.0.7-thc
export PATH=/public1/home/scg3278/software-scg3278/5.4.4:$PATH #vasp程序存放路径
srun vasp_std # 用srun命令运行vasp程序（程序名为vasp_std)
