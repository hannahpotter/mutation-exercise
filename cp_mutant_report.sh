#!/usr/bin/env bash

RESULTS_COPY_TARGET="/cse/web/homes/${USER}"
MUTANT_REPORT_DIR_NAME="mutant_report"
MUTANT_REPORT_DIR_LOCATION="."

MUTANT_REPORT_DIR_PATH=${MUTANT_REPORT_DIR_LOCATION}/${MUTANT_REPORT_DIR_NAME}

if [ ! -d ${RESULTS_COPY_TARGET} ]; then
    echo "\
Could not find the directory where code coverage results would be copied to:
${RESULTS_COPY_TARGET}

Please:
- Make sure you are running this script on attu.cs.washington.edu, as it is not
  intended to be run elsewhere.
- Check with CSE home page service to see if they have changed the home page
  webroot's path."
    exit 1
fi

if [ ! -d ${MUTANT_REPORT_DIR_PATH} ]; then
    echo "\
Could not find the mutant results directory:
${MUTANT_REPORT_DIR_PATH}

Please:
- Make sure you have just run './mutant_info.sh'.
- Make sure such directory exists."
    exit 1
fi

echo "Removing any old results..."
rm -rf ${RESULTS_COPY_TARGET}/${MUTANT_REPORT_DIR_NAME}
echo "Copying results..."
if cp -r ${MUTANT_REPORT_DIR_PATH} ${RESULTS_COPY_TARGET}; then
    echo "\

Code coverage results are now accessible from:
https://homes.cs.washington.edu/~${USER}/${MUTANT_REPORT_DIR_NAME}"
    exit 0
else
    exit 1
fi
