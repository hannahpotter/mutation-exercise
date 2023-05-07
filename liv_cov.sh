#!/bin/sh

MAJOR_HOME="lib/major"

$MAJOR_HOME/bin/ant mutation
echo Live mutants: $(grep ,LIVE mutation_results/killed.csv | cut -f1 -d',')

method=""
grep ,triangle.TriangleTest mutation_results/testMap.csv | ( while read -r testLine ; do
    testNo=$(echo $testLine | cut -d ',' -f1)
    testName=$(echo $testLine | cut -d ',' -f2)
    len=$(echo $testName | wc -c)
    end=$(expr $len - 2)
    testMethod=$(echo $testName | cut -c23-$end)
    if [ ! -z "$method" ]
    then 
        method+=","
    fi
        method+=$(echo $testName | cut -c23-$end)
done
echo "testMethods=$method" > foo.properties )

$MAJOR_HOME/bin/ant coverageOriginal

grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
    testNo=$(echo $testLine | cut -d ',' -f1)
    $MAJOR_HOME/bin/ant coverageReportOriginal -DtestNo=$testNo
done

#grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
#    testNo=$(echo $testLine | cut -d ',' -f1)
#    testName=$(echo $testLine | cut -d ',' -f2)
#    len=$(echo $testName | wc -c)
#    end=$(expr $len - 2)
#    testMethod=$(echo $testName | cut -c23-$end)
#    echo "testMethod=$testMethod" > foo.properties
#    $MAJOR_HOME/bin/ant coverageOriginal -DtestNo=$testNo
#done 

#grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
#    grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
#        testNo=$(echo $testLine | cut -d ',' -f1)
#        testName=$(echo $testLine | cut -d ',' -f2)
#        len=$(echo $testName | wc -c)
#        end=$(expr $len - 2)
#        testMethod=$(echo $testName | cut -c23-$end)
#        echo "testMethod=$testMethod" > foo.properties
#        $MAJOR_HOME/bin/ant coverageMutant -DmutNo=$mutNo -DtestNo=$testNo
#    done 
#done