FROM neurodebian:xenial
MAINTAINER Lindsey Kitchell <kitchell@indiana.edu>

RUN apt-get update && apt-get install -y python git

RUN git clone https://github.com/nipy/mindboggle.git
RUN cd /mindboggle && python setup.py install

ENV ENV docker
ENV PYTHONPATH /mindboggle:$PYTHONPATH

RUN mkdir /app
COPY main.py /app

RUN mkdir /output
WORKDIR /output

RUN ldconfig

CMD /app/main.py

