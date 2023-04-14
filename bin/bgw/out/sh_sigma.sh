#! /bin/bash
#前置操作：epsilon计算完成，查看WFN.out文件允许的简并能带数确定band_index_max的值
#前置操作：vasp的dos计算完成，通过PDOS投影图确认epw的nscf计算的nbnd值
#band_index_max必须是WFN.out文件允许的简并能带数
#band_index_max的值由c-pw2bgw中vxc_diag_nmax的值决定，必须小于vxc_diag_nmax的值
#band_index_max的值决定sigma计算输出文件sigma_hp.log中的band index的值，两者相等
#band_index_max的值决定sig2wan.inp中nbands的值，必须大于等于nbands的值
#sig2wan.inp中nbands的值最好是WFN.out文件允许的简并能带数，因此取nbands=band_index_max
#sig2wan.inp中nbands的值与eig.win中num_bands相等
#eig.win中num_bands的值与epw的nscf计算的能带数nbnd相等
#存在关系式：band_index_max(sigma)=num_bands(eig.win)=nbands(sig2wan)=nbnd(nscf)>nbndsub(epw)
#band_index_max确定原则：1.是WFN.out文件允许的简并能带数 2.大于等于epw的nscf计算的能带数nbnd


#复制WFN文件软链，提取epsilon.in的number_bands的值
ln -sfrv WFN WFN_inner
grep "number_bands" epsilon.inp > sigma.inp
echo "band_index_min 1" >> sigma.inp

#输入band_index_max的值
read -p "band_index_max=" max
echo "band_index_max $max" >> sigma.inp
echo "screening_semiconductor" >> sigma.inp

#添加c-kgrid.out文件中的所有k点
echo "begin kpoints" >> sigma.inp
sed '1,2d' ../c-kgrid.out > temp
cat temp >> sigma.inp && rm temp
echo "end" >> sigma.inp



