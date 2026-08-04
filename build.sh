#!/bin/bash
# build.sh
# Compiles the modular C textbook and opens the result in zathura.
#
#   Usage:  ./build.sh           (compile + open in zathura)
#           ./build.sh --nopen   (compile only, no viewer)
#           ./build.sh --clean   (remove all generated artifacts)
#
# pdflatex needs to be run twice so that the \tableofcontents and all
# cross-references (\label / \ref) are resolved.

set -e

MAIN="main"
ARTIFACTS=".aux .log .out .toc .lof .lot .synctex.gz"

if [ "$1" = "--clean" ]; then
    rm -f "${MAIN}".*
    for ext in $ARTIFACTS; do
        rm -f *."${ext}"
    done
    echo "[build.sh] cleaned generated artifacts"
    exit 0
fi

# Pass 1: typeset everything, write the .toc.
pdflatex -interaction=nonstopmode -halt-on-error "${MAIN}.tex" > /dev/null

# Pass 2: resolve the table of contents and cross references.
pdflatex -interaction=nonstopmode -halt-on-error "${MAIN}.tex" > /dev/null

echo "[build.sh] ${MAIN}.pdf is ready"

if [ "$1" != "--nopen" ]; then
    zathura "${MAIN}.pdf" &
    echo "[build.sh] opened ${MAIN}.pdf in zathura"
fi
