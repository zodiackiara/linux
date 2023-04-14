#! /usr/bin/env python3
#目的：绘制能带投影元素图和dos投影元素图
#band所需文件：band/vasprum.xml band/KPOINTS(能带计算的高K点路径文件)
#dos所需文件：dos/vasprum.xml
#只有体系的元素数量在3个以内才能画能带投影到元素图像

import matplotlib.pyplot 
from pymatgen.io.vasp.outputs import Vasprun 
from pymatgen.electronic_structure.plotter import BSDOSPlotter,BSPlotter,BSPlotterProjected,DosPlotter 
dos_vasprun=Vasprun("./dos/vasprun.xml")
dos_data=dos_vasprun.complete_dos 
bs_vasprun=Vasprun("./band/vasprun.xml",parse_projected_eigen=True) 
bs_data=bs_vasprun.get_band_structure(line_mode=1)
plt_2=BSDOSPlotter(bs_projection='elements', dos_projection='elements')
plt_2.get_plot(bs=bs_data,dos=dos_data) 
matplotlib.pyplot.savefig('band+dos-element.png')