#!/bin/bash
PARAMS=("-R" "--experiment=\"CI Benchmark Run Pipeline ID $CI_PIPELINE_ID\"" "--branch=\"$CI_COMMIT_REF_NAME\"")
git submodule update --recursive

VMS=(
  "e:SOMns-native"
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
bzip2 havlak_benchmark.data vanilla.log baseline.log phaseonly.log both.log
 
cp havlak_benchmark.data.bz2 $TARGET_PATH/
cp vanilla.log.bz2 $TARGET_PATH/
cp baseline.log.bz2 $TARGET_PATH/
cp phaseonly.log.bz2 $TARGET_PATH/
cp both.log.bz2 $TARGET_PATH/

rm $LATEST
ln -s $TARGET_PATH $LATEST

exit ${REBENCH_EXIT}
