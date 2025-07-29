from django.shortcuts import render
from .models import MenuList, UserPermission , ProductMainCategory , Product, ProductSubCategory, Customer, OrderCart , Order, OrderDetail,EmailOTP
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User 
from django.shortcuts import redirect , get_object_or_404
from .common_func import checkUserPermission
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.contrib import messages 
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse
from decimal import Decimal
from django.db import transaction
from .views_payment import create_payment_request
from .utils import generate_otp
# Create your views here.
def paginate_data(request, page_num, data_list):
    items_per_page, max_pages = 10, 10
    paginator = Paginator(data_list, items_per_page)
    last_page_number = paginator.num_pages

    try:
        data_list = paginator.page(page_num)
    except PageNotAnInteger:
        data_list = paginator.page(1)
    except EmptyPage:
        data_list = paginator.page(paginator.num_pages)

    current_page = data_list.number
    start_page = max(current_page - int(max_pages / 2), 1)
    end_page = start_page + max_pages

    if end_page > last_page_number:
        end_page = last_page_number + 1
        start_page = max(end_page - max_pages, 1)

    paginator_list = range(start_page, end_page)

    return data_list, paginator_list, last_page_number

def staff_required(view_func):
    @login_required
    def wrapper(request, *args, **kwargs):
        if not request.user.is_staff:
            return redirect('dashboard_login')
        return view_func(request, *args, **kwargs)
    return wrapper

@staff_required
def ecom_dashboard(request):
    from django.contrib.auth.models import User
    from django.db import models
    from decimal import Decimal
    
    # Get basic statistics
    total_users = User.objects.count()
    total_products = Product.objects.filter(is_active=True).count()
    total_orders = Order.objects.count()
    
    # Calculate total revenue (sum of all completed orders)
    total_revenue = Order.objects.aggregate(
        total=models.Sum('grand_total')
    )['total'] or Decimal('0.00')
    
    context = {
        'total_users': total_users,
        'total_products': total_products,
        'total_orders': total_orders,
        'total_revenue': total_revenue,
    }
    
    return render(request, "home/home.html", context)

@staff_required
def setting_dashboard(request):
    get_setting_menu=MenuList.objects.filter(module_name="Setting", is_active=True)
    context ={
        'get_setting_menu': get_setting_menu,
    }
    return render(request, "home/setting_dashboard.html", context)

@staff_required
def product_main_category_list_view(request):
    if not checkUserPermission(request, "can_view", "backend/product-main-category-list/"):
        return render(request, "403.html")
    products= ProductMainCategory.objects.filter(is_active=True).order_by("-id")
    page_number= request.GET.get('page', 1)
    products, paginator_list, last_page_number = paginate_data(request, page_number, products)
    context ={
        'paginator_list': paginator_list,
        'last_page_number': last_page_number,
        'products': products,
        
    }
        
    return render(request, "product/main_category_list.html", context)

@staff_required
def add_product_main_category(request):
    if not checkUserPermission(request, "can_add", "backend/product-main-category-list/"):
        return render(request, "403.html")
    
    if request.method == "POST":
        main_cat_name = request.POST.get("main_cat_name")
        cat_slug = request.POST.get("cat_slug")
        cat_image_url = request.POST.get("cat_image_url")
        description = request.POST.get("description")
        
        if ProductMainCategory.objects.filter(main_cat_name=main_cat_name).exists():
            messages.error(request, "Product main category already exists.")
            return redirect('add_product_main_category')
        
        Product_main_category = ProductMainCategory(
            main_cat_name=main_cat_name,
            cat_slug=cat_slug,
            cat_image_url=cat_image_url,
            description=description,
            created_by=request.user
        )
        
        # Handle uploaded image file if provided
        if 'cat_image' in request.FILES:
            Product_main_category.cat_image = request.FILES['cat_image']
            
        Product_main_category.save()
        messages.success(request, "Product main category added successfully.")
        return redirect('product_main_category_list')
    
    return render(request, "product/add_product_main_category.html")

@staff_required
def product_main_category_details(request, pk):
    if not checkUserPermission(request, "can_view", "backend/product-main-category-list/"):
        return render(request, "403.html")
    
    data= get_object_or_404(ProductMainCategory, pk=pk)
    context={
        'data': data
    }
    return render(request, "product/product_main_category_details.html", context)

@staff_required
def edit_product_main_category(request, pk):
    if not checkUserPermission(request, "can_update", "backend/product-main-category-list/"):
        return render(request, "403.html")
    
    category = get_object_or_404(ProductMainCategory, pk=pk)
    
    if request.method == "POST":
        main_cat_name = request.POST.get("main_cat_name")
        cat_image_url = request.POST.get("cat_image_url")
        description = request.POST.get("description")
        
        # Check if the new name already exists, but exclude the current category
        if ProductMainCategory.objects.filter(main_cat_name=main_cat_name).exclude(pk=pk).exists():
            messages.error(request, "Product main category with this name already exists.")
            return redirect('edit_product_main_category', pk=pk)
        
        # Update category fields
        category.main_cat_name = main_cat_name
        category.cat_image_url = cat_image_url
        category.description = description
        
        # Handle uploaded image file if provided
        if 'cat_image' in request.FILES:
            category.cat_image = request.FILES['cat_image']
            
        category.save()
        messages.success(request, "Product main category updated successfully.")
        return redirect('product_main_category_list')
    
    context = {
        'category': category
    }
    return render(request, "product/edit_product_main_category.html", context)
    category = get_object_or_404(ProductMainCategory, pk=pk)
    
    if request.method == "POST":
        category.main_cat_name = request.POST.get("main_cat_name")
        category.cat_image_url = request.POST.get("cat_image_url")
        category.description = request.POST.get("description")
        category.updated_by = request.user
        
        # Handle uploaded image file if provided
        if 'cat_image' in request.FILES:
            category.cat_image = request.FILES['cat_image']
            
        category.save()
        messages.success(request, "Product main category updated successfully.")
        return redirect('product_main_category_list')
    
    context = {
        'category': category
    }
    return render(request, "product/edit_product_main_category.html", context)

@staff_required
def product_list(request):
    if not checkUserPermission(request, "can_view", "backend/product-list/"):
        return render(request, "403.html")
    
    products = Product.objects.filter(is_active=True).order_by("-id")
    page_number = request.GET.get('page', 1)
    products, paginator_list, last_page_number = paginate_data(request, page_number, products)
    
    context = {
        'paginator_list': paginator_list,
        'last_page_number': last_page_number,
        'products': products,
    }
    
    return render(request, "product/product_list.html", context)

@staff_required
def product_detail(request, pk):
    if not checkUserPermission(request, "can_view", "backend/product-list/"):
        return render(request, "403.html")
    
    product = get_object_or_404(Product, pk=pk)
    context = {
        'product': product
    }
    return render(request, "product/product_detail.html", context)

@staff_required
def product_edit(request, pk):
    if not checkUserPermission(request, "can_update", "backend/product-list/"):
        return render(request, "403.html")
    
    product = get_object_or_404(Product, pk=pk)
    
    if request.method == "POST":
        product.product_name = request.POST.get("product_name")
        product.description = request.POST.get("description")
        product.main_category = get_object_or_404(ProductMainCategory, pk=request.POST.get("main_category"))
        product.sub_category = get_object_or_404(ProductSubCategory, pk=request.POST.get("sub_category"))
        product.price = request.POST.get("price")
        product.stock = request.POST.get("stock")
        product.is_featured = request.POST.get("is_featured") == 'on'
        
        # Handle empty strings for numeric fields
        try:
            product.discount_price = float(request.POST.get("discount_price", 0)) if request.POST.get("discount_price") else 0
        except ValueError:
            product.discount_price = 0
            
        try:
            product.discount_percentage = int(request.POST.get("discount_percentage", 0)) if request.POST.get("discount_percentage") else 0
        except ValueError:
            product.discount_percentage = 0
            
        product.product_image_url = request.POST.get("product_image_url")
        
        # Handle uploaded image file if provided
        if 'product_image' in request.FILES:
            product.product_image = request.FILES['product_image']
                
        product.updated_by = request.user
        product.save()
        
        messages.success(request, "Product updated successfully.")
        return redirect('product_list')
    
    product_main_categories = ProductMainCategory.objects.filter(is_active=True)
    product_sub_categories = ProductSubCategory.objects.filter(is_active=True)
    
    context = {
        'product': product,
        'main_categories': product_main_categories,
        'sub_categories': product_sub_categories
    }
    return render(request, "product/product_edit.html", context)


@staff_required
def product_subcategory_list_view(request):
    if not checkUserPermission(request, "can_view", "backend/product-sub-category-list/"):
        return render(request, "403.html")
    
    subcategories = ProductSubCategory.objects.filter(is_active=True).order_by("-id")
    page_number = request.GET.get('page', 1)
    subcategories, paginator_list, last_page_number = paginate_data(request, page_number, subcategories)
    
    context = {
        'paginator_list': paginator_list,
        'last_page_number': last_page_number,
        'subcategories': subcategories,
    }
    
    return render(request, "product/subcategory_list.html", context)

@staff_required
def add_product_subcategory(request):
    if not checkUserPermission(request, "can_add", "backend/product-sub-category-list/"):
        return render(request, "403.html")
    
    if request.method == "POST":
        sub_cat_name = request.POST.get("sub_cat_name")
        sub_cat_slug = request.POST.get("sub_cat_slug")
        main_category_id = request.POST.get("main_category")
        sub_cat_image_url = request.POST.get("sub_cat_image_url")
        
        if ProductSubCategory.objects.filter(sub_cat_name=sub_cat_name).exists():
            messages.error(request, "Product subcategory already exists.")
            return redirect('add_product_subcategory')
        
        if not main_category_id:
            messages.error(request, "Main category is required.")
            return redirect('add_product_subcategory')
            
        main_category = get_object_or_404(ProductMainCategory, pk=main_category_id)
        
        product_subcategory = ProductSubCategory(
            sub_cat_name=sub_cat_name,
            sub_cat_slug=sub_cat_slug,
            main_category=main_category,
            sub_cat_image_url=sub_cat_image_url,
            created_by=request.user
        )
        
        # Handle uploaded image file if provided
        if 'sub_cat_image' in request.FILES:
            product_subcategory.sub_cat_image = request.FILES['sub_cat_image']
            
        product_subcategory.save()
        messages.success(request, "Product subcategory added successfully.")
        return redirect('product_subcategory_list')
    
    main_categories = ProductMainCategory.objects.filter(is_active=True)
    context = {
        'main_categories': main_categories
    }
    return render(request, "product/add_product_subcategory.html", context)

@staff_required
def product_subcategory_details(request, pk):
    if not checkUserPermission(request, "can_view", "backend/product-sub-category-list/"):
        return render(request, "403.html")
    
    subcategory = get_object_or_404(ProductSubCategory, pk=pk)
    context = {
        'subcategory': subcategory
    }
    return render(request, "product/product_subcategory_details.html", context)

@staff_required
def edit_product_subcategory(request, pk):
    if not checkUserPermission(request, "can_update", "backend/product-sub-category-list/"):
        return render(request, "403.html")
    
    subcategory = get_object_or_404(ProductSubCategory, pk=pk)
    
    if request.method == "POST":
        sub_cat_name = request.POST.get("sub_cat_name")
        main_category_id = request.POST.get("main_category")
        sub_cat_image_url = request.POST.get("sub_cat_image_url")
        
        # Check if the new name already exists, but exclude the current subcategory
        if ProductSubCategory.objects.filter(sub_cat_name=sub_cat_name).exclude(pk=pk).exists():
            messages.error(request, "Product subcategory with this name already exists.")
            return redirect('edit_product_subcategory', pk=pk)
        
        if not main_category_id:
            messages.error(request, "Main category is required.")
            return redirect('edit_product_subcategory', pk=pk)
            
        # Update subcategory fields
        subcategory.sub_cat_name = sub_cat_name
        subcategory.main_category = get_object_or_404(ProductMainCategory, pk=main_category_id)
        subcategory.sub_cat_image_url = sub_cat_image_url
        subcategory.updated_by = request.user
        
        # Handle uploaded image file if provided
        if 'sub_cat_image' in request.FILES:
            subcategory.sub_cat_image = request.FILES['sub_cat_image']
            
        subcategory.save()
        messages.success(request, "Product subcategory updated successfully.")
        return redirect('product_subcategory_list')
    
    main_categories = ProductMainCategory.objects.filter(is_active=True)
    context = {
        'subcategory': subcategory,
        'main_categories': main_categories
    }
    return render(request, "product/edit_product_subcategory.html", context)


@staff_required
def create_product(request):
    if not checkUserPermission(request, "can_add", "backend/product-list/"):
        return render(request, "403.html")
    
    if request.method == "POST":
        product_name = request.POST.get("product_name")
        product_slug = request.POST.get("product_slug")
        main_category_id = request.POST.get("main_category")
        sub_category_id = request.POST.get("sub_category")
        price = request.POST.get("price")
        stock = request.POST.get("stock")
        is_featured = request.POST.get("is_featured") == 'on'
        
        # Handle empty strings for numeric fields
        try:
            discount_price = float(request.POST.get("discount_price", 0)) if request.POST.get("discount_price") else 0
        except ValueError:
            discount_price = 0
            
        try:
            discount_percentage = int(request.POST.get("discount_percentage", 0)) if request.POST.get("discount_percentage") else 0
        except ValueError:
            discount_percentage = 0
            
        description = request.POST.get("description")
        product_image = request.FILES.get("product_image")
        product_image_url = request.POST.get("product_image_url")

        if not main_category_id or not product_name or not price:
            messages.error(request, "Main category, product name, and price are required.")
            return redirect('add_product')
        main_category = ProductMainCategory.objects.filter(id=main_category_id, is_active=True).first()
        
        if not main_category:
            messages.error(request, "Main category does not exist.")
            return redirect('add_product')
        sub_category = ProductSubCategory.objects.filter(id=sub_category_id).first()
        if not sub_category:
            messages.error(request, "Sub category does not exist.")
            return redirect('add_product')
        if Product.objects.filter(product_name=product_name).exists():
            messages.error(request, "Product already exists.")
            return redirect('add_product')
        
        
        product = Product(
            product_image=product_image,
            product_image_url=product_image_url,
            product_name=product_name,
            product_slug=product_slug,
            main_category=main_category,
            sub_category=sub_category,
            price=price,
            stock=stock,
            discount_percentage=discount_percentage,
            discount_price=discount_price,
            is_featured=is_featured,
            created_by=request.user,
            description=description
        )
        product.save()
        
        messages.success(request, "Product created successfully.")
        return redirect('product_list')
    
    main_categories = ProductMainCategory.objects.filter(is_active=True)
    sub_categories = ProductSubCategory.objects.filter(is_active=True)
    context = {
        'main_categories': main_categories,
        'sub_categories': sub_categories    
    }
    return render(request, "product/add_new_product.html", context)


def dashboard_login(request):
    # If user is already logged in, redirect based on role
    if request.user.is_authenticated:
        if request.user.is_staff:
            return redirect('dashboard')
        else:
            return redirect('home')
            
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            if user.is_staff:
                return redirect('dashboard')
            else:
                # User is authenticated but not staff, redirect to frontend
                return redirect('home')
        else:
            return render(request, "dashboard/login.html", {"error": "Invalid username or password."})
    
    return render(request, "dashboard/login.html")


def user_login(request):
    error_message = None
    
    if request.method == "POST":
        phone = request.POST.get("phone")
        password = request.POST.get("password")
        
        try:
            # First, check if a customer with this phone exists
            customer = Customer.objects.get(phone=phone)
            
            # If we found a customer, try to authenticate the user
            user = authenticate(request, username=customer.user.username, password=password)
            
            if user is not None:
                login(request, user)
                
                # Redirect based on role
                if user.is_staff:
                    return redirect('dashboard')
                else:
                    # Get the next parameter or default to home
                    next_url = request.GET.get('next', 'home')
                    if next_url:
                        next_url = next_url.strip()
                    return redirect(next_url)
            else:
                error_message = "Invalid credentials. Please try again."
        except Customer.DoesNotExist:
            error_message = "No account found with this phone number."
        except Exception as e:
            error_message = "An error occurred. Please try again."
    
    return render(request, "website/user/login.html", {"error_message": error_message})

@login_required
def logout_view(request):
    logout(request)
    return redirect('home')

def register(request):
    if request.method == 'POST':
        first_name = request.POST['first_name']
        last_name = request.POST['last_name']
        username = request.POST['username']
        email = request.POST['email']
        phone = request.POST['phone']
        dob = request.POST['date_of_birth']
        password = request.POST['password']

        if User.objects.filter(username=username).exists():
            return render(request, 'website/user/register.html', {'error': 'Username already taken'})
        
        user = User.objects.create_user(username=username, email=email, password=password)
        user.first_name = first_name
        user.last_name = last_name
        user.save()
        
        Customer.objects.create(user=user, phone=phone, date_of_birth=dob, is_active=False)

        generate_otp(email)

        return redirect(f'/verify-otp/?email={email}')

    return render(request, 'website/user/register.html')

def home(request):
    main_products= ProductMainCategory.objects.filter(is_active=True).order_by("-id")
    featured_products = Product.objects.filter(is_featured=True, is_active=True).order_by("-id")[:10]
    context = {
        'main_products': main_products,
        'featured_products': featured_products,
    }
    return render(request, "website/home.html", context)

def products_details(request, product_slug):
    product = Product.objects.filter(product_slug=product_slug , is_active=True).first()
    if not product:
        messages.error(request, "Product not found.")
        return redirect('home')
        
    # For authenticated users, get their cart information
    if request.user.is_authenticated:
        customer = Customer.objects.filter(user=request.user).first()
        if customer:
            product_cart = OrderCart.objects.filter(customer=customer, product=product, is_active=True, is_order=False).first()
            if product_cart:
                product.product_cart = product_cart
    
    context = {
        'product': product,
        'is_authenticated': request.user.is_authenticated
    }
    return render(request, "website/product/products_details.html", context)


def cart_amount_summary(request):
    sub_total_amount = Decimal('0.00')
    total_vat = Decimal('0.00')
    total_discount = Decimal('0.00')
    grand_total = Decimal('0.00')
    
    if request.user.is_authenticated:
        customer = Customer.objects.filter(user=request.user).first()
        if customer:
            cart_items = OrderCart.objects.filter(customer=customer, is_active=True, is_order=False)
            for item in cart_items:
                item_total = Decimal(str(item.total_amount))
                sub_total_amount += item_total
                # Convert product price to Decimal to avoid type mixing
                product_price = Decimal(str(item.product.price)) if item.product.price else Decimal('0.00')
                total_vat += (product_price * Decimal('0.15'))
                
            grand_total = sub_total_amount + total_vat - total_discount
    
    # Always return the summary (even if user is not authenticated)
    return {
        'sub_total_amount': sub_total_amount,            
        'total_vat': total_vat, 
        'total_discount': total_discount,   
        'grand_total': grand_total,
    }

# Remove @login_required decorator
def add_or_update_cart(request):
    # Check if user is logged in
    if not request.user.is_authenticated:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            # For AJAX requests, return a JSON response
            return JsonResponse({
                'status': 'error', 
                'message': 'Login required',
                'is_authenticated': False,
                'redirect_url': '/user/login/'
            })
        else:
            # For normal requests, show the login required page
            return render(request, 'website/login_required.html')
        
    if request.method == 'POST':
            
            customer=Customer.objects.filter(user=request.user).first()
            
            product_id = request.POST.get('product_id')
            quantity = int(request.POST.get('quantity', 0))

            try:
                isRemoved = False

                cart_item, created = OrderCart.objects.update_or_create(
                    customer=customer, product_id=product_id, is_order=False, is_active=True,
                    defaults={'quantity': quantity}
                )
                
                if not created:
                    if quantity <= 0:
                        cart_item.is_active = False
                        isRemoved = True

                    cart_item.quantity = quantity
                    cart_item.save()

                amount_summary = cart_amount_summary(request)

                cart_item_count = OrderCart.objects.filter(customer=customer, is_order=False, is_active=True).count()
                print(f"Cart Item Count: {cart_item_count}")

               

                response = {
                    'status': 'success',
                    'message': 'Cart updated successfully',
                    'is_authenticated': True,
                    'isRemoved': isRemoved,
                    'item_price': cart_item.total_amount,
                    'cart_item_count': cart_item_count,
                    'amount_summary': amount_summary,
                }
                
                return JsonResponse(response)
            

            except OrderCart.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Cart item not found', 'is_authenticated': True})

    return JsonResponse({'status': 'error', 'message': 'Invalid request', 'is_authenticated': True}, status=400)

@login_required
@login_required
def cart(request):
    customer= Customer.objects.filter(user=request.user).first()
    context= {
        'customer': customer,
    }

    return render(request, 'website/cart/cart.html',context)    


@login_required
@login_required
def checkout(request):
    amount_summary = cart_amount_summary(request)
    grand_total = amount_summary.get('grand_total', 0)

    if grand_total < 1:
        messages.error(request, "Your cart is empty. Please add items to your cart before proceeding to checkout.")
        return redirect('cart')
    
    if request.method == 'POST':

        with transaction.atomic():

            billing_address = request.POST.get('billing_address')
            customer= Customer.objects.filter(user=request.user).first()

            if not billing_address:
                messages.error(request, "Billing address is required.")
                return redirect('checkout')
            
            cart_items = OrderCart.objects.filter(customer=customer, is_active=True, is_order=False)

            if len(cart_items) < 1:
                messages.error(request, "Your cart is empty. Please add items to your cart before proceeding to checkout.")
                return redirect('cart')
            else:

                order_obj= Order.objects.create(
                    customer=customer,
                    billing_address=billing_address,
                    
                )

                order_amount, shipping_charge, discount, coupon_discount, vat_amount, tax_amount = 0, 0, 0, 0, 0, 0

                for cart_item in cart_items:
                    order_amount += cart_item.total_amount

                    OrderDetail.objects.create(
                        order=order_obj,
                        product=cart_item.product,
                        quantity=cart_item.quantity,
                        unit_price=cart_item.product.price,
                        total_price=cart_item.total_amount
                    )

                    grand_total = (order_amount + shipping_charge + vat_amount + tax_amount) - (discount + coupon_discount)

                    order_obj.order_amount = order_amount
                    order_obj.shipping_charge = shipping_charge
                    order_obj.discount = discount
                    order_obj.coupon_discount = coupon_discount
                    order_obj.vat_amount = vat_amount
                    order_obj.tax_amount = tax_amount
                    order_obj.due_amount = grand_total
                    order_obj.grand_total = grand_total
                    order_obj.save()

                    messages.success(request, "Order placed successfully.")
                    
                    response_data, response_status = create_payment_request(request, order_obj.id)
                    print(response_data)
                    print(response_status)

                    

                    if response_data['status'] == "SUCCESS":
                        for cart_item in cart_items:
                            cart_item.is_order = True
                            cart_item.save()

                        return redirect(response_data['GatewayPageURL'])
                    elif "error_message" in response_data:
                        messages.error(request, response_data['error_message'])
                    else:
                        messages.error(request, 'Failed to payment.')

                    

                    return redirect('home')
                
                
    
    # For GET requests, render the checkout page
def request_otp_view(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        generate_otp(email)
        return redirect(f'/verify-otp/?email={email}') 

def verify_otp_view(request):
    email = request.GET.get('email')

    if request.method == 'POST':
        otp = request.POST.get('otp')
        otp_obj = EmailOTP.objects.filter(email=email, code=otp).order_by('-created_at').first()

       

        if otp_obj and not otp_obj.is_expired():
            user = User.objects.filter(email=email).first()
            if not user:
                messages.error(request, "User not found. Please register first.")
                return redirect('register')
            customer = Customer.objects.filter(user=user).first()
            if customer:
                customer.is_active = True
                customer.save()
                messages.success(request, "OTP verified successfully. You can now log in.")
            else:
                messages.error(request, "Customer not found. Please contact support.")
            
            return redirect('home')
        else:
            messages.error(request, "Invalid or expired OTP.")

    return render(request, 'website/user/verify_otp.html', {'email': email})    

@login_required
def my_account(request):
    """
    Display customer profile information and order history
    """
    customer = Customer.objects.filter(user=request.user).first()
    if not customer:
        messages.error(request, "Customer account not found.")
        return redirect('home')
    
    # Get all orders for this customer
    orders = Order.objects.filter(
        customer=customer, 
        is_active=True
    ).order_by('-created_at')
    
    context = {
        'customer': customer,
        'orders': orders
    }
    
    return render(request, 'website/user/my_account.html', context)

def about(request):
    """
    View function for the about page
    """
    return render(request, 'website/about.html')

def products(request):
    """
    View function for the products listing page with filtering and sorting
    """
    # Check if this is an AJAX request from Select2
    if request.GET.get('search_term') and request.GET.get('format') == 'json':
        search_term = request.GET.get('search_term', '')
        print(f"Received Select2 search request with term: {search_term}")
        
        # Search for products that match the term
        from django.db.models import Q
        products_results = Product.objects.filter(
            Q(product_name__icontains=search_term) | 
            Q(description__icontains=search_term)
        ).filter(is_active=True)[:10]  # Limit to 10 results
        
        # Log search results for debugging
        print(f"Found {products_results.count()} products matching: {search_term}")
        for p in products_results:
            print(f"Product: {p.product_name}, Category: {p.main_category.main_cat_name if p.main_category else 'None'}, Price: {p.price}")
        
        # Format results for Select2
        from django.http import JsonResponse
        results = []
        for p in products_results:
            result = {
                'id': p.product_name,
                'text': p.product_name,
                'category': p.main_category.main_cat_name if p.main_category else '',
            }
            # Add price information
            result['price'] = str(p.price)
                
            if p.product_image:
                result['image_url'] = request.build_absolute_uri(p.product_image.url)
            results.append(result)
        
        # Debug what we're returning
        print(f"Returning JSON response: {results}")
        return JsonResponse({'results': results})
    
    # Regular view processing
    # Get all active products
    products_queryset = Product.objects.filter(is_active=True)
    
    # Get all categories and subcategories for the filter sidebar
    categories = ProductMainCategory.objects.filter(is_active=True)
    subcategories = ProductSubCategory.objects.filter(is_active=True)
    
    # Get filter parameters
    search_query = request.GET.get('search', '')
    selected_categories = request.GET.getlist('category')
    selected_subcategories = request.GET.getlist('subcategory')
    min_price = request.GET.get('min_price', '')
    max_price = request.GET.get('max_price', '')
    sort = request.GET.get('sort', 'newest')
    featured = request.GET.get('featured', '')
    
    # Apply search filter if provided - now searches in name and description
    if search_query:
        from django.db.models import Q
        products_queryset = products_queryset.filter(
            Q(product_name__icontains=search_query) | 
            Q(description__icontains=search_query)
        )
    
    # Apply category filter if provided
    if selected_categories:
        products_queryset = products_queryset.filter(main_category__id__in=selected_categories)
    
    # Apply subcategory filter if provided
    if selected_subcategories:
        products_queryset = products_queryset.filter(sub_category__id__in=selected_subcategories)
    
    # Apply price range filter if provided
    if min_price:
        products_queryset = products_queryset.filter(price__gte=min_price)
    if max_price:
        products_queryset = products_queryset.filter(price__lte=max_price)
        
    # Filter by featured products if selected
    if featured == 'yes':
        products_queryset = products_queryset.filter(is_featured=True)
    
    # Apply sorting
    if sort == 'price_low':
        products_queryset = products_queryset.order_by('price')
    elif sort == 'price_high':
        products_queryset = products_queryset.order_by('-price')
    elif sort == 'name_asc':
        products_queryset = products_queryset.order_by('product_name')
    elif sort == 'name_desc':
        products_queryset = products_queryset.order_by('-product_name')
    elif sort == 'discount':
        products_queryset = products_queryset.order_by('-discount_percentage')
    else:  # newest
        products_queryset = products_queryset.order_by('-id')
    
    # Pagination
    page_number = request.GET.get('page', 1)
    products, paginator_list, last_page_number = paginate_data(request, page_number, products_queryset)
    
    # Check if any filter is applied
    is_filtered = bool(search_query or selected_categories or selected_subcategories or 
                      min_price or max_price or featured)
    
    context = {
        'products': products,
        'categories': categories,
        'subcategories': subcategories,
        'search_query': search_query,
        'selected_categories': selected_categories,
        'selected_subcategories': selected_subcategories,
        'min_price': min_price,
        'max_price': max_price,
        'sort': sort,
        'featured': featured,
        'is_filtered': is_filtered,
        'paginator_list': paginator_list,
        'last_page_number': last_page_number,
    }
    
    return render(request, 'website/product/products.html', context)