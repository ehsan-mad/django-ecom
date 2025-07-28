from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

class Command(BaseCommand):
    help = 'Check admin user status and test authentication'

    def handle(self, *args, **options):
        self.stdout.write("=== Admin User Diagnostic ===")
        
        # Check total users
        total_users = User.objects.count()
        self.stdout.write(f"Total users in database: {total_users}")
        
        # Check if admin exists
        try:
            admin_user = User.objects.get(username='admin')
            self.stdout.write(self.style.SUCCESS("✅ Admin user found"))
            self.stdout.write(f"   Username: {admin_user.username}")
            self.stdout.write(f"   Email: {admin_user.email}")
            self.stdout.write(f"   is_staff: {admin_user.is_staff}")
            self.stdout.write(f"   is_superuser: {admin_user.is_superuser}")
            self.stdout.write(f"   is_active: {admin_user.is_active}")
            self.stdout.write(f"   has_usable_password: {admin_user.has_usable_password()}")
            self.stdout.write(f"   last_login: {admin_user.last_login}")
            
            # Test authentication
            self.stdout.write("\n=== Testing Authentication ===")
            user = authenticate(username='admin', password='admin123')
            if user:
                self.stdout.write(self.style.SUCCESS("✅ Authentication successful!"))
            else:
                self.stdout.write(self.style.ERROR("❌ Authentication failed!"))
                
                # Test direct password check
                if admin_user.check_password('admin123'):
                    self.stdout.write(self.style.SUCCESS("✅ Direct password check passed"))
                else:
                    self.stdout.write(self.style.ERROR("❌ Direct password check failed"))
                    
        except User.DoesNotExist:
            self.stdout.write(self.style.ERROR("❌ Admin user not found!"))
            
            # Show all users
            all_users = User.objects.all()
            self.stdout.write(f"\nAll users in database:")
            for user in all_users:
                self.stdout.write(f"   - {user.username} (staff: {user.is_staff}, superuser: {user.is_superuser})")
                
        # Try to create admin user if it doesn't exist
        if not User.objects.filter(username='admin').exists():
            self.stdout.write("\n=== Creating Admin User ===")
            try:
                User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
                self.stdout.write(self.style.SUCCESS("✅ Admin user created successfully"))
            except Exception as e:
                self.stdout.write(self.style.ERROR(f"❌ Error creating admin user: {e}"))
