#!/bin/sh

NEW_REPORT_DIR="mutant_report/coverage"
HEADER="<html><head><link title=\"Style\" type=\"text/css\" rel=\"stylesheet\" href=\"../../css/main.css\"/></head><body>"
FOOTER="</body></html>"
DEF_FILE="mutant_report/js/def.js"

rmdir mutant_report/coverage/original
rmdir mutant_report/coverage/mutants
mkdir mutant_report/coverage/original
mkdir mutant_report/coverage/mutants

grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
    testNo=$(echo $testLine | cut -d ',' -f1)
    testName=$(echo $testLine | cut -d ',' -f2)
    len=$(echo $testName | wc -c)
    end=$(expr $len - 2)
    testMethod=$(echo $testName | cut -c23-$end)

    echo $HEADER > mutant_report/coverage/original/${testNo}-triangle.html
    sed -n 20,100p coverage_original_results/${testNo}/triangle.Triangle.html >> mutant_report/coverage/original/${testNo}-triangle.html
    echo $FOOTER >> mutant_report/coverage/original/${testNo}-triangle.html
done 

echo "const mut_tests = new Map();\n" > $DEF_FILE
grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
    echo "const mut_${mutNo} = [];" >> $DEF_FILE
    grep ,$mutNo$ mutation_results/covMap.csv | cut -d ',' -f1 | while read -r testNo ; do
        testName=$(grep ^$testNo, mutation_results/testMap.csv | cut -d ',' -f2)
        len=$(echo $testName | wc -c)
        end=$(expr $len - 2)
        testMethod=$(echo $testName | cut -c23-$end)

        echo $HEADER > mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html
        sed -n 20,100p .mutated/mutants/${mutNo}/coverage_results/${testNo}/triangle.Triangle.html >> mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html
        echo $FOOTER >> mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html

        echo "mut_${mutNo}.push({testNo: ${testNo}, testName: \"${testMethod}\"});" >> $DEF_FILE
    done 
    echo "mut_tests.set(${mutNo}, mut_${mutNo});\n" >> $DEF_FILE
done


