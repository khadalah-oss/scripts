# 🚀 Configuration Nginx Reverse Proxy Professionnelle avec Docker Compose

Cette configuration complète permet de déployer plusieurs applications (Node.js, Python, PHP) avec Nginx en tant que reverse proxy, incluant SSL/TLS automatique via Let's Encrypt.

## 📋 Contenu de la configuration

```
nginx-reverse-proxy/
├── docker-compose.yml           # Orchestration des conteneurs
├── nginx/
│   ├── nginx.conf              # Configuration principale Nginx
│   ├── conf.d/
│   │   ├── app-node.conf       # Configuration du reverse proxy pour Node.js
│   │   ├── app-python.conf     # Configuration du reverse proxy pour Python
│   │   └── app-php.conf        # Configuration du reverse proxy pour PHP
│   └── ssl/                    # Certificats SSL (généré automatiquement)
├── apps/
│   ├── node-app/               # Application Node.js exemple
│   └── python-app/             # Application Python exemple
└── .env.example                # Variables d'environnement
```

## 🎯 Fonctionnalités principales

### 🔒 Sécurité
- **SSL/TLS automatique** avec Let's Encrypt via Certbot
- **HTTP/2** pour une meilleure performance
- **Headers de sécurité** : HSTS, CSP, X-Frame-Options, X-Content-Type-Options
- **Rate limiting** pour prévenir les abus
- **Redirection HTTP → HTTPS** automatique

### ⚡ Performance
- **Compression GZIP** pour les réponses
- **Caching** intelligent des ressources statiques
- **Load balancing** avec `least_conn`
- **Connection pooling** vers les applications
- **Worker processes** auto-optimisés

### 🛡️ Fiabilité
- **Health checks** automatiques
- **Redémarrage automatique** des conteneurs
- **Logs détaillés** pour le debugging
- **Upstream failover** en cas de problème

## 📦 Services inclus

| Service | Port | Description |
|---------|------|-------------|
| **app-node** | 3000 | Application Node.js (API) |
| **app-python** | 5000 | Application Python/Flask |
| **app-php** | 9000 (FPM) | Application PHP-FPM |
| **nginx** | 80, 443 | Reverse proxy |
| **certbot** | - | Gestionnaire des certificats SSL |

## 🚀 Démarrage rapide

### 1️⃣ Prérequis
```bash
# Docker et Docker Compose
docker --version
docker-compose --version

# Domaines DNS pointant vers votre serveur
# - api.example.com
# - app.example.com
# - web.example.com
```

### 2️⃣ Configuration initiale
```bash
# Cloner le repository
git clone https://github.com/khadalah-oss/scripts.git
cd scripts/nginx-reverse-proxy

# Copier le fichier d'environnement
cp .env.example .env

# Éditer .env avec vos domaines réels
nano .env
```

### 3️⃣ Démarrer les conteneurs
```bash
# Utiliser le Makefile
make up

# Ou directement avec docker-compose
docker-compose up -d
```

### 4️⃣ Initialiser les certificats SSL
```bash
make ssl-init

# Ou manuellement
mkdir -p ./nginx/ssl/letsencrypt/live
```

## 📝 Commandes utiles

```bash
# Voir le statut des services
make status
docker-compose ps

# Consulter les logs
make logs
make logs-nginx
docker-compose logs -f nginx

# Redémarrer les services
make restart
docker-compose restart nginx

# Arrêter tous les services
make down
docker-compose down

# Nettoyer complètement
make clean
docker-compose down -v
```

## 🔧 Personnalisation

### Ajouter un nouvel upstream (application)

1. **Modifier `docker-compose.yml`** :
```yaml
services:
  app-ruby:
    container_name: app-ruby
    image: ruby:3.2
    ports:
      - "4000:4000"
    networks:
      - proxy-network
```

2. **Ajouter l'upstream dans `nginx/nginx.conf`** :
```nginx
upstream app_ruby {
    least_conn;
    server app-ruby:4000 max_fails=3 fail_timeout=30s;
    keepalive 32;
}
```

3. **Créer la configuration Nginx** `nginx/conf.d/app-ruby.conf` :
```nginx
server {
    listen 443 ssl http2;
    server_name ruby.example.com;
    
    # ... configuration SSL et headers ...
    
    location / {
        proxy_pass http://app_ruby;
        # ... proxy headers ...
    }
}
```

### Configurer les domaines personnalisés

Modifiez les blocs `server_name` dans les fichiers `nginx/conf.d/*.conf` :

```nginx
server {
    listen 443 ssl http2;
    server_name votre-domaine.com www.votre-domaine.com;
    # ...
}
```

### Ajuster les limites de taux (Rate Limiting)

Dans `nginx/nginx.conf` :
```nginx
limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;  # 10 requêtes/sec
limit_req_zone $binary_remote_addr zone=api:10m rate=30r/s;      # 30 requêtes/sec
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;     # 5 requêtes/min
```

## 📊 Monitoring et Logs

### Voir les logs Nginx
```bash
# Logs d'accès
docker-compose exec nginx tail -f /var/log/nginx/access.log

# Logs d'erreur
docker-compose exec nginx tail -f /var/log/nginx/error.log

# Logs détaillés d'une application
docker-compose exec nginx tail -f /var/log/nginx/api_access.log
```

### Tester la configuration
```bash
# Valider la syntaxe Nginx
docker-compose exec nginx nginx -t

# Recharger la configuration sans redémarrer
docker-compose exec nginx nginx -s reload

# Vérifier les certificats SSL
docker-compose exec certbot ls /etc/letsencrypt/live/
```

## 🔐 Certificats SSL/TLS

### Renouvellement automatique
Le service `certbot` se charge du renouvellement automatique tous les 12h.

### Renouveler manuellement
```bash
docker-compose exec certbot certbot renew --dry-run
```

### Vérifier l'état des certificats
```bash
docker-compose exec certbot certbot certificates
```

## 🧪 Test des applications

```bash
# Node.js API
curl -k https://api.example.com/
curl -k https://api.example.com/health

# Python/Flask
curl -k https://app.example.com/
curl -k https://app.example.com/api/data

# PHP
curl -k https://web.example.com/
```

## 🐛 Dépannage

### Problème : Erreur de connexion au upstream
```bash
# Vérifier l'état des conteneurs
make status

# Vérifier les logs Nginx
make logs-nginx

# Vérifier la connectivité entre conteneurs
docker-compose exec nginx ping app-node
```

### Problème : Certificat SSL non généré
```bash
# Vérifier les logs de Certbot
docker-compose logs certbot

# S'assurer que le DNS pointe correctement
nslookup api.example.com

# Vérifier les permissions
ls -la nginx/ssl/letsencrypt/
```

### Problème : Rate limiting trop strict
```nginx
# Augmenter les limites dans nginx/nginx.conf
limit_req_zone $binary_remote_addr zone=general:10m rate=20r/s;  # de 10 à 20
```

## 📚 Ressources supplémentaires

- [Documentation Nginx](https://nginx.org/en/docs/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Let's Encrypt](https://letsencrypt.org/)
- [HTTP/2 Specifications](https://http2.github.io/)
- [OWASP Security Headers](https://owasp.org/www-project-secure-headers/)

## 💡 Bonnes pratiques

1. **Toujours utiliser HTTPS** en production
2. **Monitorer les logs** régulièrement
3. **Mettre à jour** les images Docker régulièrement
4. **Tester les certificats** avant expiration
5. **Limiter les taux** en fonction de vos besoins
6. **Utiliser des noms de domaine** appropriés
7. **Maintenir les secrets** en dehors du Git (utiliser `.env`)

## 📄 License

MIT - Libre d'utilisation

## 🤝 Contribution

Les contributions sont bienvenues ! Créez une pull request avec vos améliorations.

---

**Créé par** : khadalah-oss  
**Dernière mise à jour** : 2026-06-14
