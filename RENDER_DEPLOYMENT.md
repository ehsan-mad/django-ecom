# Django E-Commerce Render Deployment Guide

## Prerequisites
1. GitHub account with your Django project
2. Render account (sign up at render.com)
3. Your project should be ready for deployment

## Step 1: Prepare Your Project for Render

### 1.1 Install Required Packages
```bash
pip install psycopg2-binary whitenoise python-decouple gunicorn dj-database-url
```

### 1.2 Update requirements.txt
Your requirements.txt should include:
```
Django==4.2.16
Pillow==10.4.0
psycopg2-binary==2.9.9
whitenoise==6.6.0
gunicorn==21.2.0
python-decouple==3.8
requests==2.31.0
dj-database-url==2.1.0
```

### 1.3 Create build.sh file
The build.sh file should contain:
```bash
#!/usr/bin/env bash
# exit on error
set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --no-input
python manage.py migrate
```

Make it executable:
```bash
chmod +x build.sh
```

### 1.4 Update settings.py
Ensure your settings.py includes:
- Environment variable support with python-decouple
- Database configuration with dj-database-url
- WhiteNoise for static files
- Production-ready security settings

## Step 2: Push to GitHub
1. Commit all changes:
```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

## Step 3: Deploy on Render

### 3.1 Create Web Service
1. Go to https://render.com and sign in
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Select your Django project repository

### 3.2 Configure Web Service
Fill in the following settings:

**Basic Settings:**
- **Name**: your-ecommerce-app
- **Region**: Choose closest to your users
- **Branch**: main
- **Runtime**: Python 3
- **Build Command**: `./build.sh`
- **Start Command**: `gunicorn ecom.wsgi:application`

### 3.3 Environment Variables
Add these environment variables in Render dashboard:

**Required:**
- `SECRET_KEY`: Your Django secret key (generate a new one)
- `DEBUG`: False
- `DATABASE_URL`: (Render will provide this automatically with PostgreSQL)

**Optional (if using):**
- `SSLCOMMERZ_STORE_ID`: Your SSL Commerce store ID
- `SSLCOMMERZ_STORE_PASSWORD`: Your SSL Commerce password
- `SSLCOMMERZ_API_URL`: SSL Commerce API URL
- `SSLCOMMERZ_VALIDATION_API`: SSL Commerce validation API
- `EMAIL_HOST_USER`: Your email for SMTP
- `EMAIL_HOST_PASSWORD`: Your email app password

### 3.4 Add PostgreSQL Database
1. In Render dashboard, click "New +" → "PostgreSQL"
2. Name it (e.g., "ecommerce-db")
3. Choose region (same as web service)
4. Create database
5. Copy the "Internal Database URL"
6. In your web service environment variables, add:
   - `DATABASE_URL`: [paste the internal database URL]

### 3.5 Deploy
1. Click "Create Web Service"
2. Wait for the build and deployment to complete
3. Your site will be available at: https://your-app-name.onrender.com

## Step 4: Post-Deployment Setup

### 4.1 Create Superuser
Since you can't run interactive commands on Render, create a management command:

Create `ecom_app/management/commands/createsuperuser_auto.py`:
```python
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Create a superuser'

    def handle(self, *args, **options):
        if not User.objects.filter(username='admin').exists():
            User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
            self.stdout.write('Superuser created successfully')
        else:
            self.stdout.write('Superuser already exists')
```

Add this to your build.sh:
```bash
python manage.py createsuperuser_auto
```

### 4.2 Load Initial Data
If you have fixtures, add to build.sh:
```bash
python manage.py loaddata fixtures/your-fixture-file.json
```

## Step 5: Configure Static Files and Media

### 5.1 Static Files
Static files are handled by WhiteNoise automatically.

### 5.2 Media Files (Images)
For production, consider using cloud storage:

**Option 1: Cloudinary (Recommended)**
1. Install: `pip install cloudinary django-cloudinary-storage`
2. Update settings.py:
```python
CLOUDINARY_STORAGE = {
    'CLOUD_NAME': config('CLOUDINARY_CLOUD_NAME'),
    'API_KEY': config('CLOUDINARY_API_KEY'),
    'API_SECRET': config('CLOUDINARY_API_SECRET'),
}

DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'
```

**Option 2: AWS S3**
1. Install: `pip install django-storages boto3`
2. Configure S3 settings in settings.py

## Troubleshooting

### Common Issues:

1. **Build Fails:**
   - Check requirements.txt for correct package versions
   - Ensure build.sh is executable and has correct commands
   - Check Render build logs for specific errors

2. **Database Connection Issues:**
   - Verify DATABASE_URL is correctly set
   - Check if migrations are running in build.sh
   - Ensure PostgreSQL service is running

3. **Static Files Not Loading:**
   - Verify WhiteNoise is in MIDDLEWARE
   - Check STATIC_ROOT is correctly set
   - Ensure collectstatic runs in build.sh

4. **Environment Variables:**
   - Double-check all required env vars are set in Render
   - Verify python-decouple is importing config correctly

### Debug Steps:
1. Check Render service logs
2. Verify all environment variables
3. Test database connection
4. Check static files collection

## Production Best Practices

### Security:
- Use strong SECRET_KEY
- Set DEBUG=False
- Configure ALLOWED_HOSTS properly
- Use HTTPS (Render provides this automatically)

### Performance:
- Enable static file compression with WhiteNoise
- Use PostgreSQL for better performance
- Consider using Redis for caching
- Optimize database queries

### Monitoring:
- Set up error logging
- Monitor service health
- Configure email notifications

## Render Pricing
- Free tier available with limitations
- Paid plans for production apps
- PostgreSQL databases have separate pricing

Your Django e-commerce application should now be successfully deployed on Render with PostgreSQL database and proper static file handling!
