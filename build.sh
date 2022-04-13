#!/bin/sh

mkdir -p build
cp index.html build/
elm make src/Main.elm --output=build/main.js --optimize