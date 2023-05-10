#!/bin/sh

MAJOR_HOME="lib/major"

echo RUNNING MUTATION ANALYSIS...
./mutation.sh > mutant_report/report.log
grep "Live mutants:" mutant_report/report.log

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

echo ANALYZING LIVE MUTANTS...
$MAJOR_HOME/bin/ant coverageOriginal >> mutant_report/report.log
$MAJOR_HOME/bin/ant coverageMutants >> mutant_report/report.log
#grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
#    printf "$mutNo "
#    $MAJOR_HOME/bin/ant coverageMutant -DmutNo=$mutNo >> mutant_report/report.log
#done
#echo

./make_report.sh
