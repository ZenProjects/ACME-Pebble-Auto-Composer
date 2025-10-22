#!/bin/sh
set -e

# Chemin où Lego s'attend à trouver le certificat CA
CA_PATH="/ca-certs/pebble.minica.pem"
PEBBLE_URL="https://pebble:15000/roots/0"

mkdir -p /ca-certs

# --- [ Section de Wait et Téléchargement du CA ] ---
#echo "Attente que le serveur Pebble ACME soit disponible..."
#until curl --insecure -sf "$PEBBLE_URL"; do
    #>&2 echo "Pebble n'est pas encore prêt - attendons 2 secondes"
    #sleep 2
#done

#echo "Pebble est prêt. Téléchargement du certificat CA..."
#curl --insecure -sf "$PEBBLE_URL" -o "$CA_PATH"
#echo "Certificat CA de Pebble téléchargé avec succès dans $CA_PATH."

# --- [ Section de Persistance ou d'Exécution ] ---

# Si aucun argument n'a été passé à l'exécution du conteneur (cas du 'docker compose up -d')
if [ "$#" -eq 0 ]; then
    echo "Aucune commande spécifiée. Le conteneur restera en veille."
    # Reste en vie indéfiniment pour permettre l'exécution via 'docker exec'
    exec sleep 36000 
fi

# Exécuter la commande passée en argument (cas du 'docker exec lego lego ...')
exec "$@"
