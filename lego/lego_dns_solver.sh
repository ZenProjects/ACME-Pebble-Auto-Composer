#!/bin/sh
set -x
echo "Script called with EXEC_MODE=$EXEC_MODE" >> /tmp/lego_debug.log
env >> /tmp/lego_debug.log
set -e

CHALLENGE_SERVER="challenge-server:8053"

# Variables correctes envoyées par lego
# EXEC_MODE = "present" ou "cleanup"
# LEGO_CERT_DOMAIN = le domaine complet
# LEGO_CERT_KEY_AUTH = la valeur du challenge

if [ "$EXEC_MODE" = "present" ]; then
    echo "Création de l'enregistrement TXT pour ${LEGO_CERT_DOMAIN}..."
    echo "Simulating successful creation for ${LEGO_CERT_DOMAIN} with value ${LEGO_CERT_KEY_AUTH}"
    # Ajoutez ici votre logique pour contacter le challenge-server si nécessaire
elif [ "$EXEC_MODE" = "cleanup" ]; then
    echo "Nettoyage de l'enregistrement TXT pour ${LEGO_CERT_DOMAIN}..."
    echo "Simulating successful cleanup for ${LEGO_CERT_DOMAIN}"
fi

exit 0
