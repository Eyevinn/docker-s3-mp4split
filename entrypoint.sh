#!/bin/bash

usage()
{
  echo "Usage: s3-mp4split [ -o OUTPUT ] input(s)"
  exit 2
}

args=()
eval set -- "$@"
while [[ $# > 0 ]]; do
  case "$1" in
    -o)
      OUTPUT=$2
      shift
      ;;
    *)
      args+=($1)
      ;;
  esac
  shift
done

if [ -z "$OUTPUT" ]; then
  usage
fi

echo "Writing to $OUTPUT"
echo "mp4split args: ${args[*]}"

set -o pipefail; \
  UspLicenseKey=$USP_LICENSE_KEY mp4split -o stdout:.temp ${args[*]} | \
  aws s3 cp - $OUTPUT || \
  aws s3 rm $OUTPUT