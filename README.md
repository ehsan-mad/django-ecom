## Project Structure

- `ecom/`: Main Django project directory containing settings
- `ecom_app/`: Core application directory
  - `models.py`: Database models for products, orders, customers, etc.
  - `views.py`: View functions for handling requests
  - `views_payment.py`: Payment gateway integration views
  - `utils.py`: Utility functions including OTP generation
  - `templates/`: HTML templates for the website
    - `dashboard/`: Admin dashboard templates
    - `website/`: Customer-facing templates
- `static/`: Static files (CSS, JavaScript, images)
- `media/`: User-uploaded content
- `fixtures/`: Initial data for database seeding

## Admin Access

To access the admin dashboard:
1. Navigate to http://127.0.0.1:8000/backend/login/
2. Log in with the superuser credentials created during setup
3. You will be redirected to the dashboard with access to all management features

## Database Schema

The database schema includes the following key models:

- **User**: Django's built-in user model with extended permissions
- **Customer**: Extends User with additional customer information
- **ProductMainCategory**: Main product categories
- **ProductSubCategory**: Subcategories within main categories
- **Product**: Product details including pricing, stock, and descriptions
- **OrderCart**: Shopping cart items for users
- **Order**: Order information and status
- **OrderDetail**: Line items within an order
- **OnlinePaymentRequest**: Payment tracking for SSL Commerz integration
- **EmailOTP**: OTP codes for email verification

## Email OTP Verification

### Overview
The platform implements email OTP verification for secure authentication. When users register, a one-time password is sent to their email address, which they must enter to verify their account.

### How It Works
1. **Registration Process**: When a user registers, they provide their email along with other information
2. **OTP Generation**: A random 6-digit code is generated and stored with a timestamp
3. **Email Delivery**: The OTP is sent to the user's email address via SMTP
4. **Verification**: User enters the OTP which is validated for correctness and expiration
5. **Account Activation**: Upon successful verification, the user's account is marked as active

### Technical Implementation
The system uses:
- The `EmailOTP` model to store OTP codes and their expiration timestamps
- The `generate_otp` utility function in `utils.py` to create random codes
- Django's email system configured with Gmail SMTP
- Verification logic that checks both code correctness and expiration time

### Setup Instructions
To set up email verification:
1. Create a Gmail account or use an existing one
2. Generate an App Password (not your regular Gmail password):
   - Go to your Google Account > Security > 2-Step Verification
   - At the bottom, click "App passwords"
   - Select "Mail" and "Other" and create a new password
3. Add the email address and app password to your `.env` file
4. Configure Django's email settings in `settings.py`
5. Test the OTP delivery by registering a new user

### Customization Options
You can customize:
- OTP length and complexity in the `generate_otp` function
- Expiration time (default is 10 minutes)
- Email templates for OTP delivery
- Retry policies for failed verification attempts

### Troubleshooting Common Issues
- **Emails not being delivered**: Check spam folder and verify SMTP settings
- **OTP expiration issues**: Verify server time settings and adjust expiration time
- **Gmail authentication failures**: Ensure you're using an App Password, not regular password
## SSL Commerz Payment Gateway Integration

### Overview
The platform integrates with SSL Commerz, a popular payment gateway in Bangladesh that supports multiple payment methods including credit cards, debit cards, mobile banking, and internet banking.

### Features
- Secure payment processing with PCI DSS compliance
- Support for multiple payment methods
- Real-time transaction validation
- IPN (Instant Payment Notification)
- Transaction status tracking
- Refund processing capabilities

### Integration Flow
1. **Checkout Initiation**: Customer completes their order and proceeds to payment
2. **Transaction Initialization**: The application creates a payment request with order details
3. **Gateway Redirect**: Customer is redirected to the SSL Commerz payment page
4. **Payment Processing**: Customer selects their preferred payment method and completes the payment
5. **Callback Handling**: SSL Commerz redirects back to success/fail/cancel URLs
6. **Order Finalization**: The application updates the order status based on the payment result

### Technical Implementation
- Environment variables store the store credentials
- The `OnlinePaymentRequest` model tracks transaction details
- Gateway API endpoints for sandbox and production environments
- Views for handling success, failure, and cancellation callbacks
- IPN handling for asynchronous status updates

### Setup Instructions
1. Create a merchant account with SSL Commerz
2. Obtain API credentials (Store ID and Store Password)
3. Configure the Django application with the credentials in your `.env` file
4. Set up the callback URLs in your SSL Commerz dashboard
5. Test the integration using the sandbox environment

### Testing the Integration
- Use sandbox credentials for testing
- Test card numbers provided by SSL Commerz
- Verify transaction records in both your application and SSL Commerz dashboard
- Test different scenarios (successful payment, failed payment, cancellation)

### Moving to Production
- Update the API endpoints to production URLs
- Replace sandbox credentials with production credentials
- Implement additional security measures
- Ensure compliance with SSL Commerz requirements

### Troubleshooting Common Issues
- **Callback URL issues**: Verify that your URLs are correctly configured
- **Transaction validation failures**: Check the parameters being sent to SSL Commerz
- **IPN message handling**: Ensure your server can receive POST requests from SSL Commerz
- **Session management**: Verify that session data is preserved during the payment flow

## Generating a Fresh Secret Key

### Importance of a Unique Secret Key
Django uses a secret key for cryptographic signing, which is essential for:
- Protecting against cross-site request forgery
- Securing sessions and cookies
- Protecting other security features

Each installation should have a unique secret key that is never shared publicly.

### Generation Methods

#### Method 1: Using Python's Built-in Secrets Module
```python
import secrets
print(secrets.token_urlsafe(50))
```

#### Method 2: Using Django's get_random_secret_key Function
```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

#### Method 3: Using OpenSSL from Command Line
```bash
openssl rand -base64 50
```

### Implementation in Production
For production environments, store your secret key in an environment variable:

```python
# In settings.py
import os
from django.core.management.utils import get_random_secret_key

# Get SECRET_KEY from environment variable or generate a new one
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY', get_random_secret_key())
```

### Best Practices
- Rotate your secret key periodically
- Use different keys in development and production
- Never commit your secret key to version control
- Set up proper access controls for environment variables containing the key
## Developing Custom Product Variations and Filter Systems

### Product Variation System

#### Overview
Product variations allow customers to select different options (like size, color, material) for products. This enhances the shopping experience by providing choices while maintaining inventory control.

#### Database Model Structure
To implement product variations, you can extend the existing models with:

```python
class ProductAttribute(models.Model):
    """Defines the types of attributes (e.g., Color, Size)"""
    name = models.CharField(max_length=100)
    
class ProductVariation(models.Model):
    """Connects products with their variation options"""
    product = models.ForeignKey(Product, related_name='variations', on_delete=models.CASCADE)
    attribute = models.ForeignKey(ProductAttribute, on_delete=models.CASCADE)
    
class ProductVariationOption(models.Model):
    """Stores the actual variations (e.g., Red, Blue for Color)"""
    variation = models.ForeignKey(ProductVariation, related_name='options', on_delete=models.CASCADE)
    value = models.CharField(max_length=100)
    price_adjustment = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    stock = models.IntegerField(default=0)
```

#### Implementation Steps
1. **Create the models**: Add the above models to your `models.py`
2. **Update the admin interface**: Customize the admin to manage variations
3. **Modify product detail templates**: Add variation selection options
4. **Implement JavaScript**: For dynamic price/stock updates
5. **Adjust cart functionality**: To handle variations

#### Code Examples

**Form for variation selection:**
```python
class ProductVariationForm(forms.Form):
    def __init__(self, *args, **kwargs):
        product = kwargs.pop('product')
        super().__init__(*args, **kwargs)
        
        for variation in product.variations.all():
            field_name = f'variation_{variation.id}'
            choices = [(option.id, option.value) for option in variation.options.all()]
            self.fields[field_name] = forms.ChoiceField(
                label=variation.attribute.name,
                choices=choices,
                required=True
            )
```

**Template code for displaying variations:**
```html
<form method="post" action="{% url 'add_to_cart' %}">
    {% csrf_token %}
    <input type="hidden" name="product_id" value="{{ product.id }}">
    
    {% for field in variation_form %}
        <div class="form-group">
            <label>{{ field.label }}</label>
            {{ field }}
        </div>
    {% endfor %}
    
    <button type="submit" class="btn btn-primary">Add to Cart</button>
</form>
```

### Advanced Product Filter System

#### Overview
An advanced filter system improves user experience by allowing customers to narrow down product searches based on various attributes.

#### Key Components
- Category-based filters
- Price range filters
- Attribute-based filters
- Tag-based filters
- Search integration

#### Database Optimization
For efficient filtering:
- Add proper indexes to filter fields
- Use `select_related` and `prefetch_related` to minimize database queries
- Implement caching for filter results
- Optimize queries to use database filtering rather than Python filtering

#### Implementation Steps
1. **Create filter-related models**: Add models for filterable attributes
2. **Build filter form classes**: Create forms to handle filter selections
3. **Develop the filter logic**: Create view functions that process filter parameters
4. **Create templates**: Design UI components for the filter interface
5. **Add AJAX**: For dynamic filtering without page reloads

#### Frontend Integration
Create an intuitive filter UI with:
- Checkbox filters for attributes
- Range sliders for prices
- Instant filtering with AJAX
- Mobile-friendly design with expandable sections

#### Code Examples

**Django view for handling filters:**
```python
def product_list(request):
    products = Product.objects.filter(is_active=True)
    
    # Category filter
    category_id = request.GET.get('category')
    if category_id:
        products = products.filter(main_category_id=category_id)
    
    # Price range filter
    min_price = request.GET.get('min_price')
    max_price = request.GET.get('max_price')
    if min_price:
        products = products.filter(price__gte=min_price)
    if max_price:
        products = products.filter(price__lte=max_price)
    
    # Get all categories for the filter sidebar
    categories = ProductMainCategory.objects.filter(is_active=True)
    
    context = {
        'products': products,
        'categories': categories,
        'selected_category': category_id,
        'min_price': min_price,
        'max_price': max_price,
    }
    
    return render(request, 'website/product/product_list.html', context)
```

**Filter form implementation:**
```python
class ProductFilterForm(forms.Form):
    category = forms.ModelChoiceField(
        queryset=ProductMainCategory.objects.filter(is_active=True),
        required=False,
        empty_label="All Categories"
    )
    min_price = forms.DecimalField(required=False)
    max_price = forms.DecimalField(required=False)
    
    # Add more filter fields as needed
```

### Performance Considerations
- Use database-level filtering whenever possible
- Implement appropriate indexes on filtered fields
- Use caching for frequently accessed filter combinations
- Implement pagination to handle large result sets
- Consider lazy loading of filtered results for better performance

### Extending the System
You can extend the filtering system with:
- Saved filters for registered users
- Recently used filters
- Popular filter combinations
- Analytics to track filter usage patterns
## Deployment

### Traditional Deployment

#### Server Requirements
- Ubuntu 20.04 LTS or higher
- Nginx (Web Server)
- Gunicorn (WSGI Server)
- PostgreSQL (Production Database)
- Let's Encrypt (SSL Certificate)

#### Setting Up the Production Environment

1. **Prepare the server**
   ```bash
   sudo apt update
   sudo apt upgrade
   sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx
   ```

2. **Create a PostgreSQL database**
   ```bash
   sudo -u postgres psql
   CREATE DATABASE ficostore;
   CREATE USER ficouser WITH PASSWORD 'your_secure_password';
   ALTER ROLE ficouser SET client_encoding TO 'utf8';
   ALTER ROLE ficouser SET default_transaction_isolation TO 'read committed';
   ALTER ROLE ficouser SET timezone TO 'UTC';
   GRANT ALL PRIVILEGES ON DATABASE ficostore TO ficouser;
   \q
   ```

3. **Create a Python virtual environment**
   ```bash
   sudo apt install python3-venv
   mkdir -p /var/www/fico
   cd /var/www/fico
   python3 -m venv env
   source env/bin/activate
   ```

4. **Clone the repository**
   ```bash
   git clone <repository-url> .
   ```

5. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   pip install gunicorn psycopg2-binary
   ```

6. **Configure environment variables**
   Create a `.env` file with production settings:
   ```
   DEBUG=False
   SECRET_KEY=your_generated_secret_key
   ALLOWED_HOSTS=your-domain.com,www.your-domain.com
   
   # Database configuration
   DB_NAME=ficostore
   DB_USER=ficouser
   DB_PASSWORD=your_secure_password
   DB_HOST=localhost
   
   # Email configuration
   EMAIL_HOST_USER=your_email@gmail.com
   EMAIL_HOST_PASSWORD=your_app_password
   
   # SSL Commerz configuration (production)
   SSLCOMMERZ_STORE_ID=your_production_store_id
   SSLCOMMERZ_STORE_PASSWORD=your_production_store_password
   SSLCOMMERZ_API_URL=https://securepay.sslcommerz.com/gwprocess/v4/api.php
   SSLCOMMERZ_VALIDATION_API=https://securepay.sslcommerz.com/validator/api/validationserverAPI.php
   ```

7. **Collect static files and run migrations**
   ```bash
   python manage.py collectstatic
   python manage.py migrate
   ```

8. **Configure Gunicorn**
   Create a systemd service file:
   ```bash
   sudo nano /etc/systemd/system/fico.service
   ```
   
   Add the following content:
   ```
   [Unit]
   Description=Fico E-commerce Gunicorn Daemon
   After=network.target
   
   [Service]
   User=www-data
   Group=www-data
   WorkingDirectory=/var/www/fico
   ExecStart=/var/www/fico/env/bin/gunicorn --workers 3 --bind unix:/var/www/fico/fico.sock ecom.wsgi:application
   Environment="PATH=/var/www/fico/env/bin"
   EnvironmentFile=/var/www/fico/.env
   
   [Install]
   WantedBy=multi-user.target
   ```
   
   Start and enable the service:
   ```bash
   sudo systemctl start fico
   sudo systemctl enable fico
   ```

9. **Configure Nginx**
   ```bash
   sudo nano /etc/nginx/sites-available/fico
   ```
   
   Add the following configuration:
   ```
   server {
       listen 80;
       server_name your-domain.com www.your-domain.com;
       
       location / {
           include proxy_params;
           proxy_pass http://unix:/var/www/fico/fico.sock;
       }
       
       location /static/ {
           alias /var/www/fico/static/;
       }
       
       location /media/ {
           alias /var/www/fico/media/;
       }
   }
   ```
   
   Enable the site:
   ```bash
   sudo ln -s /etc/nginx/sites-available/fico /etc/nginx/sites-enabled
   sudo systemctl restart nginx
   ```

10. **Set up SSL with Let's Encrypt**
    ```bash
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d your-domain.com -d www.your-domain.com
    ```

11. **Set correct permissions**
    ```bash
    sudo chown -R www-data:www-data /var/www/fico
    sudo chmod -R 755 /var/www/fico
    ```

## Containerized Deployment with Docker

### Prerequisites
- Docker
- Docker Compose

### Setup

1. **Create a Dockerfile in the project root**

```Dockerfile
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "ecom.wsgi:application"]
```

2. **Create docker-compose.yml**

```yaml
version: '3.8'

services:
  db:
    image: mysql:8.0
    volumes:
      - mysql_data:/var/lib/mysql
    env_file:
      - ./.env
    environment:
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
      - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
    restart: always
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  web:
    build: .
    restart: always
    volumes:
      - .:/app
      - static_volume:/app/static
      - media_volume:/app/media
    env_file:
      - ./.env
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8000:8000"
    command: >
      bash -c "python manage.py migrate &&
               gunicorn ecom.wsgi:application --bind 0.0.0.0:8000"

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
      - static_volume:/var/www/static
      - media_volume:/var/www/media
    depends_on:
      - web

volumes:
  mysql_data:
  static_volume:
  media_volume:
```

3. **Create Nginx configuration**

Create a directory for Nginx configuration:
```bash
mkdir -p nginx/conf.d
```

Create `nginx/conf.d/default.conf`:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name your-domain.com www.your-domain.com;
    
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    
    # SSL configurations
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    
    # Static and media files
    location /static/ {
        alias /var/www/static/;
        expires 30d;
    }
    
    location /media/ {
        alias /var/www/media/;
        expires 30d;
    }
    
    # Proxy requests to Django
    location / {
        proxy_pass http://web:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

4. **Build and run the containers**

```bash
docker-compose up -d
```

5. **Create a superuser inside the container**

```bash
docker-compose exec web python manage.py createsuperuser
```

6. **Monitor the logs**

```bash
docker-compose logs -f
```
### CI/CD Integration

You can implement continuous integration and deployment using GitHub Actions:

1. **Create a workflow file** at `.github/workflows/deploy.yml`:

```yaml
name: Deploy Fico E-commerce

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.10'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install pytest
    
    - name: Run tests
      run: |
        pytest
    
    - name: Deploy to production server
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /var/www/fico
          git pull
          source env/bin/activate
          pip install -r requirements.txt
          python manage.py migrate
          python manage.py collectstatic --noinput
          sudo systemctl restart fico
```

### Production Considerations

1. **Security Enhancements**
   - Set `DEBUG = False` in production
   - Enable `SECURE_SSL_REDIRECT = True`
   - Set appropriate `ALLOWED_HOSTS`
   - Configure `CSRF_COOKIE_SECURE = True` and `SESSION_COOKIE_SECURE = True`

2. **Database Backups**
   - Set up automated database backups
   - Use a service like AWS S3 for backup storage
   - Implement a backup rotation policy

3. **Media File Handling**
   - Consider using a CDN for static and media files
   - Implement file size limits and type validation
   - Set up proper file permissions

4. **Logging and Monitoring**
   - Configure Django's logging system
   - Implement application monitoring with tools like Sentry
   - Set up server monitoring with Prometheus or similar tools

5. **Performance Optimization**
   - Enable database connection pooling
   - Implement caching with Redis or Memcached
   - Configure proper database indexes
   - Optimize static file delivery with compression

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Verify database credentials in your .env file
   - Check if the database server is running
   - Ensure proper network connectivity to the database

2. **Static Files Not Loading**
   - Run `python manage.py collectstatic`
   - Check Nginx configuration for static file paths
   - Verify STATIC_URL and STATIC_ROOT settings

3. **Email Sending Failures**
   - Verify email credentials
   - Check if the email service allows SMTP access
   - Test with a different email provider

4. **Payment Gateway Issues**
   - Verify SSL Commerz credentials
   - Check network connectivity to SSL Commerz servers
   - Test the integration in sandbox mode first

5. **Performance Problems**
   - Check database query optimization
   - Monitor server resource usage
   - Implement caching if not already done

## License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2023 Fico E-commerce

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
