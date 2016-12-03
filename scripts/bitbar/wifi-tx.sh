#!/bin/bash

# <bitbar.title>Wi-Fi Tx Speed</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>vilhalmer</bitbar.author>

PATH=/usr/local/bin/:$PATH

airport --getinfo | perl -ne 'print if s/\s+lastTxRate: ([0-9]+)$/\1 Mbps|size=12/'
