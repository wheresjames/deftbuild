#!/bin/bash

# makes a self signed certificate

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $1.pem -out $1.pem

openssl pkcs12 -export -out $1.pfx -in $1.pem -name “$1”

openssl pkcs12 -in $1.pfx -out $1.pem

openssl pkcs12 -export -in $1.pem -out $1.ks -name "$1"
