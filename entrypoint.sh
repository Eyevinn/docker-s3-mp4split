#!/bin/bash

usage()
{
  echo "Usage: s3-mp4split [ -o OUTPUT ] input(s)"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n s3-mp4split -o o: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

# echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -o) OUTPUT="$2" ; shift 2 ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

echo "Writing to $OUTPUT"
echo "Processing files $@"

UspLicenseKey=$USP_LICENSE_KEY mp4split -o stdout:.temp $@ | aws s3 cp - $OUTPUT || aws s3 rm $OUTPUT