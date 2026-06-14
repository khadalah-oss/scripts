# scripts


## 🛠️ Outil de Sauvegarde Automatisée (Bash)

Ce script permet d'automatiser la sauvegarde compressée d'un répertoire système (comme un site web ou une base de données) et gère la rétention des fichiers pour économiser l'espace disque.

### Fonctionnalités :
- Compression native au format `.tar.gz`.
- Journalisation complète des opérations dans un fichier de log.
- Suppression automatique des sauvegardes datant de plus de 7 jours.

### Utilisation :
1. Rendre le script exécutable : `chmod +x backup.sh`
2. Automatisation via Cron (Chaque jour à minuit) :
   `0 0 * * * /chemin/vers/backup.sh`
