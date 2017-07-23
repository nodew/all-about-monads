#!/bin/bash

function runExample() {
  local base
  local src
  local executable
  local prog
  local args

  base=$1
  shift
  args=$*
  src=../examples/${base}.hs
  executable=test_${base}
  prog=./${executable}

  echo -n "Example $base: "

  # check for source file
  if [ ! -r $src ]; then
    echo "No example source file $src"
    return 1
  fi

  # build the executable
  rm -f ${base}.o
  ghc --make $src -o $prog >${base}.log 2>&1

  if [ $? -ne 0 ]; then
    echo "failed to build. See ${base}.log"
    return 1
  fi

  # run the executable
  if [ -x ${executable} ]; then
    ./${executable} ${args}
  else
    echo "could not execute ${executable}"
    return 1
  fi

  # clean up
  rm -f $prog ${base}.log ${base}.out ${base}.o

  return 0
}

runExample $*

rm -f ../examples/*.hi ../examples/*.o
