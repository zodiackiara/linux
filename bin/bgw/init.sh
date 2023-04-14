#! /bin/bash
#前置操作：qe的scf计算完成
#目的：复制qe的scf计算输出文件以及赝势文件

#复制qe文件夹的赝势，提取计算的prefix，生成/out/prefix.save文件夹，复制scf计算输出文件
cp -v ../qe/*.upf . 
prefix=$(basename ../qe/out/*.save)
mkdir -p out/$prefix 
cp -v ../qe/out/$prefix/charge-density.dat out/$prefix/ 
cp -v ../qe/out/$prefix/data-file-schema.xml out/$prefix/


