#!/bin/bash
#前置操作：sig2wan计算完成生成prefix.eig文件
#目的：以epw输入文件要求修改prefix.eig文件格式

#提取prefix，复制eig文件，提取eig文件最后一列的本征值
#复制原始eig文件为bgw.eig，方便epw读取
prefix=$(grep 'prefix = ' ../c-bands.in | awk '{print $3}' | awk -F"[']" '{print $2}')
cp -v $prefix.eig bgw.eig
cp -v $prefix.eig epw.eig
awk '{print $NF}' epw.eig > temp

#提取sig2wan.inp文件中的能带值赋值给nbnd，每个nbnd行加入1个空行
nbnd=$(sed '6q;d' sig2wan.inp | awk '{print ($1)}')
sed -i "0~$nbnd G" temp
sed -i '1 i\ \n' temp
mv temp epw.eig

#复制eig文件到epw文件夹
cp -v epw.eig ../../epw/$prefix.eig