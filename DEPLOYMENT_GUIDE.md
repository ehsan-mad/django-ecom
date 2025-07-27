# Deployment Guide

This comprehensive guide provides detailed instructions for deploying the Fico E-commerce platform in various environments. It covers both traditional server deployment and containerized deployment with Docker.

## Prerequisites

Before deploying the application, ensure you have:

- Access to a server or hosting provider
- Domain name (optional but recommended)
- SSL certificate (recommended for production)
- Payment gateway credentials (SSL Commerz)
- Email service credentials

## Environment Preparation

### System Requirements

- **Operating System**: Ubuntu 20.04 LTS or higher (recommended)
- **RAM**: Minimum 2GB (4GB+ recommended)
- **CPU**: 2+ cores recommended
- **Storage**: 20GB+ SSD storage
- **Database**: MySQL 8.0 or PostgreSQL 12+
- **Web Server**: Nginx
- **Application Server**: Gunicorn

## Traditional Server Deployment

### Step 1: Server Setup

1. **Update system packages**
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

2. **Install required packages**
   ```bash
   sudo apt install -y python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx git supervisor
   ```

3. **Create a database user and database**
   
   For MySQL:
   ```bash
   sudo mysql -u root -p
   ```
   ```sql
   CREATE DATABASE ficostore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'ficouser'@'localhost' IDENTIFIED BY 'your_secure_password';
   GRANT ALL PRIVILEGES ON ficostore.* TO 'ficouser'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```

   For PostgreSQL:
   ```bash
   sudo -u postgres psql
   ```
   ```sql
   CREATE DATABASE ficostore;
   CREATE USER ficouser WITH PASSWORD 'your_secure_password';
   ALTER ROLE ficouser SET client_encoding TO 'utf8';
   ALTER ROLE ficouser SET default_transaction_isolation TO 'read committed';
   ALTER ROLE ficouser SET timezone TO 'UTC';
   GRANT ALL PRIVILEGES ON DATABASE ficostore TO ficouser;
   \q
   ```

### Step 2: Application Setup

1. **Create application directory**
   ```bash
   sudo mkdir -p /var/www/fico
   sudo chown -R $USER:$USER /var/www/fico
   ```

2. **Clone the repository**
   ```bash
   cd /var/www/fico
   git clone <repository-url> .
   ```

3. **Create virtual environment**
   ```bash
   python3 -m venv env
   source env/bin/activate
   ```

4. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   pip install gunicorn psycopg2-binary
   ```

5. **Create environment file**
   ```bash
   nano .env
   ```
   
   Add the following content (customize as needed):
   ```
   DEBUG=False
   SECRET_KEY=your_generated_secret_key
   ALLOWED_HOSTS=your-domain.com,www.your-domain.com
   
   # Database configuration
   DB_NAME=ficostore
   DB_USER=ficouser
   DB_PASSWORD=your_secure_password
   DB_HOST=localhost
   
   # Email configuration
   EMAIL_HOST_USER=your_email@gmail.com
   EMAIL_HOST_PASSWORD=your_app_password
   
   # SSL Commerz configuration (production)
   SSLCOMMERZ_STORE_ID=your_production_store_id
   SSLCOMMERZ_STORE_PASSWORD=your_production_store_password
   SSLCOMMERZ_API_URL=https://securepay.sslcommerz.com/gwprocess/v4/api.php
   SSLCOMMERZ_VALIDATION_API=https://securepay.sslcommerz.com/validator/api/validationserverAPI.php
   ```

6. **Configure the application**
   ```bash
   python manage.py collectstatic --noinput
   python manage.py migrate
   python manage.py createsuperuser
   ```

7. **Test the application with Gunicorn**
   ```bash
   gunicorn --bind 0.0.0.0:8000 ecom.wsgi:application
   ```
   
   Press Ctrl+C to stop the test server.

### Step 3: Configure Gunicorn Service

1. **Create a systemd service file**
   ```bash
   sudo nano /etc/systemd/system/fico.service
   ```
   
   Add the following content:
   ```
   [Unit]
   Description=Fico E-commerce Gunicorn Daemon
   After=network.target
   
   [Service]
   User=www-data
   Group=www-data
   WorkingDirectory=/var/www/fico
   ExecStart=/var/www/fico/env/bin/gunicorn --workers 3 --bind unix:/var/www/fico/fico.sock ecom.wsgi:application --access-logfile /var/log/fico/access.log --error-logfile /var/log/fico/error.log
   Environment="PATH=/var/www/fico/env/bin"
   EnvironmentFile=/var/www/fico/.env
   
   [Install]
   WantedBy=multi-user.target
   ```

2. **Create log directory**
   ```bash
   sudo mkdir -p /var/log/fico
   sudo chown -R www-data:www-data /var/log/fico
   ```

3. **Start and enable the service**
   ```bash
   sudo systemctl start fico
   sudo systemctl enable fico
   sudo systemctl status fico
   ```

### Step 4: Configure Nginx

1. **Create an Nginx server block**
   ```bash
   sudo nano /etc/nginx/sites-available/fico
   ```
   
   Add the following configuration:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com www.your-domain.com;
       
       location = /favicon.ico { access_log off; log_not_found off; }
       
       location /static/ {
           alias /var/www/fico/static/;
           expires 30d;
       }
       
       location /media/ {
           alias /var/www/fico/media/;
           expires 30d;
       }
       
       location / {
           include proxy_params;
           proxy_pass http://unix:/var/www/fico/fico.sock;
           proxy_connect_timeout 75s;
           proxy_read_timeout 300s;
       }
   }
   ```

2. **Enable the server block**
   ```bash
   sudo ln -s /etc/nginx/sites-available/fico /etc/nginx/sites-enabled
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### Step 5: Set Up SSL with Let's Encrypt

1. **Install Certbot**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   ```

2. **Obtain and install SSL certificate**
   ```bash
   sudo certbot --nginx -d your-domain.com -d www.your-domain.com
   ```

3. **Verify automatic renewal**
   ```bash
   sudo certbot renew --dry-run
   ```

### Step 6: Final Configuration

1. **Set proper permissions**
   ```bash
   sudo chown -R www-data:www-data /var/www/fico
   sudo chmod -R 755 /var/www/fico
   sudo chmod 750 /var/www/fico/.env
   ```

2. **Restart services**
   ```bash
   sudo systemctl restart fico nginx
   ```

3. **Set up database backups**
   
   Create a backup script:
   ```bash
   sudo nano /var/www/fico/backup.sh
   ```
   
   Add the following content:
   ```bash
   #!/bin/bash
   TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
   BACKUP_DIR="/var/www/fico/backups"
   
   # Create backup directory if it doesn't exist
   mkdir -p $BACKUP_DIR
   
   # MySQL backup
   mysqldump -u ficouser -p'your_secure_password' ficostore > $BACKUP_DIR/ficostore_$TIMESTAMP.sql
   
   # Compress the backup
   gzip $BACKUP_DIR/ficostore_$TIMESTAMP.sql
   
   # Remove backups older than 7 days
   find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -delete
   ```
   
   Make the script executable:
   ```bash
   sudo chmod +x /var/www/fico/backup.sh
   ```
   
   Add to crontab:
   ```bash
   sudo crontab -e
   ```
   
   Add the following line:
   ```
   0 2 * * * /var/www/fico/backup.sh > /var/log/fico/backup.log 2>&1
   ```

## Containerized Deployment with Docker

### Step 1: Prepare Docker Configuration

1. **Create a Dockerfile in the project root**
   ```bash
   nano Dockerfile
   ```
   
   Add the following content:
   ```dockerfile
   FROM python:3.10-slim

   ENV PYTHONDONTWRITEBYTECODE=1
   ENV PYTHONUNBUFFERED=1

   WORKDIR /app

   RUN apt-get update && apt-get install -y \
       default-libmysqlclient-dev \
       build-essential \
       python3-dev \
       && rm -rf /var/lib/apt/lists/*

   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   RUN pip install gunicorn

   COPY . .

   RUN python manage.py collectstatic --noinput

   EXPOSE 8000

   CMD ["gunicorn", "--bind", "0.0.0.0:8000", "ecom.wsgi:application"]
   ```

2. **Create docker-compose.yml**
   ```bash
   nano docker-compose.yml
   ```
   
   Add the following content:
   ```yaml
   version: '3.8'

   services:
     db:
       image: mysql:8.0
       volumes:
         - mysql_data:/var/lib/mysql
       env_file:
         - ./.env
       environment:
         - MYSQL_DATABASE=${DB_NAME}
         - MYSQL_USER=${DB_USER}
         - MYSQL_PASSWORD=${DB_PASSWORD}
         - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
       restart: always
       ports:
         - "3306:3306"
       healthcheck:
         test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
         timeout: 20s
         retries: 10

     web:
       build: .
       restart: always
       volumes:
         - .:/app
         - static_volume:/app/static
         - media_volume:/app/media
       env_file:
         - ./.env
       depends_on:
         db:
           condition: service_healthy
       ports:
         - "8000:8000"
       command: >
         bash -c "python manage.py migrate &&
                  gunicorn ecom.wsgi:application --bind 0.0.0.0:8000"

     nginx:
       image: nginx:latest
       ports:
         - "80:80"
         - "443:443"
       volumes:
         - ./nginx/conf.d:/etc/nginx/conf.d
         - ./nginx/ssl:/etc/nginx/ssl
         - static_volume:/var/www/static
         - media_volume:/var/www/media
       depends_on:
         - web

   volumes:
     mysql_data:
     static_volume:
     media_volume:
   ```

3. **Create Nginx configuration**
   ```bash
   mkdir -p nginx/conf.d
   nano nginx/conf.d/default.conf
   ```
   
   Add the following content:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com www.your-domain.com;
       
       # Redirect HTTP to HTTPS
       return 301 https://$host$request_uri;
   }

   server {
       listen 443 ssl;
       server_name your-domain.com www.your-domain.com;
       
       ssl_certificate /etc/nginx/ssl/fullchain.pem;
       ssl_certificate_key /etc/nginx/ssl/privkey.pem;
       
       # SSL configurations
       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_prefer_server_ciphers on;
       ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
       
       # Static and media files
       location /static/ {
           alias /var/www/static/;
           expires 30d;
       }
       
       location /media/ {
           alias /var/www/media/;
           expires 30d;
       }
       
       # Proxy requests to Django
       location / {
           proxy_pass http://web:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

4. **Create .env file for Docker**
   ```bash
   nano .env
   ```
   
   Add the following content:
   ```
   # Django settings
   DEBUG=False
   SECRET_KEY=your_generated_secret_key
   ALLOWED_HOSTS=your-domain.com,www.your-domain.com,web
   
   # Database configuration
   DB_NAME=ficostore
   DB_USER=ficouser
   DB_PASSWORD=your_secure_password
   DB_HOST=db
   DB_ROOT_PASSWORD=your_secure_root_password
   
   # Email configuration
   EMAIL_HOST_USER=your_email@gmail.com
   EMAIL_HOST_PASSWORD=your_app_password
   
   # SSL Commerz configuration (production)
   SSLCOMMERZ_STORE_ID=your_production_store_id
   SSLCOMMERZ_STORE_PASSWORD=your_production_store_password
   SSLCOMMERZ_API_URL=https://securepay.sslcommerz.com/gwprocess/v4/api.php
   SSLCOMMERZ_VALIDATION_API=https://securepay.sslcommerz.com/validator/api/validationserverAPI.php
   ```

### Step 2: Deploy with Docker

1. **Install Docker and Docker Compose (if not already installed)**
   ```bash
   sudo apt update
   sudo apt install apt-transport-https ca-certificates curl software-properties-common
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   sudo apt update
   sudo apt install docker-ce docker-compose
   ```

2. **Set up SSL certificates**
   ```bash
   mkdir -p nginx/ssl
   ```
   
   Copy your SSL certificates to this directory:
   ```bash
   cp /path/to/fullchain.pem nginx/ssl/
   cp /path/to/privkey.pem nginx/ssl/
   ```

3. **Build and start the containers**
   ```bash
   docker-compose up -d
   ```

4. **Create a superuser**
   ```bash
   docker-compose exec web python manage.py createsuperuser
   ```

5. **Verify the deployment**
   ```bash
   docker-compose ps
   ```

### Step 3: Maintenance Tasks

1. **View logs**
   ```bash
   docker-compose logs -f web
   ```

2. **Update the application**
   ```bash
   git pull
   docker-compose build web
   docker-compose up -d
   ```

3. **Backup the database**
   ```bash
   docker-compose exec db mysqldump -u ficouser -p ficostore > backup.sql
   ```

4. **Restore the database**
   ```bash
   docker-compose exec -T db mysql -u ficouser -p ficostore < backup.sql
   ```

## CI/CD Integration

### GitHub Actions Workflow

1. **Create a workflow file at .github/workflows/deploy.yml**
   ```yaml
   name: Deploy Fico E-commerce

   on:
     push:
       branches: [ main ]

   jobs:
     deploy:
       runs-on: ubuntu-latest
       
       steps:
       - uses: actions/checkout@v2
       
       - name: Set up Python
         uses: actions/setup-python@v2
         with:
           python-version: '3.10'
       
       - name: Install dependencies
         run: |
           python -m pip install --upgrade pip
           pip install -r requirements.txt
           pip install pytest
       
       - name: Run tests
         run: |
           pytest
       
       - name: Deploy to production server
         uses: appleboy/ssh-action@master
         with:
           host: ${{ secrets.HOST }}
           username: ${{ secrets.USERNAME }}
           key: ${{ secrets.SSH_KEY }}
           script: |
             cd /var/www/fico
             git pull
             source env/bin/activate
             pip install -r requirements.txt
             python manage.py migrate
             python manage.py collectstatic --noinput
             sudo systemctl restart fico
   ```

2. **Add GitHub secrets**
   - Go to your GitHub repository
   - Navigate to Settings > Secrets
   - Add the following secrets:
     - `HOST`: Your server IP or hostname
     - `USERNAME`: SSH username
     - `SSH_KEY`: Private SSH key for authentication

## Security Considerations

### Web Server Hardening

1. **Secure Nginx configuration**
   ```nginx
   # Add to your Nginx configuration
   server {
       # ...
       
       # Security headers
       add_header X-Content-Type-Options nosniff;
       add_header X-Frame-Options "SAMEORIGIN";
       add_header X-XSS-Protection "1; mode=block";
       add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.google-analytics.com https://ssl.google-analytics.com; img-src 'self' data: https://www.google-analytics.com; style-src 'self' 'unsafe-inline'; font-src 'self'; frame-src 'self'; connect-src 'self'";
       
       # Disable server tokens
       server_tokens off;
       
       # ...
   }
   ```

2. **Configure SSL settings**
   ```nginx
   # Add to your Nginx configuration
   server {
       # ...
       
       # SSL configuration
       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_prefer_server_ciphers on;
       ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
       ssl_session_cache shared:SSL:10m;
       ssl_session_timeout 10m;
       ssl_session_tickets off;
       ssl_stapling on;
       ssl_stapling_verify on;
       
       # ...
   }
   ```

3. **Set up firewall**
   ```bash
   sudo apt install ufw
   sudo ufw default deny incoming
   sudo ufw default allow outgoing
   sudo ufw allow ssh
   sudo ufw allow http
   sudo ufw allow https
   sudo ufw enable
   ```

### Django Security Settings

1. **Update settings.py with security best practices**
   ```python
   # Security settings
   DEBUG = False
   SECURE_SSL_REDIRECT = True
   SESSION_COOKIE_SECURE = True
   CSRF_COOKIE_SECURE = True
   SECURE_BROWSER_XSS_FILTER = True
   SECURE_CONTENT_TYPE_NOSNIFF = True
   SECURE_HSTS_SECONDS = 31536000  # 1 year
   SECURE_HSTS_INCLUDE_SUBDOMAINS = True
   SECURE_HSTS_PRELOAD = True
   X_FRAME_OPTIONS = 'DENY'
   ```

## Performance Optimization

### Database Optimization

1. **Enable MySQL performance optimization**
   ```bash
   sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
   ```
   
   Add or modify the following lines:
   ```
   [mysqld]
   innodb_buffer_pool_size = 256M  # Adjust based on available RAM
   innodb_log_file_size = 64M
   innodb_flush_log_at_trx_commit = 2
   innodb_flush_method = O_DIRECT
   ```
   
   Restart MySQL:
   ```bash
   sudo systemctl restart mysql
   ```

2. **Create proper indexes**
   ```sql
   -- Example indexes to add
   ALTER TABLE ecom_app_product ADD INDEX idx_product_price (price);
   ALTER TABLE ecom_app_product ADD INDEX idx_product_main_category (main_category_id);
   ALTER TABLE ecom_app_product ADD INDEX idx_product_sub_category (sub_category_id);
   ALTER TABLE ecom_app_order ADD INDEX idx_order_customer (customer_id);
   ALTER TABLE ecom_app_order ADD INDEX idx_order_status (status);
   ```

### Caching

1. **Install and configure Redis**
   ```bash
   sudo apt install redis-server
   sudo systemctl enable redis-server
   ```

2. **Add Redis caching to Django settings**
   ```python
   # Cache settings
   CACHES = {
       'default': {
           'BACKEND': 'django_redis.cache.RedisCache',
           'LOCATION': 'redis://127.0.0.1:6379/1',
           'OPTIONS': {
               'CLIENT_CLASS': 'django_redis.client.DefaultClient',
           }
       }
   }
   
   # Session caching
   SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
   SESSION_CACHE_ALIAS = 'default'
   ```

3. **Add Redis to Docker Compose (for containerized deployment)**
   ```yaml
   # Add to docker-compose.yml
   services:
     # ...
     
     redis:
       image: redis:6-alpine
       restart: always
       volumes:
         - redis_data:/data
     
     # ...
     
   volumes:
     # ...
     redis_data:
   ```

### Content Delivery

1. **Configure Nginx for caching static files**
   ```nginx
   # Add to your Nginx configuration
   server {
       # ...
       
       # Static file caching
       location /static/ {
           alias /var/www/fico/static/;
           expires 30d;
           add_header Cache-Control "public, max-age=2592000";
           access_log off;
       }
       
       location /media/ {
           alias /var/www/fico/media/;
           expires 7d;
           add_header Cache-Control "public, max-age=604800";
           access_log off;
       }
       
       # ...
   }
   ```

2. **Optimize image delivery**
   ```bash
   # Install image optimization tools
   sudo apt install jpegoptim optipng
   
   # Optimize JPEG images
   find /var/www/fico/media -name "*.jpg" -o -name "*.jpeg" -exec jpegoptim --strip-all --max=85 {} \;
   
   # Optimize PNG images
   find /var/www/fico/media -name "*.png" -exec optipng -o5 {} \;
   ```

## Monitoring and Maintenance

### Setting Up Monitoring

1. **Install Prometheus and Grafana**
   ```bash
   # Add Prometheus repository
   sudo apt-get update
   sudo apt-get install -y apt-transport-https software-properties-common
   
   # Install Prometheus
   sudo apt-get install -y prometheus prometheus-node-exporter
   
   # Install Grafana
   sudo apt-get install -y apt-transport-https
   sudo apt-get install -y software-properties-common wget
   wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
   echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
   sudo apt-get update
   sudo apt-get install -y grafana
   
   # Start and enable services
   sudo systemctl enable prometheus
   sudo systemctl start prometheus
   sudo systemctl enable grafana-server
   sudo systemctl start grafana-server
   ```

2. **Configure Prometheus**
   ```bash
   sudo nano /etc/prometheus/prometheus.yml
   ```
   
   Add or modify the configuration:
   ```yaml
   global:
     scrape_interval: 15s
   
   scrape_configs:
     - job_name: 'prometheus'
       static_configs:
         - targets: ['localhost:9090']
     
     - job_name: 'node'
       static_configs:
         - targets: ['localhost:9100']
   ```
   
   Restart Prometheus:
   ```bash
   sudo systemctl restart prometheus
   ```

3. **Configure Grafana**
   - Access Grafana at http://your-server-ip:3000
   - Default login: admin/admin
   - Add Prometheus as a data source
   - Import Node Exporter dashboard (ID: 1860)

### Backup Strategy

1. **Database Backups**
   ```bash
   # Create backup script
   sudo nano /usr/local/bin/backup-fico.sh
   ```
   
   Add the following content:
   ```bash
   #!/bin/bash
   
   # Variables
   TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
   BACKUP_DIR="/var/backups/fico"
   MYSQL_USER="ficouser"
   MYSQL_PASSWORD="your_secure_password"
   MYSQL_DATABASE="ficostore"
   RETENTION_DAYS=7
   
   # Create backup directory if it doesn't exist
   mkdir -p $BACKUP_DIR
   
   # Database backup
   mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE | gzip > $BACKUP_DIR/db_$TIMESTAMP.sql.gz
   
   # Media files backup (weekly, on Sundays)
   if [ $(date +%u) -eq 7 ]; then
     tar -czf $BACKUP_DIR/media_$TIMESTAMP.tar.gz /var/www/fico/media
   fi
   
   # Remove old backups
   find $BACKUP_DIR -name "db_*.sql.gz" -mtime +$RETENTION_DAYS -delete
   find $BACKUP_DIR -name "media_*.tar.gz" -mtime +30 -delete
   ```
   
   Make the script executable:
   ```bash
   sudo chmod +x /usr/local/bin/backup-fico.sh
   ```
   
   Add to crontab:
   ```bash
   sudo crontab -e
   ```
   
   Add the following line:
   ```
   0 2 * * * /usr/local/bin/backup-fico.sh > /var/log/fico-backup.log 2>&1
   ```

2. **Offsite Backups**
   ```bash
   # Install rclone
   curl https://rclone.org/install.sh | sudo bash
   
   # Configure rclone (follow interactive prompts)
   rclone config
   
   # Create offsite backup script
   sudo nano /usr/local/bin/offsite-backup.sh
   ```
   
   Add the following content:
   ```bash
   #!/bin/bash
   
   # Variables
   BACKUP_DIR="/var/backups/fico"
   REMOTE_NAME="your-remote"  # Name from rclone config
   REMOTE_PATH="fico-backups"
   
   # Sync backups to remote storage
   rclone sync $BACKUP_DIR $REMOTE_NAME:$REMOTE_PATH
   ```
   
   Make the script executable:
   ```bash
   sudo chmod +x /usr/local/bin/offsite-backup.sh
   ```
   
   Add to crontab:
   ```bash
   sudo crontab -e
   ```
   
   Add the following line:
   ```
   0 4 * * * /usr/local/bin/offsite-backup.sh > /var/log/fico-offsite-backup.log 2>&1
   ```

### Regular Maintenance Tasks

1. **Create a maintenance checklist**
   
   Weekly tasks:
   - Check server disk space
   - Review application logs
   - Verify backups are working
   - Check SSL certificate validity
   
   Monthly tasks:
   - Apply system updates
   - Check database performance
   - Review application performance metrics
   - Test restore procedure for backups
   
   Quarterly tasks:
   - Review security settings
   - Check for outdated dependencies
   - Test failover procedures
   - Review and update monitoring alerts

2. **Automate system updates**
   ```bash
   # Create update script
   sudo nano /usr/local/bin/update-system.sh
   ```
   
   Add the following content:
   ```bash
   #!/bin/bash
   
   # Update package lists
   apt-get update
   
   # Install security updates only
   apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --only-upgrade
   
   # Check if reboot is required
   if [ -f /var/run/reboot-required ]; then
     echo "System requires a reboot"
     # Uncomment to enable automatic reboot
     # reboot
   fi
   ```
   
   Make the script executable:
   ```bash
   sudo chmod +x /usr/local/bin/update-system.sh
   ```
   
   Add to crontab:
   ```bash
   sudo crontab -e
   ```
   
   Add the following line:
   ```
   0 3 * * 0 /usr/local/bin/update-system.sh > /var/log/system-update.log 2>&1
   ```

## Troubleshooting

### Common Issues and Solutions

1. **502 Bad Gateway**
   - Check if Gunicorn is running:
     ```bash
     sudo systemctl status fico
     ```
   - Check Gunicorn logs:
     ```bash
     sudo journalctl -u fico
     ```
   - Verify socket permissions:
     ```bash
     ls -la /var/www/fico/fico.sock
     ```

2. **Static Files Not Loading**
   - Check Nginx configuration
   - Verify STATIC_ROOT in settings.py
   - Run collectstatic again:
     ```bash
     source env/bin/activate
     python manage.py collectstatic --noinput
     ```

3. **Database Connection Issues**
   - Check database credentials
   - Verify database service is running:
     ```bash
     sudo systemctl status mysql
     ```
   - Test database connection:
     ```bash
     mysql -u ficouser -p ficostore
     ```

4. **Email Sending Failures**
   - Verify email credentials
   - Check if Gmail allows less secure apps
   - Test email sending manually:
     ```python
     from django.core.mail import send_mail
     send_mail('Test', 'Test message', 'from@example.com', ['to@example.com'])
     ```

5. **Payment Gateway Issues**
   - Verify SSL Commerz credentials
   - Check network connectivity to SSL Commerz servers
   - Review payment logs
   - Test in sandbox mode first

### Diagnostic Commands

1. **Check Django logs**
   ```bash
   sudo tail -f /var/log/fico/error.log
   ```

2. **Check Nginx logs**
   ```bash
   sudo tail -f /var/log/nginx/error.log
   sudo tail -f /var/log/nginx/access.log
   ```

3. **Check system resources**
   ```bash
   # Check disk space
   df -h
   
   # Check memory usage
   free -m
   
   # Check CPU usage
   top
   ```

4. **Test database connection**
   ```bash
   # For MySQL
   mysql -u ficouser -p -e "SELECT 1"
   
   # For PostgreSQL
   psql -U ficouser -d ficostore -c "SELECT 1"
   ```

5. **Test network connectivity**
   ```bash
   # Test payment gateway connectivity
   curl https://securepay.sslcommerz.com/gwprocess/v4/api.php
   ```

## Scaling Considerations

### Vertical Scaling

1. **Increase server resources**
   - Upgrade CPU and RAM
   - Use faster storage (SSD)
   - Optimize server performance settings

2. **Database optimization**
   - Increase buffer pool size
   - Optimize query performance
   - Use proper indexing

### Horizontal Scaling

1. **Load balancing**
   - Set up multiple web servers
   - Configure Nginx as a load balancer
   - Use sticky sessions for user sessions

2. **Database replication**
   - Set up master-slave replication
   - Use read replicas for read-heavy operations
   - Consider database sharding for very large datasets

3. **Containerization and orchestration**
   - Use Docker Swarm or Kubernetes for container orchestration
   - Implement automatic scaling based on load
   - Use service discovery for distributed systems

## Conclusion

This deployment guide provides comprehensive instructions for deploying the Fico E-commerce platform in both traditional and containerized environments. By following these instructions, you can set up a secure, optimized, and maintainable e-commerce platform.

Remember to:
- Regularly backup your data
- Keep your system updated
- Monitor performance and security
- Test your deployment in a staging environment before applying changes to production

For additional support or questions, refer to the project documentation or contact the development team.
