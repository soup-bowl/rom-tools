#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Error: No tools were executed."
  echo ""
  echo "The following tools are available in this package:"
  echo " - tochd (chdman): https://thingsiplay.game.blog/tochd-converter"
  echo " - maxcso: https://github.com/unknownbrackets/maxcso"
  echo " - PSXPackager: https://github.com/RupertAvery/PSXPackager"
  exit 1
fi

exec "$@"
