#!/bin/bash
set -eux && scriptDir="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"

PATH=${scriptDir}/jre/bin:$PATH

${scriptDir}/osgi/rt \
-application org.eclipse.equinox.p2.director \
-repository \
http://download.eclipse.org/eclipse/updates/4.20/R-4.20-202106111600,\
https://download.eclipse.org/releases/2020-12/202012161000,\
https://bndtools.jfrog.io/bndtools/update-latest,\
https://netceteragroup.github.io/quickrex/updatesite \
-installIU org.eclipse.platform.feature.group,\
org.eclipse.sdk.feature.group,\
org.eclipse.sdk.examples.feature.group,\
org.eclipse.oomph.p2.ui,\
bndtools.m2e.feature.feature.group,\
bndtools.main.feature.feature.group,\
bndtools.pde.feature.feature.group,\
com.netcetera.eclipse.quickrex.feature.feature.group \
-configuration ${scriptDir}/rt/p2.dir.app_cfg \
-destination ${scriptDir}/eclipse \
-profile DockerEclipse \
-profileProperties org.eclipse.update.install.features=true \
-p2.os linux \
-p2.ws gtk \
-p2.arch x86_64 \
-roaming \
-purgeHistory \
-flavor tooling
