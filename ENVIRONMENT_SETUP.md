# Django Multi-Environment Configuration Guide

## 🏗️ **Automatic Environment Detection**

Your Django app now automatically detects and configures itself for different environments:

### 🖥️ **Local Development Environment**
**Triggers when:**
- `DEBUG=True` (default)
- No `DATABASE_URL` environment variable
- Running locally with `python manage.py runserver`

**Configuration:**
- 💾 **Database**: SQLite (`db.sqlite3`)
- 📧 **Email**: Console backend (emails printed to terminal)
- 🔓 **Security**: Relaxed settings for development
- 🔧 **Debug**: Enabled with detailed error pages

### 🚀 **Production Environment** 
**Triggers when:**
- `DEBUG=False` 
- `DATABASE_URL` is provided (Render automatically sets this)
- Deployed on Render.com

**Configuration:**
- 💾 **Database**: PostgreSQL (via `DATABASE_URL`)
- 📧 **Email**: SMTP backend (real emails sent)
- 🔒 **Security**: Enhanced security headers enabled
- ⚡ **Performance**: Optimized for production

## 📁 **Environment Files**

### `.env` (Local Development)
```properties
SECRET_KEY=your-secret-key-here
DEBUG=True

# Email Configuration - UPDATE WITH YOUR GMAIL CREDENTIALS
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=saadkhan420000@gmail.com
EMAIL_HOST_PASSWORD=ejyu xisl filb txql

# SSL Commerce
SSLCOMMERZ_STORE_ID=gg6884dbcbe7492
SSLCOMMERZ_STORE_PASSWORD=gg6884dbcbe7492@ssl
```

### `.env.render` (Production Reference)
```properties
SECRET_KEY=your-production-secret-key
DEBUG=False

# Email Configuration (Set these in Render Dashboard)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=saadkhan420000@gmail.com
EMAIL_HOST_PASSWORD=ejyu xisl filb txql

# Database (Render sets this automatically)
# DATABASE_URL=postgresql://...
```

## 🎯 **Testing Both Environments**

### Local Testing:
```bash
# Should show: "Local Development"
python manage.py check
python manage.py runserver
```

### Production Testing (Render):
```bash
# Environment variables in Render Dashboard:
DEBUG=False
EMAIL_HOST_USER=saadkhan420000@gmail.com
EMAIL_HOST_PASSWORD=ejyu xisl filb txql
```

## 🔧 **Environment Variables for Render**

Add these in your Render Dashboard → Environment:

**Required:**
- `DEBUG=False`
- `EMAIL_HOST_USER=saadkhan420000@gmail.com`
- `EMAIL_HOST_PASSWORD=ejyu xisl filb txql`

**Optional (use defaults):**
- `EMAIL_HOST=smtp.gmail.com`
- `EMAIL_PORT=587`
- `EMAIL_USE_TLS=True`

## 🚨 **Current Status**

✅ **Database**: Auto-detection working (SQLite → PostgreSQL)
✅ **Email**: Environment-based configuration 
✅ **Security**: Production hardening enabled
✅ **Environment Detection**: Automatic switching

## 🐛 **Troubleshooting**

1. **Local emails not working**: Check Gmail credentials in `.env`
2. **Production emails not working**: Check Render environment variables
3. **Database issues**: Verify `DATABASE_URL` in production
4. **Settings not loading**: Check `.env` file exists in project root
