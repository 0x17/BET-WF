$onEmbeddedCode Python:

import json

with open('instance1.json', 'r') as fp:
    obj = json.load(fp)

def toset(pf, lst):
    return [ pf+str(elem+1) for elem in lst ]

set_names = ['T','I','K','J','S']

for set_name in set_names:
    gams.set(set_name.lower(), toset(set_name.lower(), obj[set_name]))

def param1d(pf, values):
    return [ (pf+str(ix+1),v) for ix,v in enumerate(values) ]

def param2d(pf1, pf2, values):
    return [ (pf1+str(ix1+1),pf2+str(ix2+1),v) for ix1,row in enumerate(values) for ix2,v in enumerate(row) ]

def bool_param3d(pf1, pf2, pf3, values):
    return [ (pf1+str(ix1+1),pf2+str(ix2+1),pf3+str(ix3+1)) for ix1,rowy in enumerate(values) for ix2,row in enumerate(rowy) for ix3,v in enumerate(row) if v ]

def param3d(pf1, pf2, pf3, values):
    return [ (pf1+str(ix1+1),pf2+str(ix2+1),pf3+str(ix3+1),v) for ix1,rowy in enumerate(values) for ix2,row in enumerate(rowy) for ix3,v in enumerate(row) ]

gams.set('ek', param3d('k','s','t', obj['ek']))
gams.set('due', param3d('i', 'k', 'j', obj['due']))
gams.set('nsa0', param2d('k', 's', obj['nsa0']))
gams.set('sa0', param1d('k', obj['sa0']))
gams.set('csa', param1d('k', obj['csa']))
gams.set('cnsa', param2d('k', 's', obj['cnsa']))
gams.set('c', param1d('i', obj['c']))
gams.set('d', param2d('k', 's', obj['d']))

$offEmbeddedCode t i k j s ek due nsa0 sa0 csa cnsa c d
