# ************* Mise à jour de l’application ********************************************************************************************
# Arrêter les conteneurs
cd deployment
docker-compose down

# Mettre à jour le code source
cd ..
git pull

# Reconstruire et redémarrer les conteneurs
cd deployment
docker-compose build
docker-compose up -d

# *************  Sauvegarder les données ********************************************************************************************
# Sauvegarder MongoDB
docker exec vision-connect-mongodb sh -c 'mongodump --archive' > mongodb-backup.archive

# Restaurer MongoDB
docker exec -i vision-connect-mongodb sh -c 'mongorestore --archive' < mongodb-backup.archive

# *************  Dépannage  ==>> Vérifier les logs ********************************************************************************************
# Logs du conteneur API
docker logs vision-connect-api

# Logs du conteneur frontend
docker logs vision-connect-frontend

# Logs du conteneur NGINX
docker logs vision-connect-nginx

# *************  Redémarrer un service *****************************************************************************************************
# Redémarrer le service API
docker restart vision-connect

