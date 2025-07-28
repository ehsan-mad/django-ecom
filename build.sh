#!/usr/bin/env bash
# exit on error
set -o errexit

echo "=== Starting build process ==="
echo "Python version:"
python --version

echo "=== Upgrading pip ==="
python -m pip install --upgrade pip

echo "=== Installing dependencies ==="
pip install -r requirements.txt

echo "=== Creating necessary directories ==="
mkdir -p staticfiles
mkdir -p ecom_app/templates/website
mkdir -p static/css static/js

echo "=== Making migrations ==="
python manage.py makemigrations --noinput

echo "=== Running migrations ==="
python manage.py migrate --noinput

echo "=== Collecting static files ==="
python manage.py collectstatic --no-input

echo "=== Creating superuser ==="
python manage.py shell << EOF
try:
    from django.contrib.auth import get_user_model
    User = get_user_model()
    if not User.objects.filter(username='admin').exists():
        User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
        print('✅ Superuser created successfully')
    else:
        print('ℹ️ Superuser already exists')
except Exception as e:
    print(f'❌ Error creating superuser: {e}')
EOF

echo "=== Build completed successfully! ==="