#! /bin/bash
#前置条件：bands计算全部完成，均生成WFN*等文件，生成WFN.out文件

#根据材料是否
#若材料只有主族元素，则截断能取10即可，若材料包含副族元素，则截断能至少取到20
read -p "体系是否只有主族元素(0-否 1-是)?" num
if [ $num -eq 0 ]; then                 
  echo "epsilon_cutoff 20" > epsilon.inp
elif [ $num -eq 1 ]; then
  echo "epsilon_cutoff 10" > epsilon.inp
fi

#提取WFN.out中的材料最大简并数，将该值赋值为number_bands
#epsilon计算的number_bands，与c-bands.in计算的能带数对应，取其最大的简并数
max=$(grep -B 1 Note WFN.out | head -n 1 | awk '{print ($1)}')
echo "number_bands $max" >> epsilon.inp

#添加c-kgrid.out中的所有k点，并用q0坐标替换k0坐标
echo "begin qpoints" >> epsilon.inp
sed '1,2d' ../c-kgrid.out > temp
sed 's/$/  0/' temp > tmp
sed '1s/.*/  0.000000000  0.000000000  0.001000000   1.0  1/' tmp > temp
cat temp >> epsilon.inp && rm temp && rm tmp
echo "end" >> epsilon.inp