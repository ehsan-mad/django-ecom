# RENDER.COM ENVIRONMENT VARIABLES SETUP
# Add these in your Render dashboard under Environment tab:

# EMAIL CONFIGURATION (Required for OTP verification)
EMAIL_HOST_USER=your-actual-email@gmail.com
EMAIL_HOST_PASSWORD=your-16-character-app-password

# EXAMPLE:
# EMAIL_HOST_USER=john.doe@gmail.com  
# EMAIL_HOST_PASSWORD=abcd efgh ijkl mnop

# Optional: Override defaults if needed
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True

# DJANGO SETTINGS
SECRET_KEY=your-production-secret-key
DEBUG=False

# SSL COMMERCE (Already configured)
SSLCOMMERZ_STORE_ID=gg6884dbcbe7492
SSLCOMMERZ_STORE_PASSWORD=gg6884dbcbe7492@ssl

# IMPORTANT NOTES:
# 1. Use your real Gmail address for EMAIL_HOST_USER
# 2. Use the 16-character App Password (not your regular password)
# 3. Remove spaces from the app password when entering in Render
# 4. After adding variables, redeploy your service
