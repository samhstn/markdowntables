#!/bin/bash

set -e

PATH=$(npm bin):$PATH

elm make src/Main.elm --output=src/elm.js --optimize

# adapted from https://guide.elm-lang.org/optimization/asset_size.html
browserify src/index.js |
uglifyjs --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' |
uglifyjs --mangle --output=public/index.js

echo "Initial size: $(cat src/elm.js | wc -c) bytes  (src/elm.js)"
echo "Minified size:$(cat public/index.js | wc -c) bytes  (public/index.js)"
