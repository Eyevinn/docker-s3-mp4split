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
aws_security_token=""
credentials_uri=$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

if [ -z "$aws_access_key_id" ]; then
  echo "No AWS_ACCESS_KEY_ID provided, try to read from container credentials API"
  if [ -z "$DUMMY_CRED" ]; then
    creds=`curl --connect-timeout 1 169.254.170.2$credentials_uri`
  else
    echo "using dummy"
    read -r -d '' creds << EOF
{
  "AccessKeyId": "ACCESS_KEY_ID",
  "Expiration": "EXPIRATION_DATE",
  "RoleArn": "TASK_ROLE_ARN",
  "SecretAccessKey": "SECRET_ACCESS_KEY",
  "Token": "SECURITY_TOKEN_STRING"
}
EOF
  fi
  aws_access_key_id=`echo $creds | jq -r '.AccessKeyId'`
  aws_secret_access_key=`echo $creds | jq -r '.SecretAccessKey'`
  aws_security_token=`echo $creds | jq -r '.Token'`
fi

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
    -*s3_security_token*)
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
    if [ ! -z "$aws_security_token" ]; then
      s3_access_args+=(--s3_security_token=$aws_security_token)
    fi
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
if [ ! -z "$aws_secret_access_key" ]; then
  echo "mp4split default aws_secret_access_key: *****"
fi
if [ ! -z "$aws_security_token" ]; then
  echo "mp4split temporary security token: *****"
fi
echo "mp4split default aws_region: $aws_region"
echo "mp4split args: ${args[*]}"
echo "container credentials uri: $credentials_uri"

output_extension=".${OUTPUT##*.}"

UspLicenseKey=$USP_LICENSE_KEY mp4split -o stdout:${output_extension} ${s3_access_args[*]} ${s3_region_args[*]} ${args[*]} | \
  AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=$credentials_uri aws s3 cp - $OUTPUT 
if [[ $? > 0 ]]; then
  echo "mp4split failed, cleaning up"
  AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=$credentials_uri aws s3 rm $OUTPUT
  exit 1
fi
