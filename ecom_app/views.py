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
@login_required
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
def ecom_dashboard(request):
    return render(request, "home/home.html")

def setting_dashboard(request):
    get_setting_menu=MenuList.objects.filter(module_name="Setting", is_active=True)
    context ={
        'get_setting_menu': get_setting_menu,
    }
    return render(request, "home/setting_dashboard.html", context)

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

def add_product_main_category(request):
    if not checkUserPermission(request, "can_add", "backend/product-main-category-list/"):
        return render(request, "403.html")
    
    if request.method == "POST":
        main_cat_name = request.POST.get("main_cat_name")
        cat_slug = request.POST.get("cat_slug")
   
        description = request.POST.get("description")
        
        if ProductMainCategory.objects.filter(main_cat_name=main_cat_name).exists():
            messages.error(request, "Product main category already exists.")
            return redirect('add_product_main_category')
        
        Product_main_category=ProductMainCategory(
            main_cat_name=main_cat_name,
            cat_slug=cat_slug,
           
            description=description,
            created_by=request.user
        )
        Product_main_category.save()
        messages.success(request, "Product main category added successfully.")
        return redirect('product_main_category_list')
    
    return render(request, "product/add_product_main_category.html")

@login_required
def product_main_category_details(request, pk):
    if not checkUserPermission(request, "can_view", "backend/product-main-category-list/"):
        return render(request, "403.html")
    
    data= get_object_or_404(ProductMainCategory, pk=pk)
    context={
        'data': data
    }
    return render(request, "product/product_main_category_details.html", context)

@login_required
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

@login_required
def product_detail(request, pk):
    if not checkUserPermission(request, "can_view", "backend/product-list/"):
        return render(request, "403.html")
    
    product = get_object_or_404(Product, pk=pk)
    context = {
        'product': product
    }
    return render(request, "product/product_detail.html", context)

@login_required
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
        product.discount_price= request.POST.get("discount_price")
        product.discount_percentage = request.POST.get("discount_percentage")        
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


@login_required
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
        discount_price = request.POST.get("discount_price", 0.00)
        discount_percentage = request.POST.get("discount_percentage", 0)
        description = request.POST.get("description")
        product_image = request.FILES.get("product_image")

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


def user_login(request):
    if request.method == "POST":
        phone = request.POST.get("phone")
        password = request.POST.get("password")

        profile = Customer.objects.get(phone=phone)
        user = authenticate(request, username=profile.user.username, password=password)
        
        if user is not None:
            login(request, user)
            return redirect('home')
       
        next_url=request.GET.get('next')
        if next_url:
           next_url = next_url.strip()
        else:
            next_url = "home"
        
        return redirect(next_url)
           
    
    return render(request, "website/user/login.html")

@login_required
def logout_view(request):
    logout(request)
    return redirect('home')

def register(request):
    if request.method == 'POST':
        username = request.POST['username']
        email = request.POST['email']
        phone = request.POST['phone']
        dob = request.POST['date_of_birth']
        password = request.POST['password']

        if User.objects.filter(username=username).exists():
            return render(request, 'website/user/register.html', {'error': 'Username already taken'})
        
        user = User.objects.create_user(username=username, email=email, password=password)
        Customer.objects.create(user=user, phone=phone, date_of_birth=dob, is_active=False)

        generate_otp(email)

        return redirect(f'/backend/verify-otp/?email={email}')

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
    if request.user.is_authenticated:
        customer = Customer.objects.filter(user=request.user).first()
        product_cart = OrderCart.objects.filter(customer=customer, product=product, is_active=True, is_order=False).first()
        if product_cart:
            product.product_cart= product_cart
    context = {
        'product': product
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

    
    is_authenticated = request.user.is_authenticated
    
    
    if is_authenticated:
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
                    'is_authenticated': is_authenticated,
                    'isRemoved': isRemoved,
                    'item_price': cart_item.total_amount,
                    'cart_item_count': cart_item_count,
                    'amount_summary': amount_summary,
                }
                
                return JsonResponse(response)
            

            except OrderCart.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Cart item not found', 'is_authenticated': is_authenticated,})

    return JsonResponse({'status': 'error', 'message': 'Invalid request', 'is_authenticated': is_authenticated,}, status=400)

@login_required
def cart(request):

    customer= Customer.objects.filter(user=request.user).first()
    context= {
        'customer': customer,

    }

    return render(request, 'website/cart/cart.html',context)    


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
        return redirect(f'/backend/verify-otp/?email={email}') 

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
