#!/bin/bash

set -e

if [ ! -d public ];then
  mkdir public
fi

PATH=$(npm bin):$PATH

elm make src/Main.elm --output=src/elm.js --optimize

# adapted from https://guide.elm-lang.org/optimization/asset_size.html
browserify src/index.js |
uglifyjs --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' |
uglifyjs --mangle --output=public/index.js

JS_FILENAME="index-$(md5 -q public/index.js).min.js"
CSS_FILENAME="index-$(md5 -q src/index.css).min.css"

cp public/index.js public/$JS_FILENAME
cp src/index.css public/$CSS_FILENAME

cat src/index.html | sed "s/index\.js/$JS_FILENAME/" | sed "s/index\.css/$CSS_FILENAME/" > public/index.html

echo ""
echo "built $JS_FILENAME size: $(cat public/$JS_FILENAME | wc -c) bytes"
echo "built $CSS_FILENAME size: $(cat public/$CSS_FILENAME | wc -c) bytes"
