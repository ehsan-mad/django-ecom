#!/usr/bin/env python
import os
import django

# Set up Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecom.settings')
django.setup()

from django.contrib.auth.models import User

print("=== Checking Users in Database ===")
users = User.objects.all()
if users.exists():
    for user in users:
        print(f"Username: {user.username}")
        print(f"Email: {user.email}")
        print(f"is_staff: {user.is_staff}")
        print(f"is_superuser: {user.is_superuser}")
        print(f"is_active: {user.is_active}")
        print("-" * 30)
else:
    print("No users found in database!")

print(f"Total users: {users.count()}")
