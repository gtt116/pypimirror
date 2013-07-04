#!/bin/bash
# Clone all project shown below in the dir which this script located in.
# It will create an virtualenv and install all requirements of each project.
# Then output the pip requires.

set -e

apts='libsqlite3-dev'

sudo apt-get install $apts

projects='keystone python-novaclient python-keystoneclient python-glanceclient nova glance tempest'

if [ ! -e .venv ]; then
    virtualenv .venv
fi
source .venv/bin/activate

> pips.txt
for project in $projects; do

    if [ ! -d $project ]; then
        git clone git://github.com/openstack/$project
    fi

    cd $project

    set +e
    max_attemp=0
    while [ "$max_attemp" -le 5 ]
    do
        max_attemp=$(($max_attemp + 1))
        echo "Try times: $max_attemp. "
        if [ -e 'requirements.txt' ]; then
            pip install -r 'requirements.txt'
            pip install -r 'test-requirements.txt'
        else
            pip install -r tools/pip-requires
            pip install -r tools/test-requires
        fi
    done
    set -e
    cd ..
done

pip freeze >> pips.txt

cat pips.txt |awk -F "==" '{print $1}'
