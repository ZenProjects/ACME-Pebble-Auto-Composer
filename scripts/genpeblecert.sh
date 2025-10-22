#!/bin/bash
set -e 
set -x

CERT_CN="Pebble ACME Server"
DOMAIN=$(hostname)
CERTS_DIR="datas/pebble-certs"
mkdir -p $CERTS_DIR/acme

echo "Génération des certificats de serveur ACME pour ${DOMAIN}..."

# 1. Génération du CA Root
openssl genrsa -out ${CERTS_DIR}/acme/root.key 4096
openssl req -x509 -new -nodes -key ${CERTS_DIR}/acme/root.key -sha256 -days 1024 \
  -out ${CERTS_DIR}/acme/pebble.minica.pem -subj '/CN=Pebble Root CA Generated'

# 2. Génération de la Clé Privée et CSR
openssl genrsa -out ${CERTS_DIR}/acme/key.pem 2048

# Fichier de configuration OpenSSL pour les extensions SAN (réutilisé pour le CSR et la signature)
OPENSSL_CONF=$(cat <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
# Vide pour utiliser le -subj

[v3_req]
subjectAltName = DNS:pebble, DNS:localhost, DNS:${DOMAIN}

[v3_ext]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature, keyEncipherment
subjectAltName = DNS:pebble, DNS:localhost, DNS:${DOMAIN}
EOF
)

# 3. Création de la Demande de Certificat (CSR) avec les SANs
echo "$OPENSSL_CONF" | openssl req -new -key ${CERTS_DIR}/acme/key.pem -out ${CERTS_DIR}/acme/cert.csr \
  -subj "/CN=${CERT_CN}" -config /dev/stdin

# 4. Signature du certificat par le Root CA (incluant les SANs)
echo "$OPENSSL_CONF" | openssl x509 -req -in ${CERTS_DIR}/acme/cert.csr -CA ${CERTS_DIR}/acme/pebble.minica.pem \
  -CAkey ${CERTS_DIR}/acme/root.key -CAcreateserial -out ${CERTS_DIR}/acme/cert.pem -days 500 -sha256 \
  -extfile /dev/stdin -extensions v3_ext

echo "Certificats ACME générés avec succès dans le répertoire ${CERTS_DIR}."

# Optionnel : Vérification du SAN (Vous pouvez exécuter cette commande après)
openssl x509 -in ${CERTS_DIR}/acme/cert.pem -text -noout | grep -A1 "Subject Alternative Name"
