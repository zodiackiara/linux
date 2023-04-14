#! /bin/bash

#前置操作：scf计算结束
#同时生成ph.in和ph-para.in

echo "phonon" > ph.in
echo "&inputph" >> ph.in

#提取scf.in中的prefix输入ph.in
prefix=$(grep "prefix = " scf.in)
echo "$prefix" >> ph.in

echo "    outdir = './out'" >> ph.in

#提取scf.in中prefix的值组合成$prefix.dyn
prefix=$(grep 'prefix = ' scf.in | awk '{print $3}' | awk -F"[']" '{print $2}')
echo "    fildyn = '$prefix.dyn'" >> ph.in

echo "    ldisp = true" >> ph.in
echo "    fildvscf = 'dvscf'" >> ph.in

echo "    tr2_ph = 1.0d-12" >> ph.in

echo "    reduce_io = true" >> ph.in

#输入q点网格生成数组qgrid，然后将数组值依次分配给nq1,nq2,nq3
echo "qgrid? " && read -a qgrid
echo "    nq1 = ${qgrid[0]}" >> ph.in
echo "    nq2 = ${qgrid[1]}" >> ph.in
echo "    nq3 = ${qgrid[2]}" >> ph.in

echo "    recover = true" >> ph.in
echo "/" >> ph.in

#复制ph.in为ph-para.in并删除recover字段所在行
cp -v ph.in ph-para.in
sed -i '/recover/d' ph-para.in
