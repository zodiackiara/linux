#! /bin/bash
#前置操作：dcf计算完成
#目的：复制scf计算输出文件，复制赝势文件

#提取prefix，复制scf计算输出文件和赝势文件
prefix=$(basename ../qe/out/*.save)
mkdir -p out/$prefix
cp -v ../qe/out/$prefix/charge-density.dat out/$prefix/
cp -v ../qe/out/$prefix/data-file-schema.xml out/$prefix/
cp -v ../qe/*.upf .