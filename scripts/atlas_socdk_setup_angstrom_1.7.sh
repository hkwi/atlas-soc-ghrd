#!/bin/bash

# Clone 1.7 angstrom repo
git clone git://github.com/Angstrom-distribution/setup-scripts.git

# Add sources to layers.txt
echo "meta-altera,git://github.com/dwesterg/meta-altera.git,angstrom-v2014.12-yocto1.7,HEAD" >> setup-scripts/sources/layers.txt
echo "meta-altera-refdes,git://github.com/dwesterg/meta-altera-refdes.git,angstrom-v2014.12-yocto1.7,HEAD" >> setup-scripts/sources/layers.txt

#sed -i 's/meta-linaro.git.*/meta-linaro,git:\/\/git.linaro.org\/openembedded\/meta-linaro.git,master,HEAD/' setup-scripts/sources/layers.txt


# add BBLayers
sed -i '/meta-96boards/a \ \ \$\{TOPDIR\}\/sources\/meta-altera-refdes \\' setup-scripts/conf/bblayers.conf
sed -i '/meta-96boards/a \ \ \$\{TOPDIR\}\/sources\/meta-altera \\' setup-scripts/conf/bblayers.conf

# disable kde4 repo  / gitorious gone
#sed -i '/meta-kde4/d' setup-scripts/sources/layers.txt
#sed -i '/meta-kde4/d' setup-scripts/conf/bblayers.conf

# gumstix on gitorious too

#sed -i '/meta-gumstix-community/d' setup-scripts/sources/layers.txt
#sed -i '/meta-gumstix-community/d' setup-scripts/conf/bblayers.conf

sed -i '/rm_work/d' setup-scripts/conf/local.conf

pushd setup-scripts
MACHINE=atlas_sockit ./oebb.sh config atlas_sockit
popd

# Change download and cache dirs
sed -i '/DL_DIR/d' setup-scripts/conf/site.conf
sed -i '/SSTATE_DIR/d' setup-scripts/conf/site.conf
echo "DL_DIR = \"\${TOPDIR}/../downloads\"" >> setup-scripts/conf/site.conf
echo "SSTATE_DIR = \"\${TOPDIR}/../ang_sstate_cache\"" >> setup-scripts/conf/site.conf

# this qemu doesnt build with gcc5
rm setup-scripts/sources/meta-linaro/meta-linaro/recipes-devtools/qemu/qemu_git.bb

cd setup-scripts
source environment-angstrom-v2014.12

#mkdir sources/meta-altera-refdes/recipes-kernel/gator
#cp ../gator_git.bbappend sources/meta-altera-refdes/recipes-kernel/gator

export KERNEL_PROVIDER="linux-altera"
export BB_ENV_EXTRAWHITE="${BB_ENV_EXTRAWHITE} KERNEL_PROVIDER"

bitbake atlas-soc-image
