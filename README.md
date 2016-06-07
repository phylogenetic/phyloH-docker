# phyloH-docker
Docker image to run phyloH

https://github.com/svicario/phyloH

## Instructions

You can run this docker as follows:
- create a working dir in you current dir 
- copy the input files inside the newly created dir
- run the docker with the following command line:
<pre>
docker run -e PHYLOGENY_FILENAME=Echinodermata.tree -e SAMPLE_FILENAME=sampleTest -e GROUP_FILENAME=GroupTest -e OUTPUT=f5e25dd5-1d14-4863-858e-7e5f0c108d35 -e WORKDIR=/workdir -e OS_AUTH_URL="..." -e OS_USERNAME="...." -e OS_TENANT_NAME="...." -e OS_PASSWORD="..." -v $(pwd)/workdir:/workdir phylogenetic/phyloH-docker:latest
</pre>
