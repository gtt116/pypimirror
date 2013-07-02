#!/bin/bash
# Clone all project shown below in the dir which this script located in.
# It will create an virtualenv and install all requirements of each project.
# Then output the pip requires.

set -e

projects='nova glance keystone tempest \
    python-novaclient python-keystoneclient python-glanceclient'

virtualenv .venv
source .venv/bin/activate

for project in $projects; do

    if [ ! -d $project ]; then
        git clone git://github.com/openstack/$project
    fi

    cd $project

    if [ -e tools/pip-requires ]; then
        pip install -r tools/pip-requires -r tools/test-requires
    else
        pip install -r requirements.txt -r test-requirements.txt
    fi

    cd ..
done

echo '-------------'
pip freeze
echo '-------------'
