#!/bin/bash
set -e

die() { echo "$*" 1>&2 ; exit 1; }

# The 'install.sh' entrypoint script is always executed as the root user.
#
LOCAL_INSTALL=0
which curl > /dev/null || (apt update && apt install curl -y -qq)
if ! which rustup > /dev/null; then   
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    LOCAL_INSTALL=1
fi

curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

WASM_PACK_INSTALL=`which wasm-pack` || die "wasm-pack install location not found!"

if [ $LOCAL_INSTALL -gt 0 ] ; then
    echo "wasm-pack is installed at $WASM_PACK_INSTALL"
    cp -a "$WASM_PACK_INSTALL" "/usr/local/bin/wasm-pack"
else
    if [ "$WASM_PACK_INSTALL" != "/usr/bin/wasm-pack" ] && [ "$WASM_PACK_INSTALL" != "/usr/local/bin/wasm-pack" ] ; then
        cp -a "$WASM_PACK_INSTALL" "/usr/local/bin/wasm-pack"
    fi
fi