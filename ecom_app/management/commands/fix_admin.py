from django.core.management.base import BaseCommand
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Fix admin user - recreate with correct credentials'

    def handle(self, *args, **options):
        self.stdout.write("=== Fixing Admin User ===")
        
        # Delete existing admin user if exists
        try:
            existing_admin = User.objects.get(username='admin')
            existing_admin.delete()
            self.stdout.write(self.style.WARNING("🗑️ Existing admin user deleted"))
        except User.DoesNotExist:
            self.stdout.write("ℹ️ No existing admin user found")
        
        # Create new admin user
        try:
            admin_user = User.objects.create_superuser(
                username='admin',
                email='admin@example.com', 
                password='admin123'
            )
            self.stdout.write(self.style.SUCCESS("✅ New admin user created successfully"))
            self.stdout.write(f"   Username: admin")
            self.stdout.write(f"   Password: admin123")
            self.stdout.write(f"   Email: admin@example.com")
            
            # Verify the user
            if admin_user.check_password('admin123'):
                self.stdout.write(self.style.SUCCESS("✅ Password verification successful"))
            else:
                self.stdout.write(self.style.ERROR("❌ Password verification failed"))
                
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"❌ Error creating admin user: {e}"))
