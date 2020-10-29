#!/bin/bash
PARAMS=("-S" "--experiment=\"CI Benchmark Run Pipeline ID $CI_PIPELINE_ID\"" "--branch=\"$CI_COMMIT_REF_NAME\"")
git submodule update --recursive

VMS=(
  "e:SOMns-native"
  #"e:SOMns-graal-tn"
  #"e:SOMns"
)

rebench -f "${PARAMS[@]}" codespeed.conf all "${VMS[@]}"
REBENCH_EXIT=$?

## Archive Results

DATA_ROOT=~/benchmark-results/havlak

REV=`git rev-parse HEAD | cut -c1-8`

NUM_PREV=`ls -l $DATA_ROOT | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
LATEST=$DATA_ROOT/latest

mkdir -p $TARGET_PATH
bzip2 havlak_benchmark.data
cp havlak_benchmark.data.bz2 $TARGET_PATH/
rm $LATEST
ln -s $TARGET_PATH $LATEST

exit ${REBENCH_EXIT}
