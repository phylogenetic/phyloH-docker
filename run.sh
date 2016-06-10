#!/bin/bash

# Branch of the phyloH repo - default to master
GITBRANCH=${GITBRANCH:-master}
LOG_FILE=${LOG_FILE:-run.log}
OUTPUT_PREFIX=${OUTPUT_PREFIX:-out}

cd "$WORKDIR"

# Redirect stderr and stdout to the log file
exec 1<&-
exec 2<&-

exec 1<>"$LOG_FILE"
exec 2>&1

# clone the code repo
git clone https://github.com/svicario/phyloH.git -b "$GITBRANCH"

# run the job execution
python phyloH/esecutorePhyloHPandas.py -f "$PHYLOGENY_FILENAME" -s "$SAMPLE_FILENAME" -g "$GROUP_FILENAME" -q 1 -r 2 -o "$OUTPUT_PREFIX" -e 0 -k 0 

# collect the output
tar cvfz "$OUTPUT".tgz --ignore-failed-read external/ "$OUTPUT_PREFIX"* radial2.js "$LOG_FILE" 

# upload the output to the Object Storage
swift --insecure upload "$OUTPUT" "$OUTPUT".tgz 

# set read ACL on the container
swift --insecure post -r '.r:*' "$OUTPUT"

