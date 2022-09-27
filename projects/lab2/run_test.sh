#! /bin/bash -e

id=1
if [ -f "test/result.txt" ]; then rm test/result.txt; fi

cat test/testcase.txt | while read parameters
do
    make clean
    make ${parameters}
    status=`cat mem/status`
    echo -e "${id}\t${status}\t${parameters}" >> test/result.txt
    let id+=1
done

