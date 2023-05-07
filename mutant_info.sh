#!/bin/sh

MAJOR_HOME="lib/major"

$MAJOR_HOME/bin/ant mutation
echo Live mutants: $(grep ,LIVE mutation_results/killed.csv | cut -f1 -d',')

method=""
grep ,$1$ mutation_results/covMap.csv | cut -d ',' -f1 | ( while read -r testNo ; do
    testName=$(grep ^$testNo, mutation_results/testMap.csv | cut -d ',' -f2)
    len=$(echo $testName | wc -c)
    end=$(expr $len - 2)
    if [ ! -z "$method" ]
    then 
        method+=","
    fi
        method+=$(echo $testName | cut -c23-$end)
    echo $method
done
echo "methods=$method" > foo.properties )
echo "mutNo=$1" >> foo.properties
lineNum=$(grep ^$1: mutation_results/mutants.log | grep -Eo "classify:[0-9]+" | grep -Eo '[0-9]+')

$MAJOR_HOME/bin/ant coverage

NEW_REPORT="mutant_report/mutant_info.html"
mkdir mutant_report

header=$(sed -n 1,10p coverage_original_results/triangle.Triangle.html)
footer=$(sed -n 102,104p coverage_original_results/triangle.Triangle.html)

echo $original_table
echo $header > $NEW_REPORT
if [ -f ".mutated/mutants/$1/triangle/Triangle.svg" ]
then
    cp ".mutated/mutants/$1/triangle/Triangle.svg" "mutant_report/Triangle.svg"
    echo "<img src=\"Triangle.svg\" />" >> $NEW_REPORT
fi
echo "<h3>Test Information</h3>\n" >> $NEW_REPORT

echo "Tests that covered the mutant:\n" >> $NEW_REPORT
if [ $(grep ,$1$ mutation_results/covMap.csv | wc -l) -eq 0 ]
then
    echo "No tests cover the mutant on line $lineNum" >> $NEW_REPORT
else
    echo "<ul>\n" >> $NEW_REPORT
    grep ,$1$ mutation_results/covMap.csv | cut -d ',' -f1 | while read -r testNo ; do
        testName=$(grep ^$testNo, mutation_results/testMap.csv | cut -d ',' -f2)
        len=$(echo $testName | wc -c)
        end=$(expr $len - 2)
        echo "<li>" >> $NEW_REPORT
        echo $testName | cut -c23-$end >> $NEW_REPORT
        echo "</li>\n" >> $NEW_REPORT 
    done
    echo "</ul>\n" >> $NEW_REPORT

    echo "<div class=\"panes\" style=\"display:flex;\">" >> $NEW_REPORT
    sed -n 20,100p coverage_original_results/triangle.Triangle.html >> $NEW_REPORT
    sed -n 20,100p coverage_mutant_results/triangle.Triangle.html >> $NEW_REPORT
    echo "</div>" >> $NEW_REPORT
fi
echo $footer >> $NEW_REPORT

python3 pretty.py $lineNum

mkdir mutant_report/css
mkdir mutant_report/js
cp -r coverage_original_results/css mutant_report
cp -r coverage_original_results/js mutant_report

