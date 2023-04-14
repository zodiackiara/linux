#!/bin/bash
#前置操作：kgrid计算生成q-kgrid.out文件

#复制c-bands.in文件，提取scf.out的价带数量，加1后赋值给nbnd
#q-bands计算只需要包含所有价带即可，因此nbnd=val+1
cp -v c-bands.in q-bands.in
nbnd=$(grep "number of electrons" ../qe/scf.out | awk '{print ($5)*0.5+1}')
sed -i "/nbnd = /c\    nbnd = $nbnd" q-bands.in

#删除K_POINTS之后所有内容，添加q-kgrid.out文件的所有k点
sed '/K_POINTS/,$d' q-bands.in > temp && mv temp q-bands.in
cat q-kgrid.out >> q-bands.in