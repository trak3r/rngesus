#!/bin/bash
set -e

CERTS_DIR=".kamal/certs"
KEY_FILE="$CERTS_DIR/localhost.key"
CERT_FILE="$CERTS_DIR/localhost.crt"

mkdir -p "$CERTS_DIR"

if [ -f "$KEY_FILE" ] && [ -f "$CERT_FILE" ]; then
  echo "Certificates already exist in $CERTS_DIR"
  exit 0
fi

echo "Generating self-signed SSL certificates for localhost..."

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

echo "Certificates generated successfully:"
echo "  Key: $KEY_FILE"
echo "  Cert: $CERT_FILE"
