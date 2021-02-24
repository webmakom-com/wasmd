#!/bin/bash
# init_two_chainz_relayer creates two wasmd chains and configures the relayer

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WASMD_DATA="$(pwd)/data"
RELAYER_CONF="$(pwd)/.relayer"

# Ensure relayer is installed
if ! [ -x "$(which rly)" ]; then
  echo "Error: wasmd is not installed. Try running 'make build-wasmd'" >&2
  exit 1
fi

echo "Generating rly configurations..."
rly config init
rly config add-chains configs/wasmd/chains
rly config add-paths configs/wasmd/paths

SEED0=$(jq -r '.mnemonic' $WASMD_DATA/ibc-0/key_seed.json)
SEED1=$(jq -r '.mnemonic' $WASMD_DATA/ibc-1/key_seed.json)
echo "Key $(rly keys restore ibc-0 testkey "$SEED0") imported from ibc-0 to relayer..."
echo "Key $(rly keys restore ibc-1 testkey "$SEED1") imported from ibc-1 to relayer..."
echo "Creating light clients..."
sleep 3
rly light init ibc-0 -f
rly light init ibc-1 -f
