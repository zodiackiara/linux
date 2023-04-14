#! /bin/bash
#前置操作：vasp的dos计算完成，根据PDOS图像确定投影轨道
#前置操作：qe的scf计算完成，ph计算完成
#前置操作：bgw计算确认简并允许能带值，生成eig文件
#目的：生成nscf.in文件

#复制bgw/c-bands.in文件，替换计算类型，使用sig2wan.inp的能带数替换nbnd值
#nscf计算，bgw/c-band计算，bgw/out/sigma计算使用同一套k点网格
#因此直接复制c-bands.in生成nscf.in文件，无需改动k点
cp -v ../bgw/c-bands.in nscf.in
sed -i "/calculation/c\    calculation = 'nscf'" nscf.in
nbnd=$(sed -n 6p ../bgw/out/sig2wan.inp | awk '{print $1}')
sed -i "/nbnd/c\    nbnd = $nbnd" nscf.in
