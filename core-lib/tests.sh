#!/bin/bash
## Exit on first error
if [ "$1" != "update" ]
then
  # quit on first error
  set -e
fi

## Determine absolute path of script
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

TESTED_BENCHS="$BENCH_PATH/Bounce.ns $BENCH_PATH/DeltaBlue.ns $BENCH_PATH/DeltaBlueNS.ns $BENCH_PATH/Fannkuch.ns $BENCH_PATH/GCBench.ns $BENCH_PATH/GraphSearch.ns $BENCH_PATH/Havlak.ns $BENCH_PATH/Json.ns $BENCH_PATH/List.ns $BENCH_PATH/Mandelbrot.ns $BENCH_PATH/NBody.ns  $BENCH_PATH/Permute.ns $BENCH_PATH/Queens.ns $BENCH_PATH/Richards.ns $BENCH_PATH/RichardsNS.ns $BENCH_PATH/Sieve.ns $BENCH_PATH/Splay.ns $BENCH_PATH/Storage.ns $BENCH_PATH/Towers.ns"
SOM_DIR=$SCRIPT_PATH/..
NEEDS_UPDATE=false
BENCH_PATH="$SCRIPT_PATH/Benchmarks"
BENCH_DATE=$(date '+%Y-%m-%d_%Hh%M')
RESULTS_PATH=$SCRIPT_PATH/results/$BENCH_DATE

if [ "$1" = "--coverage" ]
then
  COVERAGE="--java-coverage $SOM_DIR/jacoco.exec "
fi

## create folder for new results
mkdir -p $RESULTS_PATH/

## run benchmarks
function runBenchmark {
  BENCH=$1
  HARNESS="$SOM_DIR/som-native -dm -Ddm.metrics=$RESULTS_PATH/$BENCH \
    -G $SOM_DIR/core-lib/Benchmarks/Harness.ns"
   echo $HARNESS $@
   echo $HARNESS $@ >> $RESULTS_PATH/log.txt
   $HARNESS $@ 
}

function plotting {
  result_path=$1
  bench_name=$2
  param=$3-$4-$5
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-$param-depth.pdf
}

#for f in $BENCH_PATH/Havlak.ns $BENCH_PATH/Storage.ns $BENCH_PATH/GCBench.ns
#for f in $BENCH_PATH/*.ns
for f in $TESTED_BENCHS
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$RESULTS_PATH/$bench_name
  runBenchmark $bench_name $@
  plotting $result_path $bench_name $@
  #Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-$1-$2-$3_depth.pdf
done
