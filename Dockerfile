FROM geodata/grass
MAINTAINER Marica Antonacci <marica.antonacci@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends python-pip g++ && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install python-keystoneclient python-swiftclient numpy Biopython pandas ete2 

COPY run.sh /run.sh

CMD ["/run.sh"]
