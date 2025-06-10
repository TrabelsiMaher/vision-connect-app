echo "# Vision Connect App

Plateforme de visioconférence WebRTC avec fonctionnalités avancées pour réunions et classes virtuelles

## Structure du projet

- \`frontend/\`: Application React
- \`backend/\`: Serveur Node.js et API
- \`turn-server/\`: Configuration du serveur TURN
- \`deployment/\`: Scripts et configurations de déploiement
" > README.md


## Fonctionnalités

- **Visioconférence** : Appels vidéo haute qualité jusqu'à 50 participants
- **Mode Classroom** : Fonctionnalités spécifiques pour l'enseignement à distance
- **Partage d'écran** : Partagez votre écran avec contrôle granulaire
- **Chat intégré** : Communication textuelle pendant les réunions
- **Enregistrement** : Enregistrement local ou cloud des sessions
- **Administration** : Interface de gestion complète pour les administrateurs

## Infrastructure Docker

L'application utilise Docker pour assurer une installation cohérente et des déploiements simplifiés :

- **MongoDB** : Stockage des données utilisateurs et informations de réunion
- **Redis** : Gestion des sessions et mise en cache
- **Nginx** : Reverse proxy et serveur web pour le frontend
- **Node.js** : API backend et signalisation WebRTC
- **COTURN** : Serveur STUN/TURN pour la traversée NAT

## Domaines configurés

- `call.vision-connect.net` - Interface principale de l'application
- `api.vision-connect.net` - API backend
- `admin.vision-connect.net` - Interface d'administration
- `turn.vision-connect.net` - Serveur TURN/STUN

## Installation et déploiement

Voir les instructions détaillées dans le dossier `/deployment`.

## Développement

### Prérequis
- Docker et Docker Compose
- Node.js 18+
- Git

### Installation locale
```bash
# Cloner le dépôt
git clone [URL_DU_REPO]

# Démarrer l'environnement de développement
cd vision-connect-app
docker-compose -f deployment/docker-compose.dev.yml up

