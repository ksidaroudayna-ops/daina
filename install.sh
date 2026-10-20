#!/usr/bin/env bash
# Installation complete sur Ubuntu : outils + base de donnees + frontend Angular
# Usage:  bash install.sh
set -euo pipefail
cd "$(dirname "$0")"

echo "==> 1/4 Installation des paquets (Java, Maven, MariaDB, Node.js)"
sudo apt update
sudo apt install -y openjdk-17-jdk maven mariadb-server git curl unzip

NODE_MAJOR=0
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR=$(node -v | sed 's/v\([0-9]*\).*/\1/')
fi
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "    Node.js < 22 : installation de Node.js 22"
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
fi

echo "==> 2/4 Base de donnees MariaDB"
sudo service mariadb start
sudo mysql < database/init.sql
echo "    Base 'tasksdb' + utilisateur 'taskuser' prets."

echo "==> 3/4 Creation du projet Angular"
if [ ! -d frontend ]; then
  npx -y @angular/cli@20 new frontend --defaults --skip-git
fi
# on remplace les fichiers generes par les notres
rm -f frontend/src/app/app.* frontend/src/app/app.config.* frontend/src/app/app.routes.* 2>/dev/null || true
cp -r frontend-overlay/src/. frontend/src/

echo "==> 4/4 Compilation du backend (telecharge les dependances Maven)"
(cd backend && mvn -q -DskipTests package)

echo
echo "Installation terminee. Lance maintenant :  bash run.sh"
