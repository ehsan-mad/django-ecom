# RENDER.COM EMAIL SETUP GUIDE

## 🚨 URGENT: Set Environment Variables in Render Dashboard

Based on your logs, you need to add these exact environment variables in your Render dashboard:

### Step 1: Go to Render Dashboard
1. Visit: https://dashboard.render.com
2. Find your service: `ecom-tcxl`
3. Click on it → Go to **Environment** tab

### Step 2: Add These Environment Variables

**Option A: TLS Configuration (Port 587)**
```
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_USE_SSL=False
EMAIL_HOST_USER=saadkhan420000@gmail.com
EMAIL_HOST_PASSWORD=ejyu xisl filb txql
EMAIL_TIMEOUT=30
```

**Option B: SSL Configuration (Port 465) - Try if Option A fails**
```
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=465
EMAIL_USE_TLS=False
EMAIL_USE_SSL=True
EMAIL_HOST_USER=saadkhan420000@gmail.com
EMAIL_HOST_PASSWORD=ejyu xisl filb txql
EMAIL_TIMEOUT=30
```

### Step 3: Test Different SMTP Servers

If Gmail doesn't work due to network restrictions, try these alternatives:

**Outlook/Hotmail:**
```
EMAIL_HOST=smtp-mail.outlook.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-outlook-email@outlook.com
EMAIL_HOST_PASSWORD=your-outlook-app-password
```

**SendGrid (Recommended for production):**
```
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=apikey
EMAIL_HOST_PASSWORD=your-sendgrid-api-key
```

### Step 4: Redeploy After Adding Variables
After adding environment variables:
1. Click **Deploy Latest Commit** in Render
2. Wait for deployment to complete
3. Test registration with OTP

### Current Status from Logs:
- ✅ Email credentials are loaded correctly
- ✅ App is running successfully  
- ❌ DNS resolution issue for smtp.gmail.com
- ❌ Error: `[Errno -2] Name or service not known`

### Quick Fix Commands for Testing:
Once deployed, you can test email with this management command:
```bash
python manage.py test_email your-email@gmail.com
```
