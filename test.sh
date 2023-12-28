#!/bin/bash

max=25

for i in `seq 1 $max`; do
    val=`printf %02d $i`
    if [ -d "$val" ]; then
        is_part=false
        if [ -e "./$val/.part" ]; then
            echo "Day $val is only partly done, skipping part 2 tests..."
            is_part=true
        fi
        if [ "$is_part" = true ]; then
            echo "Testing Day $val part 1 sample"
            diff <(head -n 1 "$val/expected_sample") <(nim c -r "./$val/main.nim" < "./$val/sample" | head -n 1)
        else
            echo "Testing Day $val sample"
            nim c -r "./$val/main.nim" < "./$val/sample" | diff "$val/expected_sample" -
        fi
        if [ "$?" != 0 ]; then
            >&2 echo "Day $val sample file failed"
            exit 1
        fi
        for t in `seq 1 5`; do
            if [ -f "$val/expected_sample$t" ]; then
                if [ "$is_part" = true ]; then
                    echo "Testing Day $val part 1 sample $t"
                    diff <(head -n 1 "$val/expected_sample$t") <(nim c -r "./$val/main.nim" < "./$val/sample$t" | head -n 1)
                else
                    echo "Testing Day $val sample $t"
                    nim c -r "./$val/main.nim" < "./$val/sample$t" | diff "$val/expected_sample$t" -
                fi
                if [ "$?" != 0 ]; then
                    >&2 echo "Day $val sample file $t failed"
                    exit 1
                fi
            fi
        done
        if [ "$is_part" = true ]; then
            echo "Testing Day $val part 1 real"
            diff <(head -n 1 "$val/expected") <(nim c -r "./$val/main.nim" < "./$val/input" | head -n 1)
        else
            echo "Testing Day $val real"
            nim c -r "./$val/main.nim" < "./$val/input" | diff "$val/expected" -
        fi
        if [ "$?" != 0 ]; then
            >&2 echo "Day $val failed"
            exit 1
        fi
        if [ "$is_part" = true ]; then
            echo "Day $val part 1 passed!"
        else
            echo "Day $val passed!"
        fi
    fi
done
