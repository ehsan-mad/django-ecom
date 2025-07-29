#!/usr/bin/env python
"""
Email Configuration Test Script
Run this to test if your email settings are working properly.
"""

import os
import sys
import django

# Add the project directory to Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecom.settings')
django.setup()

from django.core.mail import send_mail
from django.conf import settings
from ecom_app.utils import generate_otp

def test_email_config():
    print("🔧 Testing Email Configuration...")
    print(f"EMAIL_HOST: {settings.EMAIL_HOST}")
    print(f"EMAIL_PORT: {settings.EMAIL_PORT}")
    print(f"EMAIL_USE_TLS: {settings.EMAIL_USE_TLS}")
    print(f"EMAIL_HOST_USER: {settings.EMAIL_HOST_USER}")
    print(f"EMAIL_BACKEND: {settings.EMAIL_BACKEND}")
    
    if not settings.EMAIL_HOST_USER or not settings.EMAIL_HOST_PASSWORD:
        print("\n❌ Email credentials not configured!")
        print("Please update your .env file with EMAIL_HOST_USER and EMAIL_HOST_PASSWORD")
        return False
    
    print(f"EMAIL_HOST_PASSWORD: {'*' * len(settings.EMAIL_HOST_PASSWORD)} (hidden)")
    
    # Test email sending
    test_email = input("\nEnter your email address to test: ").strip()
    if not test_email:
        print("❌ No email provided")
        return False
    
    try:
        print(f"\n📧 Sending test email to {test_email}...")
        send_mail(
            subject="Test Email from Django App",
            message="This is a test email to verify your email configuration is working.",
            from_email=settings.EMAIL_HOST_USER,
            recipient_list=[test_email],
            fail_silently=False,
        )
        print("✅ Test email sent successfully!")
        
        # Test OTP generation
        print(f"\n🔐 Testing OTP generation for {test_email}...")
        otp_code = generate_otp(test_email)
        print(f"✅ OTP generated and email sent: {otp_code}")
        
        return True
        
    except Exception as e:
        print(f"❌ Email sending failed: {e}")
        print("\nCommon solutions:")
        print("1. Make sure you're using an App Password (not your regular password)")
        print("2. Enable 2-Factor Authentication on your Gmail account")
        print("3. Check your .env file for correct EMAIL_HOST_USER and EMAIL_HOST_PASSWORD")
        return False

if __name__ == "__main__":
    success = test_email_config()
    if success:
        print("\n🎉 Email configuration is working correctly!")
        print("You can now use the OTP verification feature in your Django app.")
    else:
        print("\n❌ Email configuration needs to be fixed.")
        print("Please check the EMAIL_SETUP_GUIDE.md file for detailed instructions.")
