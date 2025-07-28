#!/usr/bin/env python
import os
import django

# Set up Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecom.settings')
django.setup()

from django.contrib.auth.models import User
from django.contrib.auth import authenticate

print("=== Testing Admin Credentials ===")

# Check if admin user exists
try:
    admin_user = User.objects.get(username='admin')
    print(f"✅ Admin user found:")
    print(f"   Username: {admin_user.username}")
    print(f"   Email: {admin_user.email}")
    print(f"   is_staff: {admin_user.is_staff}")
    print(f"   is_superuser: {admin_user.is_superuser}")
    print(f"   is_active: {admin_user.is_active}")
    print(f"   has_usable_password: {admin_user.has_usable_password()}")
    
    # Test authentication
    print("\n=== Testing Authentication ===")
    user = authenticate(username='admin', password='admin123')
    if user:
        print("✅ Authentication successful!")
        print(f"   Authenticated user: {user.username}")
        print(f"   Is staff: {user.is_staff}")
    else:
        print("❌ Authentication failed!")
        
        # Try to check password directly
        if admin_user.check_password('admin123'):
            print("✅ Direct password check passed")
        else:
            print("❌ Direct password check failed")
            
except User.DoesNotExist:
    print("❌ Admin user not found!")
    
    # Show all users
    all_users = User.objects.all()
    print(f"\nFound {all_users.count()} total users:")
    for user in all_users:
        print(f"   - {user.username} (staff: {user.is_staff})")

print(f"\nTotal users in database: {User.objects.count()}")
