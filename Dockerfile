FROM continuumio/anaconda
MAINTAINER Lindsey Kitchell <kitchell@indiana.edu>

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/nipy/mindboggle.git
RUN pip install ./mindboggle/

ENV ENV=docker
#ENV PYTHONPATH /mindboggle:$PYTHONPATH

RUN mkdir /app
COPY main.py /app
COPY environment.yml /app

RUN conda env create -f environment.yml

RUN mkdir /output
WORKDIR /output

RUN ldconfig

CMD /app/main.py

