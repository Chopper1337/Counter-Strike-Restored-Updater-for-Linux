#!/usr/bin/env bash
# Author: Chopper1337
# Date: 2026-01-16

# KNOWN VALUES
DEBUG=0                                       # Set to 1 for more output
API_DATA_PATH="./CSR_API_CACHE.json"          # File in which we cache API data
API_URL="https://download-api.csrestored.com" # windows api alo where leenox mens))
DL_URL="https://download.csrestored.com"      # Where we download the files from
MAX_CACHE_AGE=30                              # How old the cached API data can be before it should require an update (30mins)

# FUNCTIONS
DL_API_JSON() {
  echo "Downloading latest file data..."
  curl -s "$API_URL" --output "$API_DATA_PATH"
}

DL_GAME_FILE() {
  echo "Downloading $1"
  wget --quiet --progress=bar  "$DL_URL/$1" -O "./$1"
}

CHECK_DEPS() {
  # check dependencies
  deps=(curl wget md5sum)

  for dep in ${deps[@]}; do
    which $dep || exit
  done

}

echo_dbg() {
  if [[ $DEBUG -eq 1 ]]; then
    echo "$@"
  fi
}

# LOGIC

CHECK_DEPS

# If the csgo.sh file doesn't exist, exit with error
[ -e "./csgo.sh" ] || {
  echo "Not running from CSGO directory"
  exit 1
}

# Only run the script from its own directory
cd "$(cd "${0%/*}" && echo $PWD)" || exit

# If the api data hasn't yet been cached, download it
[ ! -e "$API_DATA_PATH" ] && DL_API_JSON

# If the api cache is old, update it
{ find "$API_DATA_PATH" -mmin +$MAX_CACHE_AGE | grep "$API_DATA_PATH"; } && DL_API_JSON

API_DATA=$(cat "$API_DATA_PATH")
FILE_LIST=$(echo $API_DATA | jq -r '.[].file')
HASH_LIST=$(echo $API_DATA | jq -r '.[].hash')

# For every file in the API
for FILE in $FILE_LIST; do
  # Get the API provided hash for the file
  API_HASH=$(jq ".[] | select(.file == \"$FILE\") | .hash" $API_DATA_PATH | sed 's/\"//g')

  # If the file exists
  if [[ -e "./$FILE" ]]; then
    # Calculate hash
    HASH=$(md5sum "./$FILE" | awk '{print $1}' | sed 's/\"//g')
    echo_dbg "$FILE hash: $HASH"
    echo_dbg "$FILE API hash: $API_HASH"
    # If the hash doesn't match
    if [[ ! "$HASH" == "$API_HASH" ]]; then
      echo "$FILE needs to be updated"
      # Download the new file
      DL_GAME_FILE "$FILE"
    else
      echo_dbg "$FILE already up to date"
    fi
  # If the file doesn't exist
  else
    DIRNAME=$(dirname "./$FILE")
    if [[ ! -e "$DIRNAME" ]]; then
      mkdir -p "$DIRNAME"
    fi
    echo "$FILE not present"
    # Download it
    DL_GAME_FILE "$FILE"
  fi
done
