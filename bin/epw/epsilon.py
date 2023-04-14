#! /usr/bin/env python3
#前置操作：epw计算声子辅助吸收结束
#目的：处理声子辅助吸收输出文件，得到介电虚部对应的介电实部数据，生成对应的epsilon_dirabs文件和epsilon_indabs文件

import pykk
import pandas as pd
import os

#可以读入任何文件名包含epsilon2_dirabs的文件，依次处理后输出对应epsilon_dirabs文件，适合用于计算不同温度输出文件
#对于直接吸收文件，只需读取第4列的平均介电虚部
for file in os.listdir('.'):
    if 'epsilon2_dirabs_300.0K' in file:
        dirabs = pd.read_csv(file,sep='\s+', header=None, names=None,skiprows=[0,1])
        dirabs_energy = dirabs[0].tolist()
        dirabs_imag = dirabs[4].tolist()
        dirabs_real = pykk.imag2real(dirabs_energy,dirabs_imag) 
        dirabs_real = pd.Series(dirabs_real)
        dirabs_real = dirabs_real.T
        dirabs = pd.DataFrame({'energy':dirabs_energy,'real':dirabs_real,'imag':dirabs_imag})
        filename, extension = os.path.splitext(file)
        filename = filename.split("_")
        dirabs.to_csv(f'epsilon_dirabs_{filename[2]}.dat',sep=' ',index=0)

#可以读入任何文件名包含epsilon2_indabs的文件，依次处理后输出对应epsilon_indabs文件，适合用于计算不同温度输出文件
#python均从0开始计数，能量所在列记为第1列，首先保存为dataframe，避免循环中反复被添加
#real = 'real_{}'.format(i)：字符串中引用循环变量的方法
#间接吸收文件中，高斯展宽值：0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5，每一个高斯展宽值对应不同的介电虚部
#indabs_real = pykk.imag2real(indabs_energy,indabs_imag)：使用介电虚部得到节点实部的办法
#df = df.join(df_new)：dataframe数据添加到新列而不是文件末尾的方法
#for n, i in enumerate([...])：得到两个循环变量，n为从0开始的计数值，i为数组中的值
for file in os.listdir('.'):
    if 'epsilon2_indabs_300.0K' in file:
        indabs = pd.read_csv(file,sep='\s+', header=None, names=None,skiprows=[0,1])
        indabs_energy = indabs[0].tolist()
        df = pd.DataFrame({'energy':indabs_energy})
        for n, i in enumerate([0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5]):
            real = 'real_{}'.format(i)
            imag = 'imag_{}'.format(i)
            indabs_real = 'indabs_real_{}'.format(i)
            indabs_imag = 'indabs_imag_{}'.format(i)
            indabs_imag = indabs[n+1].tolist()
            indabs_real = pykk.imag2real(indabs_energy,indabs_imag) 
            indabs_real = pd.Series(indabs_real)
            indabs_real = indabs_real.T
            df_new = pd.DataFrame({real:indabs_real,imag:indabs_imag})
            df = df.join(df_new)
            filename, extension = os.path.splitext(file)
            filename = filename.split("_")
            df.to_csv(f'epsilon_indabs_{filename[2]}.dat',sep=' ',index=0)