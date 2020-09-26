#!/bin/bash

echo "Installing lynx"
curl -LSs --output /usr/local/bin/lynx https://raw.githubusercontent.com/DoubleSymmetry/lynx/master/bin/lynx
chmod +x /usr/local/bin/lynx
echo "lynx installed. Try running 'lynx'"
