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

echo "=== Creating/Fixing Admin User ==="
python manage.py fix_admin

echo "=== Verifying Admin User ==="
python manage.py check_admin

echo "=== Build completed successfully! ==="