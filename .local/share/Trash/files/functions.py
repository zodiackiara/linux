#xc:交换关联能； setups：赝势文件； pp：赝势文件路径 special_setups：特殊赝势文件 setups_defaults：默认赝势文件 
#xc_defaults：默认交换关联能字典 atoms:ase.Atoms:ase设置的原子对象 p=self.input_params:用户输入参数


#create_input.py

import os
#操作系统模块
import warnings
#非致命提醒
import shutil
#高级文件处理模块
from os.path import join, isfile, islink
#系统路径处理模块 join:路径合并函数 ifile:文件判断符号 islink:链接判断符号 
from typing import List, Sequence, Tuple
#类型检查模块 List:列表类型 Tuple:元组类型 Sequence:列表和元组泛化类型
import numpy as np
#多维数组处理模块
import ase
#原子仿真环境模块
from ase.calculators.calculator import kpts2ndarray
#返回K点二维数组函数
from ase.calculators.vasp.setups import get_default_setups
#返回赝势文件副本文件函数

float_keys = [] #浮点数关键字列表
exp_keys = [] #指数关键字列表
string_keys = [] #字符串关键字列表
int_keys = [] #整数关键字列表
bool_keys = [] #布尔数关键字列表
list_int_keys = [] #整数列表关键字列表
list_bool_keys = [] #布尔数列表关键字列表
list_float_keys = [] #浮点数列表关键字列表
special_keys = [] #特殊关键字列表
dict_keys = [] #字典关键字列表
keys: List[str] = [] #字符串列表

class GenerateVaspInput: 
#生成Vasp输入的类

    xc_defaults = {}
#默认交换关联能：字典嵌套字典类型
    VASP_PP_PATH = 'VASP_PP_PATH'
#赝势文件路径
    
    def __init__(self, restart=None):
#初始化函数
        self.float_params = {}
#浮点数参数字典
        self.exp_params = {}
#指数参数字典
        self.string_params = {}
#字符串参数字典
        self.int_params = {}
#整数参数字典
        self.bool_params = {}
#布尔数参数字典
        self.list_bool_params = {}
#布尔数列表参数字典
        self.list_int_params = {}
#整数列表参数字典
        self.list_float_params = {}
#浮点数列表参数字典
        self.special_params = {}
#特殊参数字典
        self.dict_params = {}
#字典参数字典

        self.input_params = {
            'xc': None, #交换关联能
            'pp': None, #赝势文件路径
            'setups': None, #赝势文件
            'txt': '-', #文件位置
            'kpts': (1, 1, 1), #K点
            'gamma': False, #gamma点
            'kpts_nintersections': None, #能带结构中点数
            'reciprocal': False, #倒晶格单位K点
            'ignore_constraints': False, #禁用POCAR写入限制
            'charge': None, #系统净电荷，非0则为nelect
            'net_charge': None, #过时参数
            'custom': {}, #自定义键值对
    
    def set_xc_params(self, xc):
#确保输入的xc在默认xc字典xc_defaults中，否则报错ValueError
#确保输入的pp在xc字典self.xc_defaults[xc]中，否则pp设置为PBE
            
    def set(self, **kwargs):
#若LDA(S)+U修正开关('ldauu','ldaul', 'ldauj', 'ldau_luj')都存在，则报错NotImplementedError
#若xc存在，则用set_xc_params(kwargs['xc'])检查其是否在xc_defaults中
#若关键字存在，则将其赋值到对应格式关键词字典
#若关键词存在且其类型不属于任何一种默认格式，则报错TypeError
            
    def check_xc(self):
        p = self.input_params
#确保正确设置了pp，否则：若gga=None,则pp=lda；若gga=91，则pp=pw91；若gga=PE，则pp=pbe；若都不是，则报错NotImplementedError 
#确保正确设置了xc，若xc=lda但pp≠lda，则采用pp设置的赝势文件路径进行计算并发出warnings
            
    def _make_sort(self, atoms: ase.Atoms, special_setups: Sequence[int] = ()) -> Tuple[List[int], List[int]]: 
        symbols, _ = count_symbols(atoms, exclude=special_setups)    
#参数格式：atoms为ase的Atoms格式；特殊赝势为空整数元组；返回值为两个整数列表组成的元组
#输入ase.Atoms原子对象以及特殊赝势列表，返回元素索引列表srt[int]和元素重新排序列表resrt[int]
            
    def _build_pp_list(self, atoms, setups=None, special_setups: Sequence[int] = ()):
        p = self.input_params
        setups, special_setups = self._get_setups()
        symbols, _ = count_symbols(atoms, exclude=special_setups)
        pppaths = os.environ[self.VASP_PP_PATH].split(':')
        potcar = join(pp_folder, setups[special_setup_index], 'POTCAR')
        filename = join(path, potcar)
#建立赝势文件列表
    def _get_setups(self):
        p = self.input_params
        setups_defaults = get_default_setups()
#若输入的setups为None则设置为minimal类型；若输入的setups为默认赝势文件，则设置为setups列表；若输入的setups不是默认赝势，也添加到setups；若setups存在数字则将其添加到特殊赝势列表;返回值为赝势文件列表和特殊赝势文件列表setups和special_setups
            
    def initialize(self, atoms): 
    def default_nelect_from_ppp(self):
    def write_input(self, atoms, directory='./'):
    def copy_vdw_kernel(self, directory='./')
    def clean(self):
#删除所有Vasp计算自动生成的文件
    def write_incar(self, atoms, directory='./', **kwargs):
    def write_kpoints(self, atoms=None, directory='./', **kwargs):
    def write_potcar(self, suffix="", directory='./'):
    def write_sort_file(self, directory='./'):
    def read_incar(self, filename):
    def read_kpoints(self, filename):
    def read_potcar(self, filename):
    def todict(self):
    def _args_without_comment(data, marks=['!', '#']):
    def _to_vasp_bool(x):
    def open_potcar(filename):
    def read_potcar_numbers_of_electrons(file_obj):
    def count_symbols(atoms, exclude=()): 
        m, symbol in enumerate(atoms.symbols)
#数出atoms对象中的元素个数，并去掉其索引值
#参数形式：atoms:ase.Atoms对象；exclue:索引值列表；返回值：元组(独特元素列表，各独特元素数量字典)
    