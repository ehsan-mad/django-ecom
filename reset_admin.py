#!/usr/bin/env python
import os
import django

# Set up Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecom.settings')
django.setup()

from django.contrib.auth.models import User

print("=== Resetting Admin Password ===")

try:
    admin_user = User.objects.get(username='admin')
    admin_user.set_password('admin123')
    admin_user.save()
    print("✅ Password reset to 'admin123'")
    
    # Test the password
    if admin_user.check_password('admin123'):
        print("✅ Password verification successful!")
    else:
        print("❌ Password verification failed!")
        
except User.DoesNotExist:
    print("❌ Admin user not found, creating new one...")
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("✅ New admin user created with password 'admin123'")
