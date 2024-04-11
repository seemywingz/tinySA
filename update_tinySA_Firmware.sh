#!/bin/bash
#set -x  # Enable debugging output

export TINYSA_MODEL="tinySA"       

for arg in "$@";do
  if [[ $arg == "--ultra" ]]; then
    TINYSA_MODEL="tinySA4"
  fi
done

export TINYSA_BAT="DFU_LOAD_BIN.bat"
export TINYSA_DFU_URL=http://athome.kaashoek.com/${TINYSA_MODEL}/DFU/
export TINYSA_BIN=$(curl -s "${TINYSA_DFU_URL}" | grep -o '[^"]*\.bin' | head -1)

echo "🛜  Fetching Latest Firmware from: ${TINYSA_DFU_URL}"
echo "⬇️  Downloading: ${TINYSA_BIN}"
rm ${TINYSA_BIN} 2>/dev/null
wget -q "${TINYSA_DFU_URL}${TINYSA_BIN}" 
# Check if the download was successful
if [ ! -f "$TINYSA_BIN" ]; then
    echo "Failed to download firmware. Exiting."
    exit 1
fi
foo
echo "⬇️  Downloading: ${TINYSA_BAT}"
rm ${TINYSA_BAT} 2>/dev/null
wget -q "${TINYSA_DFU_URL}${TINYSA_BAT}"
# Check if the download was successful
if [ ! -f ${TINYSA_BAT} ]; then
  echo "Failed to download ${TINYSA_BAT}."
fi

echo "⚙️  Running DFU Update"
dfu-util -a 0 -s 0x08000000:leave -D ${TINYSA_BIN}
