#!/usr/bin/env bash

# first, copy over any extra shortcodes, like the pdf embedded shortcode
# https://stackoverflow.com/questions/793858/how-to-mkdir-only-if-a-directory-does-not-already-exist

mkdir -p layouts/shortcodes
cp extras/pdf_shortcodes/layouts/shortcodes/embed-pdf.html layouts/shortcodes/
mkdir -p static/js
cp -R extras/pdf_shortcodes/static/js/pdf-js static/js/

if [ ! -r ./node_modules ]; then
    podman run --rm --volume $PWD:/srv -w /srv docker.io/node npm ci
fi
if [ ! -r ./public ]; then
    podman run --rm --volume $PWD:/src -w /src docker.io/capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'hugo --minify -v --destination public'
fi
