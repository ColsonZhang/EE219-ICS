#! /bin/bash -e

PWD=$(dirname $(readlink -f "%0"))
id=1
if [ -f "${PWD}/test/result.txt" ]; then rm ${PWD}/test/result.txt; fi

cat ${PWD}/test/cases.txt | while read parameters
do
    make clean
    make ${parameters}
    status=`cat ${PWD}/mem/status`
    echo -e "${id}\t${status}\t${parameters}" >> ${PWD}/test/result.txt
    let id+=1
done
cat ${PWD}/test/result.txt