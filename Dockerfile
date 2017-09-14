FROM continuumio/anaconda
MAINTAINER Lindsey Kitchell <kitchell@indiana.edu>

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/nipy/mindboggle.git
RUN pip install ./mindboggle/

ENV ENV=docker
ENV PYTHONPATH /mindboggle:$PYTHONPATH

RUN mkdir /app
COPY main.py /app
COPY environment.yml /app

RUN /bin/bash -c "conda env create -f /app/environment.yml"

#RUN source activate mindboggle

RUN mkdir /output
WORKDIR /output

RUN ldconfig

ENTRYPOINT ["/bin/bash", "-c", "source activate mindboggle && /app/main.py"]

