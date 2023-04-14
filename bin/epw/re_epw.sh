#! /bin/bash
#前置操作：in-epw计算完成

#复制in-epw.in，替换write和read的值
cp -v in-epw.in re-epw.in
sed -i "/epwwrite = /c\    epwwrite = false" re-epw.in
sed -i "/epwread = /c\    epwread = true" re-epw.in

#提取scf.out中的价带数val，读取ecut.eig文件
#设定fermi能为带隙中间值=0.5*(价带顶能量+导带底能量)
#ecut.eig的第2列是能量最小值，第3列是能量最大值
val=$(grep "number of electrons" ../qe/scf.out | awk '{print ($5)*0.5}')
val_max=$(awk "NR==$(($val+1))" ecut.eig | awk '{print $3}')
cond_min=$(awk "NR==$(($val+2))" ecut.eig | awk '{print $2}')
fermi=$(echo "0.5*$val_max + 0.5*$cond_min" | bc)
echo "fermi_energy = $fermi"
sed -i "/eig_read/ a\    fermi_energy = $fermi" re-epw.in
sed -i "/eig_read/ a\    efermi_read = true" re-epw.in

#写入声子辅助计算参数，删除band_plot所在行
#通常设置最小声子能量0.1eV，最大声子能量12.4eV，声子步长0.03eV，产生410个数据点
#对应最大波长12.4um，最小波长0.1um
sed -i "/temps/ a\    omegastep = 0.03" re-epw.in
sed -i "/temps/ a\    omegamax = 12.4" re-epw.in
sed -i "/temps/ a\    omegamin = 0.1" re-epw.in
sed -i "/temps/ a\    lindabs = true" re-epw.in
sed -i "/temps/ a\    mp_mesh_k = true" re-epw.in
sed -i '/band_plot/d' re-epw.in

#删除filkf所在行以及filqf所在行
sed -i '/filkf/d' re-epw.in
sed -i '/filqf/d' re-epw.in

#通常令nkfi=2*nki，nqfi=nki，根据实际情况更改
#使用循环提取nki的值赋值给nqfi，提取2倍nki的值赋值给nkfi
for ((i=3; i>=1; i--))
do
    nqf=$(grep nk$i re-epw.in | awk '{print $3}')
	sed -i "/nq3/ a\    nqf$i = $nqf" re-epw.in
done
for ((i=3; i>=1; i--))
do
    nkf=$(grep nk$i re-epw.in | awk '{print 2*$3}')
	sed -i "/nq3/ a\    nkf$i = $nkf" re-epw.in
done

#更改wannierize，删除绘制能带图相关命令，
sed -i "/wannierize = /c\    wannierize = false" re-epw.in
sed -i '/bands_plot/,/end kpoint_path/d' re-epw.in
