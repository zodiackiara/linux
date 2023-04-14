#! /bin/bash
#前置操作：qe的scf计算完成，init复制scf计算输出文件以及赝势文件
#目的：生成c-kgrid.in用于生成k点文件

#提取scf.in文件中的K点
awk '/K_POINTS/{getline; print $1, $2, $3}' ../qe/scf.in > c-kgrid.in
echo "0.0 0.0 0.0" >> c-kgrid.in
echo "0.0 0.0 0.0" >> c-kgrid.in

#输入scf.in文件中的晶胞参数
line=$(sed -n '/CELL_PARAMETERS/=' ../qe/scf.in)
sed -n "$((line+1)),$((line+3))p" ../qe/scf.in >> c-kgrid.in

#输入scf.in文件中的原子数
grep "nat" ../qe/scf.in | awk '{print $3}' >> c-kgrid.in

#输入scf.in文件中的原子位置，将其中包含的元素名称用数字代替
#提取原子位置保存为temp文件，提取赝势文件包含的元素，按字母顺序排序，用while循环依次用数字代替元素
sed -n '/ATOMIC_POSITIONS/,/K_POINTS/p' ../qe/scf.in | sed '1d;$d' > temp
elements=($(find . -type f -name "*.upf" -exec basename {} \; | sed 's/_.*//' | sort -u))
while read line; do
  for ((i=0;i<${#elements[@]};i++)); do
    if [[ "$line" == *"${elements[$i]}"* ]]; then
      line=$(echo "$line" | sed "s/\b${elements[$i]}\b/$((i+1))/g")
    fi
  done
  echo "$line"
done < temp >> c-kgrid.in && rm temp

#输入scf.out的FFT网格
fft=$(grep "Dense" ../qe/scf.out)
echo "$fft" | grep -oE '[0-9]+(\.[0-9]+)?' | tail -n 3 | paste -sd ' ' >> c-kgrid.in
echo "false" >> c-kgrid.in



