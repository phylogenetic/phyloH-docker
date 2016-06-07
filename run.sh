#!/bin/bash

# Branch of the phyloH repo - default to master
GITBRANCH=${GITBRANCH:-master}

cd $WORKDIR

# clone the code repo
git clone https://github.com/svicario/phyloH.git -b $GITBRANCH || exit 1

# run the job execution
python phyloH/esecutorePhyloHPandas.py -f $PHYLOGENY_FILENAME  -s $SAMPLE_FILENAME -g $GROUP_FILENAME -q 1 -r 2 -o $OUTPUT -e 0 -k 0 || exit 1

# collect the output
tar cvfz $OUTPUT.tgz external/ $OUTPUT* radial2.js || exit 1

# upload the output to the Object Storage
swift --insecure upload $OUTPUT $OUTPUT.tgz 

# set read ACL on the container
swift --insecure post -r '.r:*' $OUTPUT

