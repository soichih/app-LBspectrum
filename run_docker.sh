docker run -e ENV=docker --rm -it \
        -v `pwd`/testdata:/input \
        -v `pwd`:/output \
        lb_spectrum
