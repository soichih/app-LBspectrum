
import os
import sys
sys.path.append("/N/u/kitchell/Karst/github_repos/mindboggle")

import glob
import json
import mindboggle
from mindboggle.shapes import laplace_beltrami

with open('config.json') as config_json:
    config = json.load(config_json)


all_spectrums = {}
all_spectrums['subject'] = config['subject_name']

for file in glob.glob(config['surfdir'] + "/*.vtk"):
    spectrum = laplace_beltrami.spectrum_from_file(file, 50)
    all_spectrums[os.path.basename(file)] = spectrum

with open( 'spectrum.json', 'w') as fp:
    json.dump(all_spectrums, fp, indent=4)
