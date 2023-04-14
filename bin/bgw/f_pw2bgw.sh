#!/bin/bash
#前置操作：f-bands计算完成

#复制q-pw2bgw.in，替换wfng_file的值，删除wfng_nki以及wfng_dki参数
cp -v q-pw2bgw.in f-pw2bgw.in
sed -i "/wfng_file/c\    wfng_file = 'WFN_fi'" f-pw2bgw.in
sed -i '/wfng_nk1/,+3d' f-pw2bgw.in
