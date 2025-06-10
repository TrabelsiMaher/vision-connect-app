#!/bin/bash

# Script pour démarrer l'application Vision Connect

# Répertoire du projet
PROJECT_DIR=$(pwd)/..

# Charger les variables d'environnement si le fichier existe
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Générer un fichier .env si ce n'est pas déjà fait
if [ ! -f .env ]; then
  echo "Génération du fichier .env avec des valeurs par défaut..."
  cat > .env << EOF
MONGO_USERNAME=vision
MONGO_PASSWORD=$(openssl rand -base64 12)
TURN_USERNAME=vision
TURN_PASSWORD=$(openssl rand -base64 12)
JWT_SECRET=$(openssl rand -base64 32)
EOF
  echo "Fichier .env créé avec des mots de passe aléatoires."
  echo "Veuillez consulter ce fichier pour les informations d'authentification."
fi

# Générer les configurations NGINX si ce n'est pas déjà fait
if [ ! -f /opt/vision-connect/nginx/conf.d/call.vision-connect.net.conf ]; then
  echo "Génération des configurations NGINX..."
  bash ./nginx-configs.sh
fi

# Démarrer l'application avec Docker Compose
echo "Démarrage de l'application Vision Connect..."
docker-compose -f docker-compose.yml up -d

echo "Application Vision Connect démarrée avec succès!"
echo "Vous pouvez accéder à l'application via https://call.vision-connect.net"
