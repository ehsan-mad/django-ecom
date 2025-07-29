# Email Setup Guide for OTP Verification

## Quick Fix: Gmail Setup

### Step 1: Enable 2-Factor Authentication
1. Go to your Google Account settings: https://myaccount.google.com/
2. Click on "Security" in the left sidebar
3. Under "Signing in to Google", click "2-Step Verification"
4. Follow the prompts to enable 2FA

### Step 2: Generate App Password
1. Still in Security settings, click "App passwords"
2. Select "Mail" as the app
3. Select "Other (Custom name)" as the device
4. Type "Django App" as the name
5. Click "Generate"
6. Google will show you a 16-character password like: `abcd efgh ijkl mnop`

### Step 3: Update .env File
Open your `.env` file and update these lines:
```
EMAIL_HOST_USER=your-actual-email@gmail.com
EMAIL_HOST_PASSWORD=abcd efgh ijkl mnop
```

**Important:** 
- Use your real Gmail address for EMAIL_HOST_USER
- Use the 16-character app password (not your regular password) for EMAIL_HOST_PASSWORD
- Remove spaces from the app password

### Step 4: Test the Configuration
After setting up, restart your Django server:
```bash
python manage.py runserver
```

## Alternative: Test Email Without Gmail

If you want to test quickly without setting up Gmail, you can use a temporary solution by modifying the settings to force console output.

## For Production (Render.com)

You'll need to add these environment variables in your Render dashboard:
- `EMAIL_HOST_USER`: your-email@gmail.com
- `EMAIL_HOST_PASSWORD`: your-app-password

## Troubleshooting

1. **"Authentication failed" error**: Make sure you're using the app password, not your regular password
2. **"Less secure app access" error**: This shouldn't happen with app passwords, but if it does, make sure 2FA is enabled
3. **Still seeing console output**: Make sure your .env file is in the project root and restart the server

## Testing the OTP System

1. Go to your registration page
2. Fill out the form with a real email address (yours)
3. Click register
4. Check your email for the OTP code
5. Enter the code on the verification page
