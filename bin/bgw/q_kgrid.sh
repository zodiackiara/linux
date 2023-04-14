#! /bin/bash
#前置操作：c-kgrid, c-bands, c-pw2bgw计算完成

#复制c-kgrid.in，修改第3行的q点漂移值
cp -v c-kgrid.in q-kgrid.in 
sed '3s/.*/0.0 0.0 0.001/' q-kgrid.in > temp && mv temp q-kgrid.in