#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/bibtex-tidy << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/bibtex-tidy/bin/bibtex-tidy "\$@"
EOF
chmod +x ${PREFIX}/bin/bibtex-tidy

# Create batch wrapper
tee ${PREFIX}/bin/bibtex-tidy.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\bibtex-tidy\bin\bibtex-tidy %*
EOF
