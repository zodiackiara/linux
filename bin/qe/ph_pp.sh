#! /bin/bash

#前置操作：声子计算完成并经过q2r和matdyn处理
#多节点声子计算后处理
#将out/_phi/prefix.q_i+1/prefix.dvscf1复制到out/_ph0/prefix.q_i+1文件夹

#prefix.dyn0文件获取不可约q点数=$N
#依次复制prefix.dvscf1到_ph0的对应文件夹，一共循环N-1次
N=$(sed -n '2p' *.dyn0 | awk '{print $1}') 
for ((i=1; i<$N; i++))
do
    ln -sfrv out/_ph$i/*.q_$((i+1))/*.dvscf1 out/_ph0/*.q_$((i+1))/ 
done
    