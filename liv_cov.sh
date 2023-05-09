#!/bin/sh

MAJOR_HOME="lib/major"

# Run mutation testing
$MAJOR_HOME/bin/ant mutation
echo Live mutants: $(grep ,LIVE mutation_results/killed.csv | cut -f1 -d',')

# Generate all the coverage reports
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

grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
    echo $mutNo
    $MAJOR_HOME/bin/ant coverageMutant -DmutNo=$mutNo
done

./make_report.sh