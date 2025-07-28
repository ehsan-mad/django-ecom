# Django E-Commerce Vercel Deployment Guide

## Prerequisites
1. GitHub account
2. Vercel account (sign up at vercel.com)
3. Your Django project pushed to GitHub

## Step 1: Prepare Your Project

### 1.1 Install Required Packages
```bash
pip install whitenoise python-decouple gunicorn
```

### 1.2 Update requirements.txt
Make sure your requirements.txt includes:
- Django==4.2.16
- whitenoise==6.6.0
- python-decouple==3.8
- gunicorn==21.2.0
- Pillow==10.4.0 (for image handling)

### 1.3 Database Migration
Since Vercel uses serverless functions, you'll need to use SQLite for the database:
```bash
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic
```

## Step 2: Push to GitHub
1. Initialize git repository (if not already done):
```bash
git init
git add .
git commit -m "Initial commit for Vercel deployment"
```

2. Push to GitHub:
```bash
git remote add origin https://github.com/yourusername/your-repo-name.git
git branch -M main
git push -u origin main
```

## Step 3: Deploy on Vercel

### 3.1 Connect GitHub to Vercel
1. Go to https://vercel.com and sign in
2. Click "New Project"
3. Import your GitHub repository
4. Select your Django project repository

### 3.2 Configure Environment Variables
In Vercel dashboard, go to your project settings and add these environment variables:
- `SECRET_KEY`: Your Django secret key
- `DEBUG`: False
- `EMAIL_HOST_USER`: Your email (if using email features)
- `EMAIL_HOST_PASSWORD`: Your email app password

### 3.3 Deploy
1. Click "Deploy" button
2. Wait for the build to complete
3. Your project will be available at https://your-project-name.vercel.app

## Step 4: Post-Deployment Setup

### 4.1 Create Superuser (if needed)
Since you can't run management commands directly on Vercel, you'll need to:
1. Create a superuser locally
2. Export/import the user data, or
3. Use a management command in your views (temporary)

### 4.2 Load Initial Data
If you have fixtures:
```bash
python manage.py loaddata fixtures/your-fixture-file.json
```

## Important Notes

1. **Static Files**: Handled by WhiteNoise middleware
2. **Media Files**: Consider using cloud storage (AWS S3, Cloudinary) for media files in production
3. **Database**: SQLite works for small projects; for larger projects, consider PostgreSQL on external service
4. **Environment Variables**: Always use environment variables for sensitive data

## Troubleshooting

### Common Issues:
1. **Static files not loading**: Check STATIC_ROOT and WhiteNoise configuration
2. **Database errors**: Ensure migrations are run and database is accessible
3. **Import errors**: Check all dependencies are in requirements.txt

### Debug Steps:
1. Check Vercel function logs
2. Verify environment variables
3. Test locally with DEBUG=False
4. Check file paths (use os.path.join for cross-platform compatibility)

## Production Considerations

1. **Security**: 
   - Set DEBUG=False
   - Use strong SECRET_KEY
   - Configure ALLOWED_HOSTS properly

2. **Performance**:
   - Enable static file compression
   - Use CDN for static files
   - Optimize database queries

3. **Monitoring**:
   - Set up error logging
   - Monitor performance
   - Configure email notifications for errors

Your Django e-commerce application should now be successfully deployed on Vercel!
