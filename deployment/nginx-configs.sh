#!/bin/bash

# Script pour générer les configurations NGINX pour Vision Connect

# Répertoires pour les configurations
NGINX_DIR="/opt/vision-connect/nginx/conf.d"
mkdir -p $NGINX_DIR

# Configuration pour call.vision-connect.net
cat > $NGINX_DIR/call.vision-connect.net.conf << 'EOL'
server {
    listen 80;
    server_name call.vision-connect.net;

    # Redirection vers HTTPS
    location / {
        return 301 https://<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>h</mi><mi>o</mi><mi>s</mi><mi>t</mi></mrow><annotation encoding="application/x-tex">host</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">h</span><span class="mord mathnormal">os</span><span class="mord mathnormal">t</span></span></span></span>request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name call.vision-connect.net;

    ssl_certificate /etc/letsencrypt/live/call.vision-connect.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/call.vision-connect.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/call.vision-connect.net/chain.pem;

    # Configuration SSL optimisée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=63072000" always;

    # Headers de sécurité
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";

    # Proxy vers le frontend
    location / {
        proxy_pass http://frontend:80;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Configuration pour WebRTC (WebSocket)
    location /socket.io/ {
        proxy_pass http://api:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOL

# Configuration pour api.vision-connect.net
cat > $NGINX_DIR/api.vision-connect.net.conf << 'EOL'
server {
    listen 80;
    server_name api.vision-connect.net;

    # Redirection vers HTTPS
    location / {
        return 301 https://<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>h</mi><mi>o</mi><mi>s</mi><mi>t</mi></mrow><annotation encoding="application/x-tex">host</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">h</span><span class="mord mathnormal">os</span><span class="mord mathnormal">t</span></span></span></span>request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name api.vision-connect.net;

    ssl_certificate /etc/letsencrypt/live/api.vision-connect.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.vision-connect.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/api.vision-connect.net/chain.pem;

    # Configuration SSL optimisée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=63072000" always;

    # Headers de sécurité
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";

    # CORS headers pour l'API
    add_header 'Access-Control-Allow-Origin' 'https://call.vision-connect.net' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept, Authorization' always;
    add_header 'Access-Control-Allow-Credentials' 'true' always;

    # Preflight requests
    if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' 'https://call.vision-connect.net' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept, Authorization' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
    }

    # Proxy vers l'API
    location / {
        proxy_pass http://api:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOL

# Configuration pour admin.vision-connect.net
cat > $NGINX_DIR/admin.vision-connect.net.conf << 'EOL'
server {
    listen 80;
    server_name admin.vision-connect.net;

    # Redirection vers HTTPS
    location / {
        return 301 https://<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>h</mi><mi>o</mi><mi>s</mi><mi>t</mi></mrow><annotation encoding="application/x-tex">host</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">h</span><span class="mord mathnormal">os</span><span class="mord mathnormal">t</span></span></span></span>request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name admin.vision-connect.net;

    ssl_certificate /etc/letsencrypt/live/admin.vision-connect.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.vision-connect.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/admin.vision-connect.net/chain.pem;

    # Configuration SSL optimisée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=63072000" always;

    # Headers de sécurité
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";

    # Limiter l'accès à l'interface administrative (optionnel)
    # allow 123.123.123.123; # Ajoutez votre IP pour restreindre l'accès
    # deny all;

    # Proxy vers l'interface d'administration
    location / {
        proxy_pass http://admin:80;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOL

# Configuration pour turn.vision-connect.net
cat > $NGINX_DIR/turn.vision-connect.net.conf << 'EOL'
server {
    listen 80;
    server_name turn.vision-connect.net;

    # Redirection vers HTTPS
    location / {
        return 301 https://<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>h</mi><mi>o</mi><mi>s</mi><mi>t</mi></mrow><annotation encoding="application/x-tex">host</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">h</span><span class="mord mathnormal">os</span><span class="mord mathnormal">t</span></span></span></span>request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name turn.vision-connect.net;

    ssl_certificate /etc/letsencrypt/live/turn.vision-connect.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/turn.vision-connect.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/turn.vision-connect.net/chain.pem;

    # Configuration SSL optimisée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=63072000" always;

    # Page d'état simple
    location / {
        add_header Content-Type text/plain;
        return 200 "TURN Server running";
    }
}
EOL

echo "Configurations NGINX générées avec succès dans $NGINX_DIR"
