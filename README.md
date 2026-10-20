# Task Manager — Spring Boot + MariaDB + Angular (Ubuntu)

Projet simple : liste de tâches (ajouter, cocher, supprimer).

```
task-manager/
├── backend/            Spring Boot (port 8080)
├── database/init.sql   Création base + user + table MariaDB
├── frontend-overlay/   Fichiers Angular (copiés dans frontend/ par install.sh)
├── install.sh          Installation complète sur Ubuntu
└── run.sh              Lancement de tout
```

## Démarrage rapide (Ubuntu)

```bash
cd task-manager
bash install.sh     # une seule fois (demande le mot de passe sudo)
bash run.sh         # lance backend + frontend
```

Puis ouvre http://localhost:4200

Identifiants de la base : base `tasksdb`, user `taskuser`, mot de passe `taskpass`
(modifiables dans `database/init.sql` et `backend/src/main/resources/application.properties`).

## Si `bash install.sh` donne une erreur `\r`

Les fichiers ont des fins de ligne Windows. Corrige avec :

```bash
sed -i 's/\r$//' *.sh database/init.sql
```

## Vérifier la base de données

```bash
mysql -u taskuser -ptaskpass tasksdb -e "SELECT * FROM task;"
```

## Tester le backend seul

```bash
curl http://localhost:8080/api/tasks
curl -X POST -H "Content-Type: application/json" -d '{"title":"Test","done":false}' http://localhost:8080/api/tasks
```

## Problèmes fréquents

| Problème | Solution |
|---|---|
| `Access denied for user 'taskuser'` | Relance `sudo mysql < database/init.sql` |
| `Communications link failure` | `sudo systemctl start mariadb` |
| Page Angular affiche "Impossible de joindre le backend" | Le backend n'est pas lancé (port 8080) |
| Port 8080 ou 4200 déjà utilisé | `sudo lsof -i :8080` puis `kill <PID>` |
# daina
