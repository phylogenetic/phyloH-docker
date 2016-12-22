#!/bin/bash

# Branch of the phyloH repo - default to master
GITBRANCH=${GITBRANCH:-geographic}
#Default Value
LOG_FILE=${LOG_FILE:-run.log}
OUTPUT_PREFIX=${OUTPUT_PREFIX:-out}
EQUALQUANTITY=${EQUALQUANTITY:-0}
PAIRSWISE=${PAIRSWISE:-0}
TAXONOMY_FILENAME=${TAXONOMY_FILENAME:-}
PHYLOGENY_FILENAME=${PHYLOGENY_FILENAME:-}
GROUP_FILENAME=${GROUP_FILENAME:-}
GEOADD=${GEOADD:-0}
GRID_SIZE=${GRID_SIZE:-0}
MPOLYGON=${MPOLYGON:-0}

#non mandatory argument that if present switch on option
#if TAXONOMY_FILENAME is set...
if [ "$TAXONOMY_FILENAME" != "" ]; then 
TAXONOMY_FILENAME="-t $TAXONOMY_FILENAME"
fi
#if PHYLOGENY_FILENAME is set...
if [ "$PHYLOGENY_FILENAME" != "" ]; then 
PHYLOGENY_FILENAME="-f $PHYLOGENY_FILENAME"
fi
#if GROUP_FILENAME is set...
if [ "$GROUP_FILENAME" != "" ]; then
GROUP_FILENAME="-g $GROUP_FILENAME"
fi

echo WORK_DIR="$WORKDIR"
cd "$WORKDIR"

tar xvfz terr-ecoregions-TNC.tar.gz

# Redirect stderr and stdout to the log file
exec 1<&-
exec 2<&-

exec 1<>"$LOG_FILE"
exec 2>&1

# clone the code repo
git clone https://github.com/svicario/phyloH.git -b "$GITBRANCH"

# run the job execution
echo "-H $GRID_SIZE -M $MPOLYGON -G $GEOADD $PHYLOGENY_FILENAME -s $SAMPLE_FILENAME $GROUP_FILENAME -r $NPERM -o $OUTPUT_PREFIX -e $EQUALQUANTITY -k $PAIRSWISE $TAXONOMY_FILENAME"

python phyloH/esecutorePhyloHPandas.py -H $GRID_SIZE -M $MPOLYGON -G $GEOADD $PHYLOGENY_FILENAME -s $SAMPLE_FILENAME $GROUP_FILENAME -r $NPERM -o $OUTPUT_PREFIX -e $EQUALQUANTITY -k $PAIRSWISE $TAXONOMY_FILENAME
# collect the output
tar cvfz "$OUTPUT".tgz --ignore-failed-read external/ "$OUTPUT_PREFIX"* PhyloCommunity.js sample sub* "$LOG_FILE" 

# upload the output to the Object Storage
swift --insecure upload "$OUTPUT" "$OUTPUT".tgz 

# set read ACL on the container
swift --insecure post -r '.r:*' "$OUTPUT"

