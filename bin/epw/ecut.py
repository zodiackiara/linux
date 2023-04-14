#!/usr/bin/env python3
#读取eig文件输出每条能带的能量最大值与最小值

import pandas as pd

#读取sig2wan.inp中的nbnd值
with open("../bgw/out/sig2wan.inp", "r") as sig:
    lines = sig.readlines()
    nbnd = int(lines[5])
    
#读取eig文件中，第n条能带在每个k点的能量值，将其最大与最小值依次写入cutoff.eig文件
with open('ecut.eig', 'w') as ecut:
    ecut.write("nbnd      emin      emax \n")
    for n in range(0,nbnd):
        eig = pd.read_csv('../bgw/out/bgw.eig',sep='\s+',header=None,names=None,skiprows=lambda x:(x-n) % nbnd != 0)
        eig = eig.drop([0,1],axis=1)
        print(n+1,' ',eig.min().values[0],' ',eig.max().values[0],file=ecut)