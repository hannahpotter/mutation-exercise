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

# Make the report
NEW_REPORT_DIR="mutant_report/coverage"
HEADER="<html><head><link title=\"Style\" type=\"text/css\" rel=\"stylesheet\" href=\"../../css/main.css\"/></head><body>"
FOOTER="</body></html>"
DEF_FILE="mutant_report/js/def.js"

echo "GENERATING REPORT..."

rm -rf mutant_report/coverage/original
rm -rf mutant_report/coverage/mutants
mkdir -p mutant_report/coverage/original
mkdir -p mutant_report/coverage/mutants

grep ,triangle.TriangleTest mutation_results/testMap.csv | while read -r testLine ; do
    testNo=$(echo $testLine | cut -d ',' -f1)
    testName=$(echo $testLine | cut -d ',' -f2)
    len=$(echo $testName | wc -c)
    end=$(expr $len - 2)
    testMethod=$(echo $testName | cut -c23-$end)

    line=$(echo $testMethod | grep -o . | grep -n ':')
    len=$(echo $line | wc -c)
    end=$(expr $len - 3)
    line=$(echo $line | cut -c1-$end)
    line=$(expr $line - 1)
    innerNumber=$(echo $testMethod | cut -c14-$line)
    coverageTestNo=$(grep "\[${innerNumber}:" coverage_original_results/testMap.csv | cut -d ',' -f1)

    echo $HEADER > mutant_report/coverage/original/${testNo}-triangle.html
    sed -n 20,100p coverage_original_results/${coverageTestNo}/triangle.Triangle.html >> mutant_report/coverage/original/${testNo}-triangle.html
    echo $FOOTER >> mutant_report/coverage/original/${testNo}-triangle.html
done 

echo "const mut_tests = new Map();" > $DEF_FILE
grep ,LIVE mutation_results/killed.csv | cut -f1 -d',' | while read -r mutNo ; do
    echo "const mut_${mutNo} = [];" >> $DEF_FILE
    grep ,$mutNo$ mutation_results/covMap.csv | cut -d ',' -f1 | while read -r testNo ; do
        testName=$(grep ^$testNo, mutation_results/testMap.csv | cut -d ',' -f2)
        len=$(echo $testName | wc -c)
        end=$(expr $len - 2)
        testMethod=$(echo $testName | cut -c23-$end)

        line=$(echo $testMethod | grep -o . | grep -n ':')
        len=$(echo $line | wc -c)
        end=$(expr $len - 3)
        line=$(echo $line | cut -c1-$end)
        line=$(expr $line - 1)
        innerNumber=$(echo $testMethod | cut -c14-$line)
        coverageTestNo=$(grep "\[${innerNumber}:" .mutated/mutants/${mutNo}/coverage_results/testMap.csv | cut -d ',' -f1)

        echo $HEADER > mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html
        sed -n 20,100p .mutated/mutants/${mutNo}/coverage_results/${coverageTestNo}/triangle.Triangle.html >> mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html
        echo $FOOTER >> mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html

        lineNum=$(grep ^$mutNo: mutation_results/mutants.log | grep -Eo "classify:[0-9]+" | grep -Eo '[0-9]+')
        python3 pretty.py mutant_report/coverage/mutants/${mutNo}-${testNo}-triangle.html $lineNum

        echo "mut_${mutNo}.push({testNo: ${testNo}, testName: \"${testMethod}\"});" >> $DEF_FILE
    done 
    echo "mut_tests.set(${mutNo}, mut_${mutNo});" >> $DEF_FILE
done

echo "DONE: mutant_report/index.html"

