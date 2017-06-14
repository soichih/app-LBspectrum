
import os
import sys

env = os.environ['ENV']
if env == 'IUHPC':
    sys.path.append("/N/u/kitchell/Karst/github_repos/mindboggle")
if env == 'VM':
    sys.path.append("/usr/local/mindboggle")

import glob
import json
import mindboggle
from mindboggle.shapes import laplace_beltrami

with open('config.json') as config_json:
    config = json.load(config_json)

spectrum_size = config['spectrum_size']
# default = 50 
normalization = config['normalization']
# norm options are: None, "area", "index", "areaindex" (default)

all_spectrums = {}
all_spectrums['subject'] = config['subject_name']

for file in glob.glob(config['surfdir'] + "/*.vtk"):
    print("working on " + file)
    spectrum = laplace_beltrami.spectrum_from_file(file, spectrum_size=spectrum_size, normalization=normalization)
    all_spectrums[os.path.basename(file)] = spectrum

with open( 'spectrum.json', 'w') as fp:
    json.dump(all_spectrums, fp, indent=4)
