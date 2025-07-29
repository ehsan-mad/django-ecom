

import random
from django.core.mail import send_mail, EmailMultiAlternatives
from django.template.loader import render_to_string
from django.conf import settings
from .models import EmailOTP
from threading import Thread



def generate_otp(email):
    code = str(random.randint(100000, 999999))
    EmailOTP.objects.create(email=email, code=code)

    mail_context = {
        'otp_code': code,
        'expiry_minutes': 60,
    }

    # Check if email is configured properly
    if settings.EMAIL_HOST_USER and settings.EMAIL_HOST_PASSWORD:
        print(f"📧 Attempting to send OTP email to {email}")
        success = send_email(
            [email],
            [],  # Empty CC list for production
            [],
            'Your OTP Code - Fico E-commerce',
            'website/mail/otp_mail.html',
            mail_context
        )
        if success:
            print(f"✅ OTP email sent successfully to {email}")
        else:
            print(f"❌ Failed to send OTP email to {email}")
    else:
        # For development/testing when email is not configured
        print(f"\n🔧 EMAIL CONFIGURATION MISSING!")
        print(f"OTP for {email}: {code}")
        print("Please set EMAIL_HOST_USER and EMAIL_HOST_PASSWORD in your .env file")
        print("Check EMAIL_SETUP_GUIDE.md for instructions")
    
    return code

def send_email(mail_to,cc_list,bcc_list,subject,template,context):

    mail_to_set=set(mail_to)
    cc_list_set=set(cc_list)

    common_emails = mail_to_set.intersection(cc_list_set)

    cc_list_set = cc_list_set - common_emails

    html_body = render_to_string(template, context)

    if len(mail_to) > 0:

        email=  EmailMultiAlternatives(
            subject=subject,
            body=html_body,
            from_email=settings.EMAIL_HOST_USER,
            to=list(mail_to_set),
            cc=list(cc_list_set),
            bcc=list(bcc_list)
        )

        email.attach_alternative(html_body, "text/html")

        try:
            email.send(fail_silently=False)
            print(f"✅ Email sent successfully to {list(mail_to_set)}")
            return True
        except Exception as e:
            print(f"❌ Error sending email: {e}")
            print("Common solutions:")
            print("1. Check your EMAIL_HOST_USER and EMAIL_HOST_PASSWORD in .env")
            print("2. Make sure you're using a Gmail App Password (not regular password)")
            print("3. Ensure 2-Factor Authentication is enabled on Gmail")
            return False
    
    return True