#!/usr/bin/env bash

# first, copy over any extra shortcodes, like the pdf embedded shortcode
# https://stackoverflow.com/questions/793858/how-to-mkdir-only-if-a-directory-does-not-already-exist

mkdir -p layouts/shortcodes
cp extras/pdf_shortcodes/layouts/shortcodes/embed-pdf.html layouts/shortcodes/
mkdir -p static/js
cp -R extras/pdf_shortcodes/static/js/pdf-js static/js/

# oh god this is gross, but without it, we can't get pdf embedding to work through submodules
# well, once the pdf embedder fixes this issue...
# https://stackoverflow.com/questions/11145270/how-to-replace-an-entire-line-in-a-text-file-by-line-number
# the first line is the mac check, the rest is for another platform.
# could use https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux to build out further
# but fixing the base project is The Right Way
# why can nothing be easy?
if [ "$(uname)" == "Darwin" ]; then
sed  -e '1s#.*#<script type="text/javascript" src= "{{"/" | relURL}}/js/pdf-js/build/pdf.js"></script>#' -i '' layouts/shortcodes/embed-pdf.html
else
sed  -i '1s#.*#<script type="text/javascript" src= "{{"/" | relURL}}/js/pdf-js/build/pdf.js"></script>#' '' layouts/shortcodes/embed-pdf.html
fi
# now build the docker image to run everything

if [ ! -r ./node_modules ]; then
    docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'npm ci'
fi
if [ ! -r ./public ]; then
    docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'hugo --minify -v --destination public'
fi
