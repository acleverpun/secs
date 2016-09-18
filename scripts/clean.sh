#!/usr/bin/env bash

rm -rf dist
mkdir dist
if [ -d vendor ]; then ln -s ../vendor dist/; fi
