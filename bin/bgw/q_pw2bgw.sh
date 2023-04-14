#! /bin/bash
#前置操作：q-bands计算完成

#复制c-pw2bgw.in，添加wfng_file参数
cp -v c-pw2bgw.in q-pw2bgw.in
sed "/wfng_kgrid/a\    wfng_file = 'WFNq'" q-pw2bgw.in > temp && mv temp q-pw2bgw.in

#赋值wfng_dk3=0.001*nk3
dk3=$(head -n 1 c-kgrid.in | awk '{print $NF*0.001}')
sed "/wfng_nk3/a\    wfng_dk3 = $dk3" q-pw2bgw.in > temp && mv temp q-pw2bgw.in

#删除vx和rhog参数
sed '/vxc/d' q-pw2bgw.in > temp && mv temp q-pw2bgw.in
sed '/rhog/d' q-pw2bgw.in > temp && mv temp q-pw2bgw.in




