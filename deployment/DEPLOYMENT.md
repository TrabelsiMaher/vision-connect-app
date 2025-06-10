# Déploiement de Vision Connect

Ce guide explique comment déployer l'application Vision Connect sur votre serveur Ubuntu.

## Prérequis

- Un serveur Ubuntu 20.04 ou plus récent
- Un accès root ou sudo
- Les domaines suivants pointant vers l'IP de votre serveur :
  - call.vision-connect.net
  - api.vision-connect.net
  - admin.vision-connect.net
  - turn.vision-connect.net

## Installation

1. **Préparation du serveur**

```bash
# Cloner le dépôt
git clone https://github.com/TrabelsiMaher/vision-connect-app.git
cd vision-connect-app

# Rendre les scripts exécutables
chmod +x deployment/*.sh

# Exécuter le script d'installation
sudo ./deployment/setup-server.sh

# Se déconnecter et se reconnecter pour appliquer les changements de groupe Docker
exit
# Reconnectez-vous...

# Revenir au répertoire du projet
cd vision-connect-app
