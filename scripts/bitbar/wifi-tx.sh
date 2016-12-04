#!/bin/bash

# <bitbar.title>Wi-Fi Tx Speed</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>vilhalmer</bitbar.author>

PATH=/usr/local/bin/:$PATH

state=$(airport --getinfo | perl -ne 'print if s/\s*lastTxRate: ([0-9]+)$/\1 Mbps/; print if s/\s*AirPort: (\w+)$/\1/')
echo "$state|size=12"
