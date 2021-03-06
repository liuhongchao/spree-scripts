#!/bin/bash

usage(){
cat <<EOF
usage: $0 options

OPTIONS:
    -h       Hostname
    -p       Port
    -u       Url
    -k       Key

URL and Key are mandatory, specify them either using -u and -k options or through SPREE_URL and SPREE_KEY environment variables.

example:
curl-spree.sh -k $YOUR_SPREE_KEY -u api/products/1

EOF
}

while getopts "h:p:u:k:" OPTION
do
    case $OPTION in
        u)
            SPREE_URL="$OPTARG"
            echo u "$OPTARG"
            ;;
        k)
            SPREE_KEY="$OPTARG"
            echo k "$OPTARG"
            ;;
        h)
            SPREE_HOSTNAME="$OPTARG"
            echo h "$OPTARG"
            ;;
        p)
            SPREE_PORT="$OPTARG"
            echo p "$OPTARG"
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done


if [ -z "$SPREE_HOSTNAME" ]; then
    SPREE_HOSTNAME="localhost"
fi

if [ -z "$SPREE_PORT" ]; then
    SPREE_PORT="3000"
fi

if [ -z "$SPREE_KEY" ]; then
    echo "user key is not set"
    usage
    exit 1
fi

if [ -z "$SPREE_URL" ]; then
    echo "URL is not set"
    usage
    exit 1
fi

curl --header "X-Spree-Token: $SPREE_KEY" $SPREE_HOSTNAME:$SPREE_PORT/$SPREE_URL | python -mjson.tool
