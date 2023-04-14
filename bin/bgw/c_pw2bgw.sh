#! /bin/bash
#前置操作：c-bands计算完成

#提取scf.in的prefix和outdir所在行内容
echo "&input_pw2bgw" > c-pw2bgw.in
grep outdir c-bands.in >> c-pw2bgw.in
grep prefix c-bands.in >> c-pw2bgw.in

#real_or_complex=1默认体系具有反转对称性，且反转对称性没有关联的fractional translation
#若体系无反转对称性，或反转对称性存在关联的fractional translation，设置real_or_complex=2
#若设置real_or_complex=2，则后续bgw计算全部使用cplx类型计算工具
echo "    real_or_complex = 1" >> c-pw2bgw.in
echo "    wfng_flag = true" >> c-pw2bgw.in
echo "    wfng_kgrid = true" >> c-pw2bgw.in

#提取c-kgrid.in中k点网格赋值给wfng_nki
read nk1 nk2 nk3 <<< $(awk 'NR==1{print $1, $2, $3}' c-kgrid.in)
echo "    wfng_nk1 = $nk1" >> c-pw2bgw.in
echo "    wfng_nk2 = $nk2" >> c-pw2bgw.in
echo "    wfng_nk3 = $nk3" >> c-pw2bgw.in
echo "    vxc_flag = true" >> c-pw2bgw.in
echo "    vxc_file = 'vxc.dat'" >> c-pw2bgw.in
echo "    vxc_diag_nmin = 1" >> c-pw2bgw.in

#提取c-bands.in中的nbnd值，赋值给vxc_diag_nmax
nbnd=$(grep "nbnd" c-bands.in | awk '{print $3}')
echo "    vxc_diag_nmax = $nbnd" >> c-pw2bgw.in
echo "    rhog_flag = true" >> c-pw2bgw.in
echo "/" >> c-pw2bgw.in


