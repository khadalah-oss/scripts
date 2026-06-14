#!/bin/bash

# ==============================================================================
# SCRIPT : backup.sh
# DESCRIPTION : Sauvegarde automatisée de répertoires et rotation des archives.
# AUTEUR : Abdoul-Khadalah Jeeju
# ==============================================================================

# --- CONFIGURATION (Variables dynamiques) ---
TARGET_DIR="/var/www/html"                 # Le dossier à sauvegarder (ex: site web)
BACKUP_DIR="/backup/archives"              # Où stocker les fichiers de sauvegarde
LOG_FILE="/var/log/sysadmin_backup.log"    # Fichier de suivi des sauvegardes
RETENTION_DAYS=7                           # Nombre de jours de rétention des fichiers
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="backup_data_${DATE}.tar.gz"

# --- INITIALISATION ---
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"

exec > >(tee -a "$LOG_FILE") 2>&1 # Redirige la sortie standard et les erreurs vers le log

echo "[${DATE}] 🚀 Démarrage du script de sauvegarde..."

# --- VÉRIFICATIONS DE SÉCURITÉ ---
if [ ! -d "$TARGET_DIR" ]; then
    echo "[🚨 ERREUR] Le dossier cible $TARGET_DIR n'existe pas. Arrêt."
    exit 1
fi

# --- CRÉATION DE L'ARCHIVE ---
echo "[📦 INFO] Compression de $TARGET_DIR vers $BACKUP_DIR/$BACKUP_NAME..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname "$TARGET_DIR")" "$(basename "$TARGET_DIR")"

if [ $? -eq 0 ]; then
    echo "[✅ SUCCÈS] Sauvegarde créée avec succès : $BACKUP_NAME"
else
    echo "[🚨 ERREUR] Échec de la compression."
    exit 1
fi

# --- ROTATION / NETTOYAGE (Évite la saturation du disque) ---
echo "[🧹 INFO] Nettoyage des anciennes sauvegardes (plus de ${RETENTION_DAYS} jours)..."
find "$BACKUP_DIR" -type f -name "backup_data_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
echo "[✅ SUCCÈS] Nettoyage terminé."

echo "[🏁 FIN] Sauvegarde terminée à $(date +%H:%M:%S)."
echo "--------------------------------------------------"
