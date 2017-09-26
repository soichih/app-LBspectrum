#!/usr/bin/env python
import sys
import time
sys.path.append("/N/u/brlife/git/mindboggle")
from mindboggle.shapes import laplace_beltrami

ev=300
while True:
    start_time = time.time()
    ev+=ev*0.1
    ev = int(ev)
    laplace_beltrami.spectrum_from_file("test/surfaces/Left_Cingulum_Cingulate_surf.vtk", spectrum_size=ev, normalization="areaindex")
    print ev,",",(time.time() - start_time) 

