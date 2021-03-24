#!/usr/bin/env bash

# first, copy over any extra shortcodes, like the pdf embedded shortcode

mkdir layouts/shortcodes
cp extras/pdf_shortcodes/layouts/shortcodes/embed-pdf.html layouts/shortcodes/
mkdir static
mkdir static/js
mkdir static/js/pdf-js
cp -R extras/pdf_shortcodes/static/js/pdf-js static/js/pdf-js/

# now build the docker image to run everything

if [ ! -r ./node_modules ]; then
    docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'npm ci'
fi
if [ ! -r ./public ]; then
    docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'hugo --minify -v --destination public'
fi
