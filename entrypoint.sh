#!/bin/bash

set -o pipefail

usage()
{
  echo "Usage: s3-mp4split [ -o OUTPUT ] input(s)"
  exit 2
}

args=()
s3_access_args=()
s3_region_args=()
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
aws_region=$AWS_REGION
credentials_uri=$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

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
    -*s3_region*)
      s3_region_args+=($1)
      ;;
    *)
      args+=($1)
      ;;
  esac
  shift
done

if [ ${#s3_access_args[@]} == 0 ]; then
  if [ ! -z "$aws_access_key_id" ]; then
    s3_access_args+=(--s3_access_key=$aws_access_key_id --s3_secret_key=$aws_secret_access_key)
  fi
fi

if [ ${#s3_region_args[@]} == 0 ]; then
  if [ ! -z "$aws_region" ]; then
    s3_region_args+=(--s3_region=$aws_region)
  fi
fi

if [ -z "$OUTPUT" ]; then
  usage
fi

echo "Writing to $OUTPUT"
echo "mp4split default aws_access_key_id: $aws_access_key_id"
echo "mp4split default aws_secret_access_key: *****"
echo "mp4split default aws_region: $aws_region"
echo "mp4split args: ${args[*]}"
echo "container credentials uri: $credentials_uri"

UspLicenseKey=$USP_LICENSE_KEY mp4split -o stdout:.temp ${s3_access_args[*]} ${s3_region_args[*]} ${args[*]} | \
  AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=$credentials_uri aws s3 cp - $OUTPUT 
if [[ $? > 0 ]]; then
  echo "mp4split failed, cleaning up"
  AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=$credentials_uri aws s3 rm $OUTPUT
  exit 1
fi