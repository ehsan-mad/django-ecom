#!/bin/bash

# Quick start script for local development
echo "Setting up Django E-Commerce project for local development..."

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Run migrations
echo "Running database migrations..."
python manage.py makemigrations
python manage.py migrate

# Create superuser
echo "Creating superuser..."
python manage.py createsuperuser_auto

# Load fixtures (if available)
if [ -f "fixtures/subcategories.json" ]; then
    echo "Loading subcategories fixture..."
    python manage.py loaddata fixtures/subcategories.json
fi

if [ -f "fixtures/subcategory_menu.json" ]; then
    echo "Loading subcategory menu fixture..."
    python manage.py loaddata fixtures/subcategory_menu.json
fi

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Setup complete! You can now run 'python manage.py runserver' to start the development server."
