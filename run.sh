#!/usr/bin/env bash
# Lance MariaDB, le backend (port 8080) et le frontend (port 4200)
# Usage:  bash run.sh      (Ctrl+C pour tout arreter)
set -e
cd "$(dirname "$0")"

sudo service mariadb start

trap 'kill 0' INT TERM

echo "==> Backend Spring Boot sur http://localhost:8080"
(cd backend && mvn -q spring-boot:run) &

echo "==> Frontend Angular sur http://localhost:4200"
cd frontend
npx ng serve --proxy-config proxy.conf.json
