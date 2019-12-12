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

TESTED_BENCHS="   $BENCH_PATH/GCBench.ns    $BENCH_PATH/List.ns $BENCH_PATH/Splay.ns"

MACRO1="$BENCH_PATH/Havlak.ns $BENCH_PATH/Richards.ns $BENCH_PATH/RichardsNS.ns $BENCH_PATH/GraphSearch.ns "
MACRO2="$BENCH_PATH/Json.ns"
MACRO50="$BENCH_PATH/Mandelbrot.ns"
MACRO200="$BENCH_PATH/DeltaBlue.ns $BENCH_PATH/DeltaBlueNS.ns"
MACRO1000="$BENCH_PATH/NBody.ns"

SOM7="$BENCH_PATH/Fannkuch.ns"
SOM10="$BENCH_PATH/Permute.ns $BENCH_PATH/Queens.ns"
SOM20="$BENCH_PATH/Bounce.ns $BENCH_PATH/Storage.ns $BENCH_PATH/Towers.ns"
SOM100="$BENCH_PATH/Sieve.ns"


SOM_DIR=$SCRIPT_PATH/..
NEEDS_UPDATE=false
#ALL_BENCHS="$SCRIPT_PATH/Benchmarks/*.ns"
BENCH_PATH="$SCRIPT_PATH/Benchmarks"
BENCH_DATE=$(date '+%Y-%m-%d_%Hh%M')

if [ "$1" = "--coverage" ]
then
  COVERAGE="--java-coverage $SOM_DIR/jacoco.exec "
fi

## create folder for new results
mkdir -p $SCRIPT_PATH/$BENCH_DATE/

## run benchmarks
function runBenchmark {
  BENCH=$1
  HARNESS="$SOM_DIR/som -dm -Ddm.metrics=$SCRIPT_PATH/$BENCH_DATE/$BENCH \
    -G $SOM_DIR/core-lib/Benchmarks/Harness.ns"
   echo $HARNESS $@
   echo $HARNESS $@ >> $SCRIPT_PATH/$BENCH_DATE/log.txt
   $HARNESS $@  
}

for f in $MACRO1
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 1
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $MACRO2
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 2
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $MACRO50
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 50
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $MACRO200
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 200
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $MACRO1000
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 1000
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $SOM7
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 7
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $SOM10
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 10
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $SOM20
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 20
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

for f in $SOM100
do	
  full_path_to_file=$f
  filename="${f##*/}"
  bench_name="${filename%.ns}"
  result_path=$SCRIPT_PATH/$BENCH_DATE/$bench_name
  runBenchmark $bench_name 1 0 100
  Rscript plotting.R $result_path/stack-depth.csv $result_path/$bench_name-depth.pdf
done

result_path=$SCRIPT_PATH/$BENCH_DATE/Sort.TreeSort
runBenchmark Sort.TreeSort 1 0 10
Rscript plotting.R $result_path/stack-depth.csv $result_path/Tree-depth.pdf

result_path=$SCRIPT_PATH/$BENCH_DATE/Sort.BubbleSort
runBenchmark Sort.BubbleSort 1 0 25
Rscript plotting.R $result_path/stack-depth.csv $result_path/Bubble-depth.pdf

result_path=$SCRIPT_PATH/$BENCH_DATE/Sort.QuickSort
runBenchmark Sort.QuickSort 1 0 20
Rscript plotting.R $result_path/stack-depth.csv $result_path/Quick-depth.pdf


if [ "$1" = "update" ] && [ "$NEEDS_UPDATE" = true ]
then
  ## move old results out of the way, and new results to expected folder
  rm -Rf $SCRIPT_PATH/old-results
fi
