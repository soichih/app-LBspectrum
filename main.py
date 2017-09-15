#!/usr/bin/env python
import os
import sys

#I think this should go to start.sh
env = os.environ['ENV']
if env == 'IUHPC':
    sys.path.append("/N/u/brlife/Carbonate/git/mindboggle")
if env == 'VM':
    sys.path.append("/usr/local/mindboggle")

import glob
import json
import mindboggle
from mindboggle.shapes import laplace_beltrami
from datetime import datetime

with open('config.json') as config_json:
    config = json.load(config_json)

spectrum_size = config['spectrum_size']
normalization = config['normalization']

print config

all_spectrums = {}
#all_spectrums['subject'] = config['subject_name']

total=0
for file in glob.glob(config['surfdir'] + "/*.vtk"):
    print str(total)+" "+file
    total+=1

count=0
for file in glob.glob(config['surfdir'] + "/*.vtk"):
    print (str(datetime.now())+"\n"+str(count)+" of "+str(total)+" processing "+file)
    spectrum = laplace_beltrami.spectrum_from_file(file, spectrum_size=spectrum_size, normalization=normalization)
    all_spectrums[os.path.basename(file)] = spectrum
    count+=1

with open( 'spectrum.json', 'w') as fp:
    json.dump(all_spectrums, fp, indent=4)
