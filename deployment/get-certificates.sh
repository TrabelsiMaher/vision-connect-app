#!/bin/bash

# Script pour obtenir des certificats SSL avec Let's Encrypt pour Vision Connect

# Arrêter le script si une commande échoue
set -e

# Vérifier que nous avons les bonnes autorisations
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté avec les droits administrateur (sudo)"
  exit 1
fi

# Domaines à sécuriser
DOMAINS=(
  "call.vision-connect.net"
  "api.vision-connect.net"
  "admin.vision-connect.net"
  "turn.vision-connect.net"
)

# Arrêter NGINX s'il est en cours d'exécution pour libérer le port 80
echo "Vérification si NGINX est en cours d'exécution..."
if systemctl is-active --quiet nginx; then
  echo "Arrêt temporaire de NGINX..."
  systemctl stop nginx
fi
if docker ps | grep -q nginx; then
  echo "Arrêt temporaire du conteneur NGINX..."
  docker stop $(docker ps -q --filter name=nginx)
fi

# Obtention des certificats
for domain in "${DOMAINS[@]}"; do
  echo "Obtention du certificat pour $domain..."
  certbot certonly --standalone \
    --preferred-challenges http \
    --agree-tos \
    --email admin@vision-connect.net \
    -d "$domain"
done

# Redémarrer NGINX s'il était en cours d'exécution
if systemctl is-enabled --quiet nginx; then
  echo "Redémarrage de NGINX..."
  systemctl start nginx
fi

echo "Certificats SSL obtenus avec succès pour tous les domaines!"
echo "Vous pouvez maintenant démarrer les conteneurs Docker."
