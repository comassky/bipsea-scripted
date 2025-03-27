#!/bin/bash
cmd='bipsea validate -m "$1" | bipsea xprv |  bipsea derive -a mnemonic -n "$2" -i "$3"'
derivated=$(eval "$cmd")
qrencode "$derivated" -t ANSI256 -m 2
