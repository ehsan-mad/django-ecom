from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from ecom_app.models import ProductMainCategory, ProductSubCategory, Product, Customer, OrderCart
from decimal import Decimal

class Command(BaseCommand):
    help = 'Setup test data for cart functionality'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Setting up test data...'))
        
        # Create test user if not exists
        user, created = User.objects.get_or_create(
            username='testuser',
            defaults={
                'email': 'test@example.com',
                'first_name': 'Test',
                'last_name': 'User'
            }
        )
        if created:
            user.set_password('testpass123')
            user.save()
            self.stdout.write(f'Created test user: {user.username}')
        
        # Create customer profile
        customer, created = Customer.objects.get_or_create(
            user=user,
            defaults={
                'phone': '1234567890',
            }
        )
        if created:
            self.stdout.write(f'Created customer profile for: {user.username}')
        
        # Create main categories
        electronics, created = ProductMainCategory.objects.get_or_create(
            main_cat_name='Electronics',
            defaults={
                'cat_slug': 'electronics',
                'description': 'Electronic devices and gadgets',
                'cat_ordering': 1,
                'created_by': user,
                'is_active': True
            }
        )
        if created:
            self.stdout.write('Created Electronics category')
        
        clothing, created = ProductMainCategory.objects.get_or_create(
            main_cat_name='Clothing',
            defaults={
                'cat_slug': 'clothing',
                'description': 'Fashion and apparel',
                'cat_ordering': 2,
                'created_by': user,
                'is_active': True
            }
        )
        if created:
            self.stdout.write('Created Clothing category')
        
        # Create subcategories
        phones, created = ProductSubCategory.objects.get_or_create(
            sub_cat_name='Smartphones',
            main_category=electronics,
            defaults={
                'sub_cat_slug': 'smartphones',
                'sub_cat_ordering': 1,
                'created_by': user,
                'is_active': True
            }
        )
        if created:
            self.stdout.write('Created Smartphones subcategory')
        
        shirts, created = ProductSubCategory.objects.get_or_create(
            sub_cat_name='T-Shirts',
            main_category=clothing,
            defaults={
                'sub_cat_slug': 't-shirts',
                'sub_cat_ordering': 1,
                'created_by': user,
                'is_active': True
            }
        )
        if created:
            self.stdout.write('Created T-Shirts subcategory')
        
        # Create test products
        products_data = [
            {
                'name': 'iPhone 15 Pro',
                'price': Decimal('999.99'),
                'stock': 50,
                'category': electronics,
                'subcategory': phones,
                'description': 'Latest iPhone with advanced features'
            },
            {
                'name': 'Samsung Galaxy S24',
                'price': Decimal('899.99'),
                'stock': 30,
                'category': electronics,
                'subcategory': phones,
                'description': 'Premium Android smartphone'
            },
            {
                'name': 'Cotton T-Shirt Blue',
                'price': Decimal('29.99'),
                'stock': 100,
                'category': clothing,
                'subcategory': shirts,
                'description': 'Comfortable cotton t-shirt in blue'
            },
            {
                'name': 'Vintage T-Shirt Black',
                'price': Decimal('39.99'),
                'stock': 75,
                'category': clothing,
                'subcategory': shirts,
                'description': 'Vintage style black t-shirt'
            }
        ]
        
        for product_data in products_data:
            product, created = Product.objects.get_or_create(
                product_name=product_data['name'],
                defaults={
                    'price': product_data['price'],
                    'stock': product_data['stock'],
                    'main_category': product_data['category'],
                    'sub_category': product_data['subcategory'],
                    'description': product_data['description'],
                    'created_by': user,
                    'is_active': True,
                    'is_featured': False
                }
            )
            if created:
                self.stdout.write(f'Created product: {product.product_name}')
        
        # Create some cart items for testing
        products = Product.objects.all()[:2]  # Get first 2 products
        for product in products:
            cart_item, created = OrderCart.objects.get_or_create(
                customer=customer,
                product=product,
                defaults={
                    'quantity': 2,
                    'is_order': False,
                    'is_active': True
                }
            )
            if created:
                self.stdout.write(f'Added {product.product_name} to cart (qty: 2)')
        
        self.stdout.write(self.style.SUCCESS('Test data setup completed!'))
        self.stdout.write(self.style.SUCCESS('Test user credentials: testuser / testpass123'))
