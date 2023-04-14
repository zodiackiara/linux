###ASE的Vasp接口
$VASP_PP_PATH = 'pseudopotential directories'
$VASP_SCRIPT : import os; exitcode = os.system('vasp') 
$VASP_COMMAND = 'vasp' or 'mprirun -n 16 vasp'

###creat_input.py

import os
import warnings
import shutil
from os.path import join, isfile, islink
from typing import List, Sequence, Tuple
import numpy as np
import ase
from ase.calculators.calculator import kpts2ndarray
from ase.calculators.vasp.setups import get_default_setups

float_keys = [...]
exp_keys = [...]
string_keys = [...]
int_keys = [...]
bool_keys = [...]
list_int_keys = [...]
list_bool_keys = [...]
list_float_keys = [...]
special_keys = [...]
dict_keys = [...]
keys: List[str] = [...]

class GenerateVaspInput:
    
    xc_defaults = {...}
    VASP_PP_PATH = 'VASP_PP_PATH'
    
    def __init__(self, restart = None):
        
        self.float_params = {}
        self.exp_params = {}
        self.string_params = {}
        self.int_params = {}
        self.bool_params = {}
        self.list_bool_params = {}
        self.list_int_params = {}
        self.list_float_params = {}
        self.special_params = {}
        self.dict_params = {}
        for key in float_keys:
            self.float_params[key] = None
        for key in exp_keys:
            self.exp_params[key] = None
        for key in string_keys:
            self.string_params[key] = None
        for key in int_keys:
            self.int_params[key] = None
        for key in bool_keys:
            self.bool_params[key] = None
        for key in list_bool_keys:
            self.list_bool_params[key] = None
        for key in list_int_keys:
            self.list_int_params[key] = None
        for key in list_float_keys:
            self.list_float_params[key] = None
        for key in special_keys:
            self.special_params[key] = None
        for key in dict_keys:
            self.dict_params[key] = None 
            
        self.input_params = {
            'xc': None,
            'pp': None,
            'setups': None,
            'txt': '-',
            'kpts': (1, 1, 1),
            'gamma': False,
            'kpts_nintersections': None,
            'reciprocal': False,
            'ignore_constraints': False,
            'charge': None,
            'net_charge': None,
            'custom': {},
        }
        
    def set_xc_params(self, xc):
        
        xc = xc.lower()
        if xc is None:
            pass
        elif xc not in self.xc_defaults:
            xc_allowed = ', '.join(self.xc_defaults.keys())
            raise ValueError('{0} is not supported fo xc! Supported xc values are: {1}'.format(xc, xc_allowed))
        else:
            if 'pp' not in self.xc_defaults[xc]:
                self.set(pp = 'PBE')
        self.set(**self.xc_defaults[xc])
    
    def set(self, **kwargs):
        
        if (('ldauu' in kwargs) and ('ldaul' in kwargs) and ('ldauj' in kwargs) and ('ldau_luj' in kwargs)):
            raise NotImplementedError('You can either specify ldaul, ldauu, and ldauj OR ldau_luj. ldau_luj is not a VASP keyword. It is a dictionary that specifies L, U and J for each chemical species in the atoms object. For example for a water molecule:' '''ldau_luj={'H':{'L':2, 'U':4.0, 'J':0.9}, 'O':{'L':2, 'U':4.0, 'J':0.9}}''')
            
        if 'xc' in kwargs:
            self.set_xc_params(kwargs['xc'])
        for key in kwargs:
            if key in self.float_params:
                self.float_params[key] = kwargs[key]
            elif key in self.exp_params:
                self.exp_params[key] = kwargs[key]
            elif key in self.string_params:
                self.string_params[key] = kwargs[key]
            elif key in self.int_params:
                self.int_params[key] = kwargs[key]
            elif key in self.bool_params:
                self.bool_params[key] = kwargs[key]
            elif key in self.list_bool_params:
                self.list_bool_params[key] = kwargs[key]
            elif key in self.list_int_params:
                self.list_int_params[key] = kwargs[key]
            elif key in self.list_float_params:
                self.list_float_params[key] = kwargs[key]
            elif key in self.special_params:
                self.special_params[key] = kwargs[key]
            elif key in self.dict_params:
                self.dict_params[key] = kwargs[key]
            elif key in self.input_params:
                self.input_params[key] = kwargs[key]
            else:
                raise TypeError('Parameter not defined: ' + key)
               
    def check_xc(self):
        
        p = self.input_params
        if 'pp' not in p or p['pp'] is None:
            if self.string_params['gga'] is None:
                p.update({'pp': 'lda'})
            if self.string_params['gga'] == '91':
                p.update({'pp': 'pw91'})
            elif self.string_params['gga'] == 'PE':
                p.update({'pp': 'pbe'})
            else:
                raise NotImplementedError(
                    "Unable to guess the desired set of pseudopotential(POTCAR) files. Please do one of the following: \n
                    1. Use the 'xc' parameter to define your XC functional.These 'recipes' determine the pseudopotential file as well as setting the INCAR parameters.\n
                    2. Use the 'gga' settings None (default), 'PE' or '91'; these correspond to LDA, PBE and PW91 respectively.\n
                    3. Set the POTCAR explicitly with the 'pp' flag. The value should be the name of a folder on the VASP_PP_PATH, and the aliases 'LDA', 'PBE' and 'PW91' are also accepted.\n")
            
            if (p['xc'] is not None and p['xc'].lower() == 'lda' and p['pp'].lower() != 'lda'):
                warnings.warn("XC is set to LDA, but PP is set to {0}. \n This calculation is using the {0} POTCAR set. \n Please check that this is really what you intended! \n".format(p['pp'].upper()))
                
    def _make_sort(self, atoms:ase.Atoms, special_setups: Sequence[int] = ()) -> Tuple[List[int], List[int]]:
        
        symbols, _ = count_symbols(atoms, exclude = special_setups)
        srt = []
        srt.extend(special_setups)
        
        for symbol in symbols:
            for m, atom in enumerate(atoms)
            if m in special_setups:
                continue
            if atom.symbol == symbols:
                srt.append(m)
                
        resrt = list(range(len(srt))):
            resrt[srt[n]] = n
            return srt, resrt
        
    def _build_pp_list(self, atoms, setups=None, special_setups:Sequence[int] = ()):
        p = self.input_params
        
        if setups is None:
            setups, special_setups = self._get_setups()
        
         
        for pp_alias, pp_folder in (('lda', 'potpaw'), ('pw91', 'potpaw_GGA'), ('pbe', 'potpaw_PBE')):
            if p['pp'].lower() == pp_alias:
                break
            else:
                pp_folder = p['pp']
                
        if self.VASP_PP_PATH in os.environ:
            pppaths = os.environ[self.VASP_PP_PATH].split(':')
        else:
            pppaths = []
        ppp_list = []
        
        for m in special_setups:
            if m in setups:
                special_setups_index = m
            elif str(m) in setups:
                special_setups_index = str(m)
            else:
                raise Exception("Having trouble with special setup index {0}. Please use an int.".format(m))
                
        potcar = join(pp_folder,setups[special_setups_index], 'POTCAR')
        
        for path in pppaths:
            filename = join(path, potcar)
            
            if isfile(filename) or islink(filename):
                ppp_list.append(filename)
                break
            elif isfile(filename + '.Z') or islink(filename + '.Z'):
                ppp_list.append(filename + '.Z')
                break
            else:
                symbol = atoms.symbols[m]
                msg =  """Looking for {}. No pseudopotential for symbol{} with setup {} """.format(potcar, symbol, setups[special_setup_index])
                raise RuntimeError(msg)
                
        for symbol in symbols:
            try:
                potcar = join(pp_folder, symbol + setups[symbol], 'POTCAR')
            except (TypeError, KeyError):
                potcar = join(pp_folder, symbol, 'POTCAR')
            for path in pppaths:
                filename = join(path, potcar)
                
                if isfile(filename) or islink(filename):
                    ppp_list.append(filename)
                    break
                elif isfile(filename + '.Z') or islink(filename + '.Z'):
                    ppp_list.append(filename + '.Z')
                    break
                else:
                    msg = ("""Looking for PP for {}, The pseudopotentials are expected to be in: LDA: $VASP_PP_PATH/potpaw/ , PBE: $VASP_PP_PATH/potpaw_PBE/, PW91: $VASP_PP_PATH/potpaw_GGA/, No pseudopotential for {}!""".format(potcar, symbol))  
                    raise ppp_list
                    
    def _get_setups(self):
        
        p = self.input_params
        special_setups = []
        setups_defaults = get_default_setups()
        
        if p['setups'] is None:
            p['setups'] = {'base': 'minimal'}
        elif isinstance(p['setups'], str):
            if p['setups'].lower() in setups_defaults.keys()：
                p['setups'] = {'base': p['setups']}
        
        if 'base' in p['setups']:
            setups = setups_defaults[p['setups']['base'].lower()]
        else:
            setups = {}
            
        if p['setups'] is not None:
            setups.update(p['setups'])
            
        for m in setups:
            try:
                special_setups.append(int(m))
            except ValueError:
                pass
        return setups, special_setups
            
            
                
        
    
        
        
    
    