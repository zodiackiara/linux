#! /bin/bash

#前置操作：ph-para和ph计算结束
echo "&input" > q2r.in

#提取scf.in中prefix的值=$prefix
prefix=$(grep 'prefix = ' scf.in | awk '{print $3}' | awk -F"[']" '{print $2}')

echo "    fildyn = '$prefix.dyn'" >> q2r.in
echo "    flfrc = '$prefix.fc'" >> q2r.in
echo "    zasr = 'crystal'" >> q2r.in
echo "/" >> q2r.in
