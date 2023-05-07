#!/bin/sh

NEW_REPORT_DIR="mutant_report/coverage"


grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
    testNo=$(echo $testLine | cut -d ',' -f1)
    testName=$(echo $testLine | cut -d ',' -f2)
    len=$(echo $testName | wc -c)
    end=$(expr $len - 2)
    testMethod=$(echo $testName | cut -c23-$end)

    sed -n 20,100p coverage_original_results/${testNo}/triangle.Triangle.html > mutant_report/coverage/original/${testNo}-triangle.html
done 

grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
    grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
        testNo=$(echo $testLine | cut -d ',' -f1)
        testName=$(echo $testLine | cut -d ',' -f2)
        len=$(echo $testName | wc -c)
        end=$(expr $len - 2)
        testMethod=$(echo $testName | cut -c23-$end)

        sed -n 20,100p .mutated/mutants/${mutNo}/coverage_results/${testNo}/triangle.Triangle.html > mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html
    done 
done

