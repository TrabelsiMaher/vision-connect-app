#!/bin/bash

# Script d'installation pour Vision Connect
# À exécuter sur un serveur Ubuntu 20.04+ avec accès root/sudo

echo "=== Installation de Vision Connect ==="
echo "=== Configuration du serveur pour les domaines : ==="
echo "call.vision-connect.net"
echo "api.vision-connect.net"
echo "admin.vision-connect.net"
echo "turn.vision-connect.net"

# Mise à jour du système
echo "[1/7] Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installation des outils essentiels
echo "[2/7] Installation des outils essentiels..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    ufw \
    certbot \
    python3-certbot-nginx

# Installation de Docker
echo "[3/7] Installation de Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo stretchy="false">(</mo><mi>d</mi><mi>p</mi><mi>k</mi><mi>g</mi><mo>−</mo><mo>−</mo><mi>p</mi><mi>r</mi><mi>i</mi><mi>n</mi><mi>t</mi><mo>−</mo><mi>a</mi><mi>r</mi><mi>c</mi><mi>h</mi><mi>i</mi><mi>t</mi><mi>e</mi><mi>c</mi><mi>t</mi><mi>u</mi><mi>r</mi><mi>e</mi><mo stretchy="false">)</mo><mi>s</mi><mi>i</mi><mi>g</mi><mi>n</mi><mi>e</mi><mi>d</mi><mo>−</mo><mi>b</mi><mi>y</mi><mo>=</mo><mi mathvariant="normal">/</mi><mi>u</mi><mi>s</mi><mi>r</mi><mi mathvariant="normal">/</mi><mi>s</mi><mi>h</mi><mi>a</mi><mi>r</mi><mi>e</mi><mi mathvariant="normal">/</mi><mi>k</mi><mi>e</mi><mi>y</mi><mi>r</mi><mi>i</mi><mi>n</mi><mi>g</mi><mi>s</mi><mi mathvariant="normal">/</mi><mi>d</mi><mi>o</mi><mi>c</mi><mi>k</mi><mi>e</mi><mi>r</mi><mo>−</mo><mi>a</mi><mi>r</mi><mi>c</mi><mi>h</mi><mi>i</mi><mi>v</mi><mi>e</mi><mo>−</mo><mi>k</mi><mi>e</mi><mi>y</mi><mi>r</mi><mi>i</mi><mi>n</mi><mi>g</mi><mi mathvariant="normal">.</mi><mi>g</mi><mi>p</mi><mi>g</mi><mo stretchy="false">]</mo><mi>h</mi><mi>t</mi><mi>t</mi><mi>p</mi><mi>s</mi><mo>:</mo><mi mathvariant="normal">/</mi><mi mathvariant="normal">/</mi><mi>d</mi><mi>o</mi><mi>w</mi><mi>n</mi><mi>l</mi><mi>o</mi><mi>a</mi><mi>d</mi><mi mathvariant="normal">.</mi><mi>d</mi><mi>o</mi><mi>c</mi><mi>k</mi><mi>e</mi><mi>r</mi><mi mathvariant="normal">.</mi><mi>c</mi><mi>o</mi><mi>m</mi><mi mathvariant="normal">/</mi><mi>l</mi><mi>i</mi><mi>n</mi><mi>u</mi><mi>x</mi><mi mathvariant="normal">/</mi><mi>u</mi><mi>b</mi><mi>u</mi><mi>n</mi><mi>t</mi><mi>u</mi></mrow><annotation encoding="application/x-tex">(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu </annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal">d</span><span class="mord mathnormal">p</span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.854em;vertical-align:-0.1944em;"></span><span class="mord">−</span><span class="mord mathnormal">p</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">in</span><span class="mord mathnormal">t</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">a</span><span class="mord mathnormal">rc</span><span class="mord mathnormal">hi</span><span class="mord mathnormal">t</span><span class="mord mathnormal">ec</span><span class="mord mathnormal">t</span><span class="mord mathnormal">u</span><span class="mord mathnormal">re</span><span class="mclose">)</span><span class="mord mathnormal">s</span><span class="mord mathnormal">i</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal">n</span><span class="mord mathnormal">e</span><span class="mord mathnormal">d</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">b</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">/</span><span class="mord mathnormal">u</span><span class="mord mathnormal" style="margin-right:0.02778em;">sr</span><span class="mord">/</span><span class="mord mathnormal">s</span><span class="mord mathnormal">ha</span><span class="mord mathnormal">re</span><span class="mord">/</span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.02778em;">eyr</span><span class="mord mathnormal">in</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal">s</span><span class="mord">/</span><span class="mord mathnormal">d</span><span class="mord mathnormal">oc</span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">a</span><span class="mord mathnormal">rc</span><span class="mord mathnormal">hi</span><span class="mord mathnormal" style="margin-right:0.03588em;">v</span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.02778em;">eyr</span><span class="mord mathnormal">in</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord">.</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal">p</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mclose">]</span><span class="mord mathnormal">h</span><span class="mord mathnormal">ttp</span><span class="mord mathnormal">s</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">//</span><span class="mord mathnormal">d</span><span class="mord mathnormal">o</span><span class="mord mathnormal" style="margin-right:0.02691em;">w</span><span class="mord mathnormal">n</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">o</span><span class="mord mathnormal">a</span><span class="mord mathnormal">d</span><span class="mord">.</span><span class="mord mathnormal">d</span><span class="mord mathnormal">oc</span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mord">.</span><span class="mord mathnormal">co</span><span class="mord mathnormal">m</span><span class="mord">/</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">in</span><span class="mord mathnormal">ux</span><span class="mord">/</span><span class="mord mathnormal">u</span><span class="mord mathnormal">b</span><span class="mord mathnormal">u</span><span class="mord mathnormal">n</span><span class="mord mathnormal">t</span><span class="mord mathnormal">u</span></span></span></span>(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Installation de Docker Compose
echo "[4/7] Installation de Docker Compose..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mrow><mi>C</mi><mi>O</mi><mi>M</mi><mi>P</mi><mi>O</mi><mi>S</mi><msub><mi>E</mi><mi>V</mi></msub><mi>E</mi><mi>R</mi><mi>S</mi><mi>I</mi><mi>O</mi><mi>N</mi></mrow><mi mathvariant="normal">/</mi><mi>d</mi><mi>o</mi><mi>c</mi><mi>k</mi><mi>e</mi><mi>r</mi><mo>−</mo><mi>c</mi><mi>o</mi><mi>m</mi><mi>p</mi><mi>o</mi><mi>s</mi><mi>e</mi><mo>−</mo></mrow><annotation encoding="application/x-tex">{COMPOSE_VERSION}/docker-compose-</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05764em;">COMPOS</span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3283em;"><span style="top:-2.55em;margin-left:-0.0576em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.22222em;">V</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mord mathnormal" style="margin-right:0.05764em;">ERS</span><span class="mord mathnormal" style="margin-right:0.07847em;">I</span><span class="mord mathnormal" style="margin-right:0.10903em;">ON</span></span><span class="mord">/</span><span class="mord mathnormal">d</span><span class="mord mathnormal">oc</span><span class="mord mathnormal" style="margin-right:0.03148em;">k</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">−</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">co</span><span class="mord mathnormal">m</span><span class="mord mathnormal">p</span><span class="mord mathnormal">ose</span><span class="mord">−</span></span></span></span>(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ajout de l'utilisateur courant au groupe docker
echo "[5/7] Configuration des permissions Docker..."
sudo usermod -aG docker $USER

# Configuration du pare-feu
echo "[6/7] Configuration du pare-feu..."
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 3478/tcp  # TURN
sudo ufw allow 3478/udp  # TURN
sudo ufw allow 49152:65535/udp  # Plage de ports média RTP
sudo ufw --force enable

# Création des répertoires pour les volumes Docker
echo "[7/7] Création des répertoires pour les données persistantes..."
sudo mkdir -p /opt/vision-connect/{mongodb,redis,nginx,turn,ssl}
sudo chown -R USER:USER /opt/vision-connect

echo "Installation des dépendances terminée !"
echo "Votre système est prêt pour le déploiement de Vision Connect."
echo "Veuillez vous déconnecter et vous reconnecter pour appliquer les changements de groupe Docker."
echo "Ensuite, vous pourrez déployer l'application avec Docker Compose."
