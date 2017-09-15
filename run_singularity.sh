
#need to push it to dockerhub before I can run it through singularity
docker tag lb_spectrum soichih/lb_spectrum
docker push soichih/lb_spectrum

export ENV=singularity
singularity run docker://soichih/lb_spectrum
