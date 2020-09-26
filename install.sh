#!/bin/bash

function get_download_url {
	curl -s https://api.github.com/repos/DoubleSymmetry/lynx/releases/latest | grep browser_download_url | grep lynx | cut -d '"' -f 4
}

echo "Installing lynx"
curl -LSs --output /usr/local/bin/lynx $(get_download_url)
chmod +x /usr/local/bin/lynx
echo "lynx installed. Try running 'lynx'"
