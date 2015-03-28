#!/bin/bash

if [ $1 == 'local' ]; then
  echo "Starting Jekyll serve using local settings."
  jekyll serve --config _config.yml,_local_config.yml
else
  echo "Starting Jekyll serve using default settings."
  jekyll serve
fi
