#!/bin/bash
# Copyright 2022 Le Montagner Roman
# Author: Le Montagner Roman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
## Script to launch the python test suite and measure the coverage.

set -e

python -m pip install .

export ROOTPATH=`pwd`
# source ${FINK_BROKER}/conf/fink.conf.prod

# export FINK_PACKAGES=$FINK_PACKAGES
# export FINK_JARS=$FINK_JARS
# export KAFKA_IPPORT_SIM=$KAFKA_IPPORT_SIM
# export KAFKA_TOPIC="ztf-stream-sim"

# Add coverage_daemon to the pythonpath. See python/fink_broker/tester.py
export PYTHONPATH="${SPARK_HOME}/python/test_coverage:$PYTHONPATH"
export COVERAGE_PROCESS_START=".coveragerc"

# echo "pytest -q fink_utils/photometry/test.py"
# pytest -q fink_utils/photometry/test.py

# echo "fink_utils/xmatch/simbad.py"
# coverage run \
#     --source=${ROOTPATH} \
#     --rcfile .coveragerc \
#     fink_utils/xmatch/simbad.py

for filename in fink_utils/broker/*.py
do
    echo $filename
    coverage run \
    --source=${ROOTPATH} \
    --rcfile .coveragerc \
    $filename
done

for filename in fink_utils/test/*.py
do
    echo $filename
    coverage run \
    --source=${ROOTPATH} \
    --rcfile .coveragerc \
    $filename
done

coverage combine

unset FINK_PACKAGES
unset FINK_JARS

coverage report -m
coverage html
