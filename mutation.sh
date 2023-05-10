#!/bin/sh

MAJOR_HOME="lib/major"

$MAJOR_HOME/bin/ant mutation
echo $(grep ,LIVE mutation_results/killed.csv | cut -f1 -d',') | tr ' ' ','> mutation_results/live_mutants.log

echo Live mutants: $(grep ,LIVE mutation_results/killed.csv | cut -f1 -d',')
