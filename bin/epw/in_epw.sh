#! /bin/bash
#前置操作：vasp的dos计算完成，根据PDOS图像确定投影轨道
#前置操作：qe的scf计算完成，ph计算完成
#前置操作：bgw计算确认简并允许能带值，生成eig文件
#前置操作：epw的nscf计算完成
#目的：生成in-epw.in文件

echo "epw" > in-epw.in
echo "&inputepw" >> in-epw.in
prefix=$(grep "prefix" ../qe/scf.in) && echo "$prefix" >> in-epw.in
echo "    outdir = './out'" >> in-epw.in
echo "    dvscf_dir = '../qe/save'" >> in-epw.in
echo "    elph = true" >> in-epw.in
echo "    epwwrite = true" >> in-epw.in
echo "    epwread = false" >> in-epw.in
echo "    use_ws = true" >> in-epw.in
echo "    asr_typ = 'crystal'" >> in-epw.in
echo "    degaussw = 0.005" >> in-epw.in

#fsthick需要稍大于间接带隙值，取../bgw/out/band.gap中GGA间接带隙的整值
fsthick=$(grep 'GW indirect' ../bgw/out/band.gap | awk '{print int($4)+1}')
echo "fsthick = $fsthick"
echo "    fsthick = $fsthick" >> in-epw.in

#一般温度设置为室温300K，后续根据实际情况更改
echo "    temps = 300" >> in-epw.in

#根据scf.in文件中布拉维格子类型读入不同的高对称k点路径
echo "    band_plot = true" >> in-epw.in
type=$(grep bravais ../qe/scf.in | awk '{print $5}')
if [ $type == "hp" ]; then
    echo "    filkf = './hp-GMKG'" >> in-epw.in
    echo "    filqf = './hp-GMKG'" >> in-epw.in
elif [ $type == "cf" ]; then
    echo "    filkf = './cf-GXWKG'" >> in-epw.in
	echo "    filqf = './cf-GXWKG'" >> in-epw.in
elif [ $type == "op" ]; then
    echo "    filkf = './op-GXSYG'" >> in-epw.in
	echo "    filqf = './op-GXSYG'" >> in-epw.in
elif [ $type == "mp" ]; then
    echo "    filkf = './mp-GYCEA'" >> in-epw.in
	echo "    filqf = './mp-GYCEA'" >> in-epw.in	
	
fi

#提取c-kgrid.in中的k点网格赋值给nki
nk1=$(head -n 1 ../bgw/c-kgrid.in | awk '{print $1}')
nk2=$(head -n 1 ../bgw/c-kgrid.in | awk '{print $2}')
nk3=$(head -n 1 ../bgw/c-kgrid.in | awk '{print $3}')
echo "    nk1 = $nk1" >> in-epw.in
echo "    nk2 = $nk2" >> in-epw.in
echo "    nk3 = $nk3" >> in-epw.in

#提取ph.in中的q点网格赋值给nqi
grep nq1 ../qe/ph.in >> in-epw.in
grep nq2 ../qe/ph.in >> in-epw.in
grep nq3 ../qe/ph.in >> in-epw.in
echo "" >> in-epw.in

echo "    wannierize = true" >> in-epw.in
echo "    num_iter = 2000" >> in-epw.in
echo "    eig_read = true" >> in-epw.in

#提取材料所有元素，以分号隔开依次输入元素的各投影轨道
elements=($(find . -type f -name "*.upf" -exec basename {} \; | sed 's/_.*//' | sort -u))
num=${#elements[@]}
for ((i=0; i<$num; i++))
do
	read -p "${elements[$i]}的投影轨道? " proj
	proj[$((i+1))]="${elements[$i]}: $proj"
	echo "    proj($((i+1))) = '${proj[$((i+1))]}'" >> in-epw.in 
done
	
#提取eig.win中投影轨道数赋值给wann，提取scf.out中的价带数val，计算得到bands_skipped的值
#bands_skipped=val-num_wann/2
#num_wann(win)=nbndsub(epw)，都等于投影能带数
val=$(grep "number of electrons" ../qe/scf.out | awk '{print ($5)*0.5}')
wann=$(grep num_wann ../bgw/out/eig.win | awk '{print ($3)}')
echo "    nbndsub = $wann" >> in-epw.in
skip=$(($val-$wann/2))
echo "bands_skipped = 1:$skip"
echo "    bands_skipped = 'exclude_bands = 1:$skip'" >> in-epw.in

#froz的能量小于第(val+wann/2+1)条能带能量最小值
#win能量大于第(val+wann/2+4)条能带能量最大值
#int()函数对浮点数向下取整
#ecut.eig的第2列是能量最小值，第3列是能量最大值
froz=$(($val+$wann/2+1))
win=$(($val+$wann/2+4))
froz_max=$(awk "NR==$(($froz+1))" ecut.eig | awk '{print int($2)}')
win_max=$(awk "NR==$(($win+1))" ecut.eig | awk '{print int($3)+1}')
echo "dis_froz_max = $froz_max"
echo "dis_win_max = $win_max"
echo "    dis_froz_max = $froz_max" >> in-epw.in
echo "    dis_win_max = $win_max" >> in-epw.in

#逐行输入wdata
echo "    wdata(1) = 'use_ws_distance = true'" >> in-epw.in
echo "    wdata(2) = 'guiding_centres = true'" >> in-epw.in
echo "    wdata(3) = 'dis_mix_ratio = 1.0'" >> in-epw.in
echo "    wdata(4) = 'num_print_cycles = 10'" >> in-epw.in
echo "    wdata(5) = 'dis_num_iter = 500'" >> in-epw.in
echo "    wdata(6) = 'bands_plot = true'" >> in-epw.in
echo "    wdata(7) = 'bands_plot_format = gnuplot'" >> in-epw.in
echo "    wdata(8) = 'begin kpoint_path'" >> in-epw.in

#根据scf.in文件中布拉维格子类型输入不同的高对称k点路径
#hp高对称路径：G-M-K-G
#cf高对称路径：G-X-W-K-G
#op高对称路径：G-X-S-Y-G
#mp高对称路径：G-Y-C-E-A
type=$(grep bravais ../qe/scf.in | awk '{print $5}')
if [ $type == "hp" ]; then
    echo "    wdata(9) = 'G 0.00 0.00 0.00 M 0.50 0.00 0.00'" >> in-epw.in
	echo "    wdata(10) = 'M 0.50 0.00 0.00 K 0.33 0.33 0.00'" >> in-epw.in
	echo "    wdata(11) = 'K 0.33 0.33 0.00 G 0.00 0.00 0.00'" >> in-epw.in
	echo "    wdata(12) = 'end kpoint_path'" >> in-epw.in
elif [ $type == "cf" ]; then
    echo "    wdata(9) = 'G 0.00 0.00 0.00 X 0.50 0.00 0.50'" >> in-epw.in
	echo "    wdata(10) = 'X 0.50 0.00 0.50 W 0.50 0.25 0.75'" >> in-epw.in
	echo "    wdata(11) = 'W 0.50 0.25 0.75 K 0.375 0.375 0.75'" >> in-epw.in
	echo "    wdata(12) = 'K 0.375 0.375 0.75 G 0.00 0.00 0.00'" >> in-epw.in
	echo "    wdata(13) = 'end kpoint_path'" >> in-epw.in
elif [ $type == "op" ]; then
    echo "    wdata(9) = 'G 0.00 0.00 0.00 X 0.50 0.00 0.00'" >> in-epw.in
	echo "    wdata(10) = 'X 0.50 0.00 0.00 S 0.50 0.50 0.00'" >> in-epw.in
	echo "    wdata(11) = 'S 0.50 0.50 0.00 Y 0.00 0.50 0.00'" >> in-epw.in
	echo "    wdata(12) = 'Y 0.00 0.50 0.00 G 0.00 0.00 0.00'" >> in-epw.in
	echo "    wdata(13) = 'end kpoint_path'" >> in-epw.in
elif [ $type == "mp" ]; then
    echo "    wdata(9) = 'G 0.00 0.00 0.00 Y 0.50 0.00 0.00'" >> in-epw.in
	echo "    wdata(10) = 'Y 0.50 0.00 0.00 C 0.50 0.50 0.00'" >> in-epw.in
	echo "    wdata(11) = 'C 0.50 0.50 0.00 E -0.50 0.50 0.50'" >> in-epw.in
	echo "    wdata(12) = 'E -0.50 0.50 0.50 A -0.50 0.00 0.50'" >> in-epw.in
	echo "    wdata(13) = 'end kpoint_path'" >> in-epw.in
fi
echo "/" >> in-epw.in


