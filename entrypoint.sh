#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Error: No tools were executed."
  echo ""
  echo "The following tools are available in this package:"
  echo " - tochd:  https://thingsiplay.game.blog/tochd-converter"
  echo " - maxcso: https://github.com/unknownbrackets/maxcso"
  exit 1
fi

exec "$@"
