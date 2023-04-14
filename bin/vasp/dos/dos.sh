#! /bin/bash

#前置操作：自洽计算已完成
#pwd==/vasp/dos

#复制自洽计算生成的WAVECAR和CHGCAR
ln -sfrv ../scf/WAVECAR .
ln -sfrv ../scf/CHGCAR .

