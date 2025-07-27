# E-Commerce Django Project

## Overview
This is a single-vendor e-commerce web application built with Django. It provides a complete online shopping experience, including product management, user authentication, cart and checkout, payment integration (SSLCommerz), and OTP-based email verification.

## Main Features
- **Product Management**: Add, edit, and list products and categories
- **User Registration & Login**: Secure authentication with OTP email verification
- **Shopping Cart**: Add, update, and remove products from cart
- **Checkout & Order Management**: Place orders, view order details
- **Payment Integration**: SSLCommerz payment gateway (sandbox and live)
- **Admin Dashboard**: Manage products, categories, orders, and users
- **Responsive UI**: User-friendly templates for desktop and mobile

## Project Structure
```
manage.py
requiments.txt
/fixtures
/media
/static
/templates
/ecom/
    settings.py
    urls.py
/ecom_app/
    models.py
    views.py
    urls.py
    utils.py
    context_processors.py
    templates/
```

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd ecom
```

### 2. Create and Activate Virtual Environment
```bash
python -m venv venv
venv\Scripts\activate  # On Windows
source venv/bin/activate  # On Linux/Mac
```

### 3. Install Dependencies
```bash
pip install -r requiments.txt
```

### 4. Configure Environment Variables
Create a `.env` file in the project root:
```
SSLCOMMERZ_STORE_ID=your_store_id
SSLCOMMERZ_STORE_PASSWORD=your_store_password
SSLCOMMERZ_API_URL=https://sandbox.sslcommerz.com/gwprocess/v4/api.php
SSLCOMMERZ_VALIDATION_API=https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php
```

### 5. Configure Email Settings
Edit `ecom/settings.py` with your email credentials (use Gmail App Password):
```
EMAIL_HOST_USER = 'your_email@gmail.com'
EMAIL_HOST_PASSWORD = 'your_app_password'
```

### 6. Apply Migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### 7. Load Initial Data (Optional)
```bash
python manage.py loaddata fixtures/fixtures.json
```

### 8. Create Superuser
```bash
python manage.py createsuperuser
```

### 9. Run the Development Server
```bash
python manage.py runserver
```

### 10. Access the Application
- Frontend: [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
- Admin: [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/)

## Notes
- For payment, use SSLCommerz sandbox credentials for testing.
- For email, use Gmail App Password (not your regular password).
- Static and media files are served from `/static/` and `/media/` directories.

## Troubleshooting
- If emails are not sent, check your email settings and use an App Password.
- If payment integration fails, verify your SSLCommerz credentials and .env file location.
- For any issues, check the console/logs for error messages.


