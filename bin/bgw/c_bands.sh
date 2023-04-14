#! /bin/bash
#前置操作：qe的scf计算完成，init脚本复制了赝势和scf输出文件
#前置操作：c-kgrid计算完成生成k点文件c-kgrid.out
#前置操作：vasp的dos计算完成，通过PDOS投影图确认epw的nscf计算的nbnd值
#目的：生成c-bands.in文件进行能带计算，用于生成WFN文件

#复制scf.in文件，添加electron_maxstep, diago_david_ndim, diago_full_acc参数，修改calculation, conv_thr参数
cp -v ../qe/scf.in c-bands.in
sed -i "/calculation/c\    calculation = 'bands'" c-bands.in
sed -i "/conv_thr/ i\    electron_maxstep = 1000" c-bands.in
sed -i "/conv_thr/c\    conv_thr = 1.0d-12" c-bands.in
sed -i "/conv_thr/ a\    diago_david_ndim = 8" c-bands.in
sed -i "/conv_thr/ a\    diago_full_acc = true" c-bands.in

#提取并输出体系的价带数量val，输入nbnd数值
#bgw计算需要大量空能带，用于计算交换关联矩阵
#val不大于20时nbnd=4*val，val大于20时nbnd=2*val+20
#注意：nbnd需要大于epw的nscf计算的nbnd值
#nbnd与epsilon以及sigma计算中的number_bands对应，number_bands取其最大的简并能带数
val=$(grep "number of electrons" ../qe/scf.out | awk '{print ($5)*0.5}')
if [[ "$val" -le 20 ]]; then
    nbnd=$(($val*4)) && echo "nbnd = $nbnd"
else
    nbnd=$(($val*2+20)) && echo "nbnd = $nbnd"
fi
sed -i "/ntyp/ a\    nbnd = $nbnd" c-bands.in

#删除K_POINTS之后所有行，复制c-kgrid.out文件中的K点
sed -i '/K_POINTS/,$d' c-bands.in
cat c-kgrid.out >> c-bands.in


