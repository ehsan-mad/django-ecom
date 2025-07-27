from django.contrib import admin
from django.urls import path, include
from . import views
from ecom_app import views_payment

urlpatterns = [
    # Admin
    # path("admin/", admin.site.urls),
    path("backend/dashboard/", views.ecom_dashboard, name="dashboard"),
    path("backend/setting-dashboard/", views.setting_dashboard, name="setting_dashboard"),
    path("backend/login/", views.dashboard_login, name="dashboard_login"),
    # path("login/", views.user_login, name="user_login"),
    # path("logout/", views.logout, name="logout"),
    path("backend/product-main-category-list/", views.product_main_category_list_view, name="product_main_category_list"),
    path("backend/add_product_main_category/", views.add_product_main_category, name="add_product_main_category"),
    path("backend/product-main-category/<int:pk>/", views.product_main_category_details, name="product_main_category_details"),
    path("backend/product-main-category/edit/<int:pk>/", views.edit_product_main_category, name="edit_product_main_category"),
    
    # Subcategory management
    path("backend/product-sub-category-list/", views.product_subcategory_list_view, name="product_subcategory_list"),
    path("backend/add-product-subcategory/", views.add_product_subcategory, name="add_product_subcategory"),
    path("backend/product-subcategory/<int:pk>/", views.product_subcategory_details, name="product_subcategory_details"),
    path("backend/product-subcategory/edit/<int:pk>/", views.edit_product_subcategory, name="edit_product_subcategory"),
    
    path("backend/product-list/", views.product_list, name="product_list"),
    path("backend/product/<int:pk>/", views.product_detail, name="product_detail"),
    path("backend/product/edit/<int:pk>/", views.product_edit, name="product_edit"),
    path("backend/product/create/", views.create_product, name="add_product"),
    
    
    #User/customer
    path("login/", views.user_login, name="user_login"),
    path("logout/", views.logout_view, name="user_logout"),
    path("register/", views.register, name="register"),
    path('request-otp/', views.request_otp_view, name='request_otp'),
    path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    path("my-account/", views.my_account, name="my_account"),
    path("about/", views.about, name="about"),
    path("products/", views.products, name="products"),
    path("" , views.home, name="home"),
    path("products_details/<slug:product_slug>/", views.products_details, name="products_details"),
    path("add-or-update-cart/", views.add_or_update_cart, name="add_or_update_cart"),
    path("cart/", views.cart, name="cart_view"),
    path("checkout/", views.checkout, name="checkout"),
  
    
    
    #Payment

    path('payment/success/<str:str_data>/', views_payment.payment_complete, name='payment_complete'),
    path('payment/cancel/<str:str_data>/', views_payment.payment_cancel, name='payment_cancel'),
    path('payment/failed/<str:str_data>/', views_payment.payment_failed, name='payment_failed'),
    path('payment/check/<str:str_data>/', views_payment.payment_check, name="payment_check"),
]
