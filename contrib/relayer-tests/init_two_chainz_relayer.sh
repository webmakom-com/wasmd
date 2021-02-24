#!/bin/bash
# init_two_chainz_relayer creates two wasmd chains and configures the relayer

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WASMD_DATA="$(pwd)/data"
RELAYER_CONF="$(pwd)/.relayer"

# Ensure wasmd is installed
if ! [ -x "$(which wasmd)" ]; then
  echo "Error: wasmd is not installed. Try running 'make build-wasmd'" >&2
  exit 1
fi

# Display software version for testers
echo "WASMD VERSION INFO:"
wasmd version --long

# Ensure jq is installed
if [[ ! -x "$(which jq)" ]]; then
  echo "jq (a tool for parsing json in the command line) is required..."
  echo "https://stedolan.github.io/jq/download/"
  exit 1
fi

# Delete data from old runs
rm -rf $WASMD_DATA &> /dev/null
rm -rf $RELAYER_CONF &> /dev/null

# Stop existing wasmd processes
killall wasmd &> /dev/null

set -e

chainid0=ibc-0
chainid1=ibc-1

echo "Generating wasmd configurations..."
mkdir -p $WASMD_DATA && cd $WASMD_DATA && cd ../
./one_chain.sh wasmd $chainid0 ./data 26657 26655 6060 9090
./one_chain.sh wasmd $chainid1 ./data 26558 26556 6061 9091

[ -f $WASMD_DATA/$chainid0.log ] && echo "$chainid0 initialized. Watch file $WASMD_DATA/$chainid0.log to see its execution."
[ -f $WASMD_DATA/$chainid1.log ] && echo "$chainid1 initialized. Watch file $WASMD_DATA/$chainid1.log to see its execution."
