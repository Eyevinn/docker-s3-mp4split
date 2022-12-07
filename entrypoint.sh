#!/bin/bash

usage()
{
  echo "Usage: s3-mp4split [ -o OUTPUT ] input(s)"
  exit 2
}

args=()
s3_access_args=()

eval set -- "$@"
while [[ $# > 0 ]]; do
  case "$1" in
    -o)
      OUTPUT=$2
      shift
      ;;
    -*s3_access*)
      s3_access_args+=($1)
      ;;
    -*s3_secret*)
      s3_access_args+=($1)
      ;;
    *)
      args+=($1)
      ;;
  esac
  shift
done

if [ ${#s3_access_args[@]} == 0 ]; then
  if [ ! -z "$AWS_ACCESS_KEY_ID" ]; then
    s3_access_args+=(--s3_access_key=$AWS_ACCESS_KEY_ID --s3_secret_key=$AWS_SECRET_ACCESS_KEY)
  fi
fi

if [ -z "$OUTPUT" ]; then
  usage
fi

echo "Writing to $OUTPUT"
echo "mp4split args: ${args[*]}"

set -o pipefail; \
  UspLicenseKey=$USP_LICENSE_KEY mp4split -o stdout:.temp ${s3_access_args[*]} ${args[*]} | \
  aws s3 cp - $OUTPUT || \
  aws s3 rm $OUTPUT