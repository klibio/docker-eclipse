#!/bin/bash
set -eux && SCRIPT_DIR="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"

# this script downloads and prepares the osgi starterkit for cmd line p2.director usage
echo "download and extract OSGi-starterkit"
cd $SCRIPT_DIR
BINARY_URL='https://www.eclipse.org/downloads/download.php?file=/equinox/drops/R-4.20-202106111600/EclipseRT-OSGi-StarterKit-4.20-linux-gtk-x86_64.tar.gz&r=1'
curl -LfsSo starterkit.tar.gz ${BINARY_URL}
tar -xvzf starterkit.tar.gz
mv ${SCRIPT_DIR}/rt/ ${SCRIPT_DIR}/osgi/
rm -rf starterkit.tar.gz

# download and configure additional bundles required for p2.director cmd line usage
function downloadBundle {
    echo -e "# downloading $1\n"
    curl -LfsSo ${SCRIPT_DIR}/osgi/plugins/$1 ${ECL_PLATFORM}/$1
}

ECL_PLATFORM="https://download.eclipse.org/eclipse/updates/4.20/R-4.20-202106111600/plugins"
SCR_BUNDLE="org.apache.felix.scr_2.1.24.v20200924-1939.jar"

NET_BUNDLE="org.eclipse.core.net_1.3.1100.v20210424-0724.jar"
downloadBundle $NET_BUNDLE
RUNTIME_BUNDLE="org.eclipse.core.runtime_3.22.0.v20210506-1025.jar"
downloadBundle $RUNTIME_BUNDLE
DIRECTOR_BUNDLE="org.eclipse.equinox.p2.director.app_1.2.0.v20210315-2042.jar"
downloadBundle $DIRECTOR_BUNDLE
CONTENTYPE_BUNDLE="org.eclipse.core.contenttype_3.7.1000.v20210409-1722.jar"
downloadBundle $CONTENTYPE_BUNDLE

CONFIG_FILE=${SCRIPT_DIR}/osgi/configuration/config.ini
# add core.runtime and p2.director.app to config.ini (must be before formatting)
sed -i 's/p2.director_2.5.0.v20210325-0750.jar@4,reference/p2.director_2.5.0.v20210325-0750.jar@4,reference\\:file\\:'${RUNTIME_BUNDLE}'@4:start,reference\\:file\\:'${CONTENTYPE_BUNDLE}'@4,reference\\:file\\:'${DIRECTOR_BUNDLE}'@4,reference\\:file\\:'${NET_BUNDLE}'@4,reference/g' ${CONFIG_FILE}
# format config.ini file
sed -i 's/reference\\:/\\\n  reference\\:/g' ${CONFIG_FILE}
# modify start level
sed -i 's/'${SCR_BUNDLE}'@4/'${SCR_BUNDLE}'@2:start/g' ${CONFIG_FILE}
