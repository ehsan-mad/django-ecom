from django.core.management.base import BaseCommand
from django.core.mail import send_mail
from django.conf import settings
from ecom_app.utils import generate_otp

class Command(BaseCommand):
    help = 'Test email configuration and OTP sending'

    def add_arguments(self, parser):
        parser.add_argument('email', type=str, help='Email address to test')

    def handle(self, *args, **options):
        email = options['email']
        
        self.stdout.write(f"🔧 Testing email configuration...")
        self.stdout.write(f"EMAIL_HOST: {settings.EMAIL_HOST}")
        self.stdout.write(f"EMAIL_HOST_USER: {settings.EMAIL_HOST_USER}")
        self.stdout.write(f"EMAIL_BACKEND: {settings.EMAIL_BACKEND}")
        
        if not settings.EMAIL_HOST_USER or not settings.EMAIL_HOST_PASSWORD:
            self.stdout.write(
                self.style.ERROR("❌ Email credentials not configured!")
            )
            return
        
        try:
            # Test basic email
            self.stdout.write(f"📧 Sending test email to {email}...")
            send_mail(
                subject="Test Email from Fico E-commerce",
                message="This is a test email from your Django app.",
                from_email=settings.EMAIL_HOST_USER,
                recipient_list=[email],
                fail_silently=False,
            )
            self.stdout.write(self.style.SUCCESS("✅ Basic email sent successfully!"))
            
            # Test OTP generation
            self.stdout.write(f"🔐 Testing OTP generation...")
            otp_code = generate_otp(email)
            self.stdout.write(
                self.style.SUCCESS(f"✅ OTP generated and sent: {otp_code}")
            )
            
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f"❌ Email test failed: {e}")
            )
