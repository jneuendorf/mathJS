#!/bin/bash

FILES=$(for file in tests/spec/*.coffee; do echo $file; done)

# cat $FILES | tr '\n' ' ' | coffee --compile --stdio > tests/spec/spec.js
cat $FILES | coffee --compile --stdio > tests/spec/spec.js
