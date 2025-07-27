-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 27, 2025 at 11:20 AM
-- Server version: 11.8.2-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecom_django`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add menu list', 7, 'add_menulist'),
(26, 'Can change menu list', 7, 'change_menulist'),
(27, 'Can delete menu list', 7, 'delete_menulist'),
(28, 'Can view menu list', 7, 'view_menulist'),
(29, 'Can add user permission', 8, 'add_userpermission'),
(30, 'Can change user permission', 8, 'change_userpermission'),
(31, 'Can delete user permission', 8, 'delete_userpermission'),
(32, 'Can view user permission', 8, 'view_userpermission'),
(33, 'Can add product sub category', 9, 'add_productsubcategory'),
(34, 'Can change product sub category', 9, 'change_productsubcategory'),
(35, 'Can delete product sub category', 9, 'delete_productsubcategory'),
(36, 'Can view product sub category', 9, 'view_productsubcategory'),
(37, 'Can add product main category', 10, 'add_productmaincategory'),
(38, 'Can change product main category', 10, 'change_productmaincategory'),
(39, 'Can delete product main category', 10, 'delete_productmaincategory'),
(40, 'Can view product main category', 10, 'view_productmaincategory'),
(41, 'Can add product', 11, 'add_product'),
(42, 'Can change product', 11, 'change_product'),
(43, 'Can delete product', 11, 'delete_product'),
(44, 'Can view product', 11, 'view_product'),
(45, 'Can add customer', 12, 'add_customer'),
(46, 'Can change customer', 12, 'change_customer'),
(47, 'Can delete customer', 12, 'delete_customer'),
(48, 'Can view customer', 12, 'view_customer'),
(49, 'Can add ordercart', 13, 'add_ordercart'),
(50, 'Can change ordercart', 13, 'change_ordercart'),
(51, 'Can delete ordercart', 13, 'delete_ordercart'),
(52, 'Can view ordercart', 13, 'view_ordercart'),
(53, 'Can add order', 14, 'add_order'),
(54, 'Can change order', 14, 'change_order'),
(55, 'Can delete order', 14, 'delete_order'),
(56, 'Can view order', 14, 'view_order'),
(57, 'Can add order detail', 15, 'add_orderdetail'),
(58, 'Can change order detail', 15, 'change_orderdetail'),
(59, 'Can delete order detail', 15, 'delete_orderdetail'),
(60, 'Can view order detail', 15, 'view_orderdetail'),
(61, 'Can add online payment request', 16, 'add_onlinepaymentrequest'),
(62, 'Can change online payment request', 16, 'change_onlinepaymentrequest'),
(63, 'Can delete online payment request', 16, 'delete_onlinepaymentrequest'),
(64, 'Can view online payment request', 16, 'view_onlinepaymentrequest'),
(65, 'Can add order payment', 17, 'add_orderpayment'),
(66, 'Can change order payment', 17, 'change_orderpayment'),
(67, 'Can delete order payment', 17, 'delete_orderpayment'),
(68, 'Can view order payment', 17, 'view_orderpayment'),
(69, 'Can add email otp', 18, 'add_emailotp'),
(70, 'Can change email otp', 18, 'change_emailotp'),
(71, 'Can delete email otp', 18, 'delete_emailotp'),
(72, 'Can view email otp', 18, 'view_emailotp');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$600000$aBiK7vgJhQRvnsSau4iWub$cYmcypo0aONCVVsSmABIhVP3IS2UYCwKUFmzG36FtTY=', '2025-07-23 10:17:10.473467', 1, 'ehk', '', '', 'ehk@1.com', 1, 1, '2025-07-20 10:42:58.238663'),
(2, 'pbkdf2_sha256$600000$D0GW9pE6ef8VFOQNI0L5k7$8z4YIbbMbSv0k/Jhm9bXGASEP4z4/ICtsRW/r+G05dw=', '2025-07-26 16:07:02.525398', 0, 'saad', '', '', 'saadkhan420000@gmail.com', 0, 1, '2025-07-22 19:45:13.232818'),
(3, 'pbkdf2_sha256$600000$PpNv4Mz6U5hOu1weLiYlaE$+u7P+bE9Bf+6ml5isGTTFIy/R6GxxyKodmFchXb2nDM=', NULL, 0, 'laul', '', '', 'saadkhan420000@gmail.com', 0, 1, '2025-07-26 18:44:53.164535'),
(5, 'pbkdf2_sha256$600000$6wxmKCeCqVCxMfEzwxKSqN$txa8qTdCZZMs4vfx2lZTT33cJXa8kO/fihTaWKb6p2U=', '2025-07-26 18:57:05.746407', 0, 'lll', '', '', 'madboy4224@gmail.com', 0, 1, '2025-07-26 18:55:01.653995');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2025-07-20 19:34:15.056932', '1', 'Living room', 1, '[{\"added\": {}}]', 10, 1),
(2, '2025-07-21 11:00:17.389989', '1', 'Sofa', 1, '[{\"added\": {}}]', 9, 1),
(3, '2025-07-21 11:00:24.199993', '1', 'Sofa', 2, '[]', 9, 1),
(4, '2025-07-21 19:17:35.536345', '1', 'sonagaon_chair', 1, '[{\"added\": {}}]', 11, 1),
(5, '2025-07-22 09:00:32.393386', '2', 'Dining', 1, '[{\"added\": {}}]', 10, 1),
(6, '2025-07-22 16:10:59.629466', '5', 'WOWOW', 1, '[{\"added\": {}}]', 11, 1),
(7, '2025-07-22 16:11:16.365724', '5', 'WOWOW', 2, '[{\"changed\": {\"fields\": [\"Is featured\"]}}]', 11, 1),
(8, '2025-07-22 16:11:23.424143', '4', 'hululu222', 2, '[{\"changed\": {\"fields\": [\"Is featured\", \"Description\"]}}]', 11, 1),
(9, '2025-07-22 16:11:30.985416', '3', 'Mama chair', 2, '[{\"changed\": {\"fields\": [\"Is featured\"]}}]', 11, 1),
(10, '2025-07-22 16:11:36.674492', '2', 'confy chair', 2, '[{\"changed\": {\"fields\": [\"Is featured\"]}}]', 11, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(12, 'ecom_app', 'customer'),
(18, 'ecom_app', 'emailotp'),
(7, 'ecom_app', 'menulist'),
(16, 'ecom_app', 'onlinepaymentrequest'),
(14, 'ecom_app', 'order'),
(13, 'ecom_app', 'ordercart'),
(15, 'ecom_app', 'orderdetail'),
(17, 'ecom_app', 'orderpayment'),
(11, 'ecom_app', 'product'),
(10, 'ecom_app', 'productmaincategory'),
(9, 'ecom_app', 'productsubcategory'),
(8, 'ecom_app', 'userpermission'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-07-20 10:42:37.602624'),
(2, 'auth', '0001_initial', '2025-07-20 10:42:37.909972'),
(3, 'admin', '0001_initial', '2025-07-20 10:42:37.970851'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-07-20 10:42:37.977851'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-07-20 10:42:37.984658'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-07-20 10:42:38.033877'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-07-20 10:42:38.063936'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-07-20 10:42:38.084330'),
(9, 'auth', '0004_alter_user_username_opts', '2025-07-20 10:42:38.091076'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-07-20 10:42:38.138341'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-07-20 10:42:38.141343'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-07-20 10:42:38.147797'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-07-20 10:42:38.168561'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-07-20 10:42:38.186957'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-07-20 10:42:38.208459'),
(16, 'auth', '0011_update_proxy_permissions', '2025-07-20 10:42:38.215551'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-07-20 10:42:38.234836'),
(18, 'ecom_app', '0001_initial', '2025-07-20 10:42:38.439171'),
(19, 'sessions', '0001_initial', '2025-07-20 10:42:38.463170'),
(20, 'ecom_app', '0002_productmaincategory_productsubcategory', '2025-07-20 18:21:01.106445'),
(21, 'ecom_app', '0003_product', '2025-07-21 19:14:50.627013'),
(22, 'ecom_app', '0004_product_discount', '2025-07-22 09:07:02.705846'),
(23, 'ecom_app', '0005_rename_discount_product_discount_price_and_more', '2025-07-22 10:07:30.114676'),
(24, 'ecom_app', '0006_customer_ordercart', '2025-07-22 16:40:56.420855'),
(25, 'ecom_app', '0007_order_orderdetail', '2025-07-23 13:15:23.216796'),
(26, 'ecom_app', '0008_onlinepaymentrequest', '2025-07-26 12:39:08.030825'),
(27, 'ecom_app', '0009_orderpayment', '2025-07-26 17:12:51.460776'),
(28, 'ecom_app', '0010_emailotp', '2025-07-26 18:30:02.194481'),
(29, 'ecom_app', '0011_customer_is_active', '2025-07-26 18:44:31.570937');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('b37dip5diem9hnskqvzxcxl8otsjbjgp', '.eJxVjDEOwjAMAP-SGUVxG-KUkZ03RHbt0AJKpaadEH9HkTrAene6t0m0b1Paq65pFnMxYE6_jGl8amlCHlTuix2Xsq0z25bYw1Z7W0Rf16P9G0xUp7bNOGgOPYHzNApE51GHGGNGdX0G5tipBPHI5w4DKkIACUyuZ2Cv5vMF4JI31w:1udZa4:2f6SQ5mp2r6gwVTo1hIgOhmqGrMbs03aIF6j1QcFJAY', '2025-08-03 19:20:16.731652'),
('d527aiml7s1nfukfdx30r4s59xhdx0s4', '.eJxVjDsOwjAQBe_iGlnxL15T0nMGa71r4wBypDipEHeHSCmgfTPzXiLitta49bzEicVZOHH63RLSI7cd8B3bbZY0t3WZktwVedAurzPn5-Vw_w4q9vqtAYLhNELyNFijmEJWji1oPxbUShdHSvnBBG09FijBuOysIdRM4InE-wPNbzeE:1ufk4v:6PkOtZEoLi8bjDpWZ3MyzxlUuKAYNy0r2RsaEytrS3g', '2025-08-09 18:57:05.748328');

-- --------------------------------------------------------

--
-- Table structure for table `ecom_app_customer`
--

CREATE TABLE `ecom_app_customer` (
  `id` bigint(20) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ecom_app_customer`
--

INSERT INTO `ecom_app_customer` (`id`, `phone`, `date_of_birth`, `user_id`, `is_active`) VALUES
(1, '013057067764', NULL, 2, 0),
(4, '01305706776', '2025-07-27', 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ecom_app_emailotp`
--

CREATE TABLE `ecom_app_emailotp` (
  `id` bigint(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `code` varchar(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ecom_app_emailotp`
--

INSERT INTO `ecom_app_emailotp` (`id`, `email`, `code`, `created_at`, `is_active`) VALUES
(1, 'saadkhan420000@gmail.com', '877118', '2025-07-26 18:44:53.689136', 1),
(2, 'madboy4224@gmail.com', '958077', '2025-07-26 18:46:19.547054', 1),
(3, 'madboy4224@gmail.com', '599327', '2025-07-26 18:55:02.180677', 1);

-- --------------------------------------------------------

--
-- Table structure for table `menu_list`
--

CREATE TABLE `menu_list` (
  `id` bigint(20) NOT NULL,
  `module_name` varchar(100) NOT NULL,
  `menu_name` varchar(100) NOT NULL,
  `menu_url` varchar(250) NOT NULL,
  `menu_icon` varchar(250) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `is_main_menu` tinyint(1) NOT NULL,
  `is_sub_menu` tinyint(1) NOT NULL,
  `is_sub_child_menu` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `deleted_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_list`
--

INSERT INTO `menu_list` (`id`, `module_name`, `menu_name`, `menu_url`, `menu_icon`, `parent_id`, `is_main_menu`, `is_sub_menu`, `is_sub_child_menu`, `created_at`, `updated_at`, `deleted_at`, `is_active`, `deleted`, `created_by_id`) VALUES
(1, 'Ecommerce', 'Ecom Dashboard', '/backend/dashboard/', 'fa fa-users icon', 0, 1, 0, 0, '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', 1, 0, 1),
(2, 'Setting', 'Setting Dashboard', '/backend/setting-dashboard/', 'fa fa-users icon', 0, 1, 0, 0, '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', 1, 0, 1),
(3, 'Setting', 'Product Main Category', '/backend/product-main-category-list/', 'fa fa-users icon', 2, 0, 1, 0, '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', 1, 0, 1),
(4, 'Setting', 'Product List', '/backend/product-list/', 'fa fa-users icon', 2, 0, 1, 0, '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', '2025-05-07 15:01:14.353000', 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `online_payment_request`
--

CREATE TABLE `online_payment_request` (
  `id` bigint(20) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` varchar(15) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `order_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `online_payment_request`
--

INSERT INTO `online_payment_request` (`id`, `transaction_id`, `amount`, `payment_status`, `created_at`, `updated_at`, `created_by_id`, `order_id`) VALUES
(8, 'cd31384a-1e97-4e32-ab18-c4562f285458', 2000.00, 'Pending', '2025-07-26 17:01:11.106321', '2025-07-26 17:01:11.106338', 2, 9),
(9, '652cac43-3203-40ee-bfe4-d7d93ef891c6', 369.00, 'Pending', '2025-07-26 17:02:37.786847', '2025-07-26 17:02:37.786862', 2, 10),
(10, '7c00099c-0ce1-43a6-8c6d-4df64191d9f6', 5000.00, 'Pending', '2025-07-26 17:08:35.638422', '2025-07-26 17:08:35.638438', 2, 11),
(11, 'b9993c2d-8ae5-44d5-8311-75a04531d2a9', 5000.00, 'Paid', '2025-07-26 17:19:55.934810', '2025-07-26 17:20:28.980944', 2, 12),
(12, '4f958592-5dc4-4259-8fbf-daf9f31b7ece', 8488.00, 'Paid', '2025-07-26 19:01:58.551794', '2025-07-26 19:02:10.899551', 5, 13),
(13, '57fa80af-cd5e-4e2f-ba62-0fcc3a6d5b6f', 6366.00, 'Paid', '2025-07-26 19:03:56.262578', '2025-07-26 19:04:04.999307', 5, 14),
(14, '767da4be-1ae2-4c3d-8cb8-9566d2b92954', 3000.00, 'Paid', '2025-07-26 19:05:29.222563', '2025-07-26 19:05:37.143050', 5, 15);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL,
  `order_number` varchar(100) DEFAULT NULL,
  `billing_address` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `order_amount` decimal(20,2) NOT NULL,
  `shipping_charge` decimal(20,2) NOT NULL,
  `discount` decimal(20,2) NOT NULL,
  `coupon_discount` decimal(20,2) NOT NULL,
  `vat_amount` decimal(20,2) NOT NULL,
  `tax_amount` decimal(20,2) NOT NULL,
  `paid_amount` decimal(20,2) NOT NULL,
  `due_amount` decimal(20,2) NOT NULL,
  `grand_total` decimal(20,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `customer_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `billing_address`, `status`, `order_amount`, `shipping_charge`, `discount`, `coupon_discount`, `vat_amount`, `tax_amount`, `paid_amount`, `due_amount`, `grand_total`, `is_active`, `created_at`, `updated_at`, `customer_id`) VALUES
(1, '2025070001261', 'hulalala ', 'pending', 2000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 2000.00, 2000.00, 1, '2025-07-26 11:30:02.358450', '2025-07-26 11:30:02.362441', 1),
(9, '2025070002261', 'fasa', 'pending', 2000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 2000.00, 2000.00, 1, '2025-07-26 17:01:11.100094', '2025-07-26 17:01:11.103275', 1),
(10, '2025070003261', 'asdasdasd', 'pending', 369.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 369.00, 369.00, 1, '2025-07-26 17:02:37.782263', '2025-07-26 17:02:37.784842', 1),
(11, '2025070004261', 'aASDCA', 'pending', 5000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 5000.00, 5000.00, 1, '2025-07-26 17:08:35.634020', '2025-07-26 17:08:35.636429', 1),
(12, '2025070005261', 'LOLU', 'pending', 5000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 5000.00, 5000.00, 1, '2025-07-26 17:19:55.929737', '2025-07-26 17:19:55.932232', 1),
(13, '2025070006274', 'asdasdasd', 'pending', 8488.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 8488.00, 8488.00, 1, '2025-07-26 19:01:58.546445', '2025-07-26 19:01:58.549197', 4),
(14, '2025070007274', 'sg', 'pending', 6366.00, 0.00, 0.00, 0.00, 0.00, 0.00, 6366.00, 0.00, 6366.00, 1, '2025-07-26 19:03:56.256116', '2025-07-26 19:04:05.004570', 4),
(15, '2025070008274', 'dfgsdf', 'pending', 3000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3000.00, 0.00, 3000.00, 1, '2025-07-26 19:05:29.218357', '2025-07-26 19:05:37.148318', 4);

-- --------------------------------------------------------

--
-- Table structure for table `order_cart`
--

CREATE TABLE `order_cart` (
  `id` bigint(20) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL CHECK (`quantity` >= 0),
  `is_order` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_cart`
--

INSERT INTO `order_cart` (`id`, `quantity`, `is_order`, `is_active`, `created_at`, `updated_at`, `customer_id`, `product_id`) VALUES
(1, 0, 0, 0, '2025-07-22 19:47:32.638966', '2025-07-23 10:29:04.747059', 1, 4),
(2, 0, 0, 0, '2025-07-23 10:18:19.764824', '2025-07-23 10:33:54.373758', 1, 1),
(3, 0, 0, 0, '2025-07-23 10:29:06.510532', '2025-07-23 10:34:08.000159', 1, 4),
(4, 0, 0, 0, '2025-07-23 10:33:56.010825', '2025-07-23 10:45:38.689878', 1, 1),
(5, 0, 0, 0, '2025-07-23 10:34:09.181851', '2025-07-23 10:34:09.824522', 1, 4),
(6, 0, 0, 0, '2025-07-23 10:34:13.352282', '2025-07-23 10:34:13.885738', 1, 4),
(7, 0, 0, 0, '2025-07-23 10:34:14.474161', '2025-07-23 10:34:15.246755', 1, 4),
(8, 0, 0, 0, '2025-07-23 10:34:15.834515', '2025-07-23 10:34:16.539841', 1, 4),
(9, 0, 0, 0, '2025-07-23 10:34:16.984067', '2025-07-23 10:34:17.516271', 1, 4),
(10, 0, 0, 0, '2025-07-23 10:34:47.148711', '2025-07-23 10:46:28.054135', 1, 5),
(11, 2, 1, 1, '2025-07-23 10:45:40.141995', '2025-07-26 17:01:11.269622', 1, 1),
(12, 0, 0, 0, '2025-07-23 10:45:47.435555', '2025-07-23 10:46:01.282904', 1, 2),
(13, 3, 1, 1, '2025-07-26 17:02:25.242546', '2025-07-26 17:02:37.912224', 1, 2),
(14, 0, 0, 0, '2025-07-26 17:08:21.123008', '2025-07-26 17:08:21.682432', 1, 1),
(15, 0, 0, 0, '2025-07-26 17:08:22.256320', '2025-07-26 17:08:24.630252', 1, 1),
(16, 5, 1, 1, '2025-07-26 17:08:26.181061', '2025-07-26 17:08:35.757983', 1, 1),
(17, 5, 1, 1, '2025-07-26 17:19:44.726821', '2025-07-26 17:19:56.063078', 1, 1),
(18, 0, 0, 0, '2025-07-26 18:57:09.914355', '2025-07-26 18:57:10.964909', 4, 4),
(19, 4, 1, 1, '2025-07-26 18:57:14.754289', '2025-07-26 19:01:58.693092', 4, 4),
(20, 3, 1, 1, '2025-07-26 19:03:38.065307', '2025-07-26 19:03:56.389691', 4, 4),
(21, 1, 1, 1, '2025-07-26 19:03:44.949169', '2025-07-26 19:03:56.390907', 4, 5),
(22, 4, 1, 1, '2025-07-26 19:03:49.660015', '2025-07-26 19:03:56.391654', 4, 2),
(23, 3, 1, 1, '2025-07-26 19:05:04.686376', '2025-07-26 19:05:29.343120', 4, 1),
(24, 1, 1, 1, '2025-07-26 19:05:13.340258', '2025-07-26 19:05:29.344122', 4, 4),
(25, 1, 1, 1, '2025-07-26 19:05:17.046684', '2025-07-26 19:05:29.344844', 4, 3),
(26, 2, 1, 1, '2025-07-26 19:05:22.706757', '2025-07-26 19:05:29.345517', 4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id` bigint(20) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `is_discount` tinyint(1) NOT NULL,
  `discount_price` decimal(10,2) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL CHECK (`quantity` >= 0),
  `total_price` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `order_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`id`, `unit_price`, `is_discount`, `discount_price`, `quantity`, `total_price`, `is_active`, `created_at`, `updated_at`, `order_id`, `product_id`) VALUES
(1, 1000.00, 0, 0.00, 2, 2000.00, 1, '2025-07-26 11:30:02.360286', '2025-07-26 11:30:02.360299', 1, 1),
(9, 1000.00, 0, 0.00, 2, 2000.00, 1, '2025-07-26 17:01:11.102493', '2025-07-26 17:01:11.102511', 9, 1),
(10, 123.00, 0, 0.00, 3, 369.00, 1, '2025-07-26 17:02:37.784217', '2025-07-26 17:02:37.784231', 10, 2),
(11, 1000.00, 0, 0.00, 5, 5000.00, 1, '2025-07-26 17:08:35.635810', '2025-07-26 17:08:35.635824', 11, 1),
(12, 1000.00, 0, 0.00, 5, 5000.00, 1, '2025-07-26 17:19:55.931608', '2025-07-26 17:19:55.931621', 12, 1),
(13, 2122.00, 0, 0.00, 4, 8488.00, 1, '2025-07-26 19:01:58.548578', '2025-07-26 19:01:58.548593', 13, 4),
(14, 2122.00, 0, 0.00, 3, 6366.00, 1, '2025-07-26 19:03:56.258281', '2025-07-26 19:03:56.258297', 14, 4),
(15, 1000.00, 0, 0.00, 3, 3000.00, 1, '2025-07-26 19:05:29.219999', '2025-07-26 19:05:29.220012', 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_payments`
--

CREATE TABLE `order_payments` (
  `id` bigint(20) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `order_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_payments`
--

INSERT INTO `order_payments` (`id`, `payment_method`, `amount`, `transaction_id`, `is_active`, `created_at`, `updated_at`, `order_id`) VALUES
(1, 'SSL', 6366.00, '57fa80af-cd5e-4e2f-ba62-0fcc3a6d5b6f', 1, '2025-07-26 19:04:05.001936', '2025-07-26 19:04:05.001949', 14),
(2, 'SSL', 3000.00, '767da4be-1ae2-4c3d-8cb8-9566d2b92954', 1, '2025-07-26 19:05:37.145727', '2025-07-26 19:05:37.145741', 15);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` bigint(20) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_slug` varchar(100) NOT NULL,
  `product_image` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `is_featured` tinyint(1) NOT NULL,
  `total_views` int(11) NOT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `main_category_id` bigint(20) NOT NULL,
  `sub_category_id` bigint(20) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `discount_price` decimal(5,2) DEFAULT NULL,
  `discount_percentage` int(10) UNSIGNED DEFAULT NULL CHECK (`discount_percentage` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `product_name`, `product_slug`, `product_image`, `price`, `stock`, `is_featured`, `total_views`, `description`, `created_at`, `updated_at`, `is_active`, `created_by_id`, `main_category_id`, `sub_category_id`, `updated_by_id`, `discount_price`, `discount_percentage`) VALUES
(1, 'sonagaon_chair', 'sonagaon_chair', 'ecommerce/product_images/2e3.png', 1000.00, 7, 1, 4, 'this is test description', '2025-07-21 19:17:35.535068', NULL, 1, 1, 1, 1, NULL, 0.00, 0),
(2, 'confy chair', 'confy-chair', '', 123.00, 22, 1, 0, '124fasdfasfasf', '2025-07-22 09:20:49.675361', NULL, 1, 1, 1, 1, NULL, 10.00, 0),
(3, 'Mama chair', 'mama-chair', '', 222.00, 5, 1, 0, 'olalalallalalal', '2025-07-22 09:21:21.438625', NULL, 1, 1, 1, 1, NULL, 10.00, 0),
(4, 'hululu222', 'hululu-chair', 'ecommerce/product_images/logintask.png', 2122.00, 0, 1, 0, 'sdaflknjkdsvnkjbs 22', '2025-07-22 10:11:08.984282', NULL, 1, 1, 1, 1, 1, NULL, 102),
(5, 'WOWOW', 'OWOWO', '', 0.15, 9, 1, 0, 'LOLU PRODUCT SHEI MAN', '2025-07-22 16:10:59.627990', NULL, 1, 1, 2, 1, NULL, 0.00, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `id` bigint(20) NOT NULL,
  `main_cat_name` varchar(100) NOT NULL,
  `cat_slug` varchar(100) NOT NULL,
  `cat_image` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `cat_ordering` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `updated_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_category`
--

INSERT INTO `product_category` (`id`, `main_cat_name`, `cat_slug`, `cat_image`, `description`, `cat_ordering`, `created_at`, `updated_at`, `is_active`, `created_by_id`, `updated_by_id`) VALUES
(1, 'Living room', 'living-room', 'ecommerce/category_images/Screenshot_2025-07-15_162151.png', 'fasfas', 1, '2025-07-20 19:34:15.055177', NULL, 1, 1, NULL),
(2, 'Dining', 'Dining', 'ecommerce/category_images/2e3.png', 'Dining is awsome', 2, '2025-07-22 09:00:32.391177', NULL, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sub_product_category`
--

CREATE TABLE `sub_product_category` (
  `id` bigint(20) NOT NULL,
  `sub_cat_name` varchar(100) NOT NULL,
  `sub_cat_slug` varchar(100) NOT NULL,
  `sub_cat_image` varchar(100) DEFAULT NULL,
  `sub_cat_ordering` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `main_category_id` bigint(20) NOT NULL,
  `updated_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_product_category`
--

INSERT INTO `sub_product_category` (`id`, `sub_cat_name`, `sub_cat_slug`, `sub_cat_image`, `sub_cat_ordering`, `created_at`, `updated_at`, `is_active`, `created_by_id`, `main_category_id`, `updated_by_id`) VALUES
(1, 'Sofa', 'sofa', 'ecommerce/sub_category_images/registration_view.png', 1, '2025-07-21 11:00:17.384525', NULL, 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_permission`
--

CREATE TABLE `user_permission` (
  `id` bigint(20) NOT NULL,
  `can_view` tinyint(1) NOT NULL,
  `can_add` tinyint(1) NOT NULL,
  `can_update` tinyint(1) NOT NULL,
  `can_delete` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `deleted_by_id` int(11) DEFAULT NULL,
  `menu_id` bigint(20) NOT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `ecom_app_customer`
--
ALTER TABLE `ecom_app_customer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `ecom_app_emailotp`
--
ALTER TABLE `ecom_app_emailotp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_list`
--
ALTER TABLE `menu_list`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `menu_name` (`menu_name`),
  ADD UNIQUE KEY `menu_url` (`menu_url`),
  ADD KEY `menu_list_created_by_id_37c8f718_fk_auth_user_id` (`created_by_id`),
  ADD KEY `menu_list_module_name_b77fdeda` (`module_name`);

--
-- Indexes for table `online_payment_request`
--
ALTER TABLE `online_payment_request`
  ADD PRIMARY KEY (`id`),
  ADD KEY `online_payment_request_created_by_id_037bf7d6_fk_auth_user_id` (`created_by_id`),
  ADD KEY `online_payment_request_order_id_b82b2d74_fk_orders_id` (`order_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_customer_id_b7016332_fk_ecom_app_customer_id` (`customer_id`);

--
-- Indexes for table `order_cart`
--
ALTER TABLE `order_cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_cart_customer_id_6237d072_fk_ecom_app_customer_id` (`customer_id`),
  ADD KEY `order_cart_product_id_f972b785_fk_product_id` (`product_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_details_order_id_9401d97b_fk_orders_id` (`order_id`),
  ADD KEY `order_details_product_id_a3b1bac1_fk_product_id` (`product_id`);

--
-- Indexes for table `order_payments`
--
ALTER TABLE `order_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_payments_order_id_e4609447_fk_orders_id` (`order_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_name` (`product_name`),
  ADD UNIQUE KEY `product_slug` (`product_slug`),
  ADD KEY `product_created_by_id_0baf418a_fk_auth_user_id` (`created_by_id`),
  ADD KEY `product_main_category_id_fada477c_fk_product_category_id` (`main_category_id`),
  ADD KEY `product_sub_category_id_969ff5f9_fk_sub_product_category_id` (`sub_category_id`),
  ADD KEY `product_updated_by_id_f384b7dc_fk_auth_user_id` (`updated_by_id`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `main_cat_name` (`main_cat_name`),
  ADD UNIQUE KEY `cat_slug` (`cat_slug`),
  ADD KEY `product_category_created_by_id_f48672df_fk_auth_user_id` (`created_by_id`),
  ADD KEY `product_category_updated_by_id_ba9db67e_fk_auth_user_id` (`updated_by_id`);

--
-- Indexes for table `sub_product_category`
--
ALTER TABLE `sub_product_category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sub_cat_name` (`sub_cat_name`),
  ADD UNIQUE KEY `sub_cat_slug` (`sub_cat_slug`),
  ADD KEY `sub_product_category_created_by_id_3729d57a_fk_auth_user_id` (`created_by_id`),
  ADD KEY `sub_product_category_main_category_id_eb41d195_fk_product_c` (`main_category_id`),
  ADD KEY `sub_product_category_updated_by_id_2cad2aa1_fk_auth_user_id` (`updated_by_id`);

--
-- Indexes for table `user_permission`
--
ALTER TABLE `user_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_permission_created_by_id_41746c1a_fk_auth_user_id` (`created_by_id`),
  ADD KEY `user_permission_deleted_by_id_b8a40ecc_fk_auth_user_id` (`deleted_by_id`),
  ADD KEY `user_permission_menu_id_b02bb39b_fk_menu_list_id` (`menu_id`),
  ADD KEY `user_permission_updated_by_id_445bbdd4_fk_auth_user_id` (`updated_by_id`),
  ADD KEY `user_permission_user_id_094cc8c7_fk_auth_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `ecom_app_customer`
--
ALTER TABLE `ecom_app_customer`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `ecom_app_emailotp`
--
ALTER TABLE `ecom_app_emailotp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `menu_list`
--
ALTER TABLE `menu_list`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `online_payment_request`
--
ALTER TABLE `online_payment_request`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `order_cart`
--
ALTER TABLE `order_cart`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `order_payments`
--
ALTER TABLE `order_payments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_category`
--
ALTER TABLE `product_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sub_product_category`
--
ALTER TABLE `sub_product_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_permission`
--
ALTER TABLE `user_permission`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `ecom_app_customer`
--
ALTER TABLE `ecom_app_customer`
  ADD CONSTRAINT `ecom_app_customer_user_id_5523d2d4_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `menu_list`
--
ALTER TABLE `menu_list`
  ADD CONSTRAINT `menu_list_created_by_id_37c8f718_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `online_payment_request`
--
ALTER TABLE `online_payment_request`
  ADD CONSTRAINT `online_payment_request_created_by_id_037bf7d6_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `online_payment_request_order_id_b82b2d74_fk_orders_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_customer_id_b7016332_fk_ecom_app_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `ecom_app_customer` (`id`);

--
-- Constraints for table `order_cart`
--
ALTER TABLE `order_cart`
  ADD CONSTRAINT `order_cart_customer_id_6237d072_fk_ecom_app_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `ecom_app_customer` (`id`),
  ADD CONSTRAINT `order_cart_product_id_f972b785_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_order_id_9401d97b_fk_orders_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_details_product_id_a3b1bac1_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `order_payments`
--
ALTER TABLE `order_payments`
  ADD CONSTRAINT `order_payments_order_id_e4609447_fk_orders_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_created_by_id_0baf418a_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `product_main_category_id_fada477c_fk_product_category_id` FOREIGN KEY (`main_category_id`) REFERENCES `product_category` (`id`),
  ADD CONSTRAINT `product_sub_category_id_969ff5f9_fk_sub_product_category_id` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_product_category` (`id`),
  ADD CONSTRAINT `product_updated_by_id_f384b7dc_fk_auth_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `product_category`
--
ALTER TABLE `product_category`
  ADD CONSTRAINT `product_category_created_by_id_f48672df_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `product_category_updated_by_id_ba9db67e_fk_auth_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `sub_product_category`
--
ALTER TABLE `sub_product_category`
  ADD CONSTRAINT `sub_product_category_created_by_id_3729d57a_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `sub_product_category_main_category_id_eb41d195_fk_product_c` FOREIGN KEY (`main_category_id`) REFERENCES `product_category` (`id`),
  ADD CONSTRAINT `sub_product_category_updated_by_id_2cad2aa1_fk_auth_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `user_permission`
--
ALTER TABLE `user_permission`
  ADD CONSTRAINT `user_permission_created_by_id_41746c1a_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `user_permission_deleted_by_id_b8a40ecc_fk_auth_user_id` FOREIGN KEY (`deleted_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `user_permission_menu_id_b02bb39b_fk_menu_list_id` FOREIGN KEY (`menu_id`) REFERENCES `menu_list` (`id`),
  ADD CONSTRAINT `user_permission_updated_by_id_445bbdd4_fk_auth_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `user_permission_user_id_094cc8c7_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
