import 'package:flutter/material.dart';

/// Small runtime localization table for English and Arabic.
class AppStrings {
  AppStrings(this.locale);
  final Locale locale;
  bool get isArabic => locale.languageCode == 'ar';
  String t(String key) => (isArabic ? _ar : _en)[key] ?? _en[key] ?? key;
  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();
  static const Map<String, String> _en = {
    'appName': 'Laza Shop',
    'welcome': 'Create your account',
    'fullName': 'Full name',
    'email': 'Email address',
    'password': 'Password',
    'confirmPassword': 'Confirm password',
    'createAccount': 'Create account',
    'nameError': 'Enter a name starting with a capital letter.',
    'emailError': 'Enter a valid email address.',
    'passwordError': 'Password must be at least 6 characters.',
    'confirmError': 'Passwords do not match.',
    'accountCreated': 'Account created successfully',
    'continue': 'Continue',
    'products': 'Products',
    'addToCart': 'Add to cart',
    'added': 'Item added to cart',
    'details': 'Product details',
    'category': 'Category',
    'description': 'Description',
    'cart': 'My cart',
    'emptyCart': 'Your cart is empty',
    'remove': 'Remove',
    'total': 'Total',
    'checkout': 'Checkout',
    'emptyNotice': 'Your cart is now empty.',
    'loadError': 'Could not load products. Check your connection and try again.',
    'retry': 'Try again',
    'language': 'Switch language',
    'theme': 'Switch theme',
    'noProducts': 'No products found.',
    'cachedNotice': 'Showing saved products while offline.',
    'welcomeBack': 'Find your style',
    'hotOffers': 'Hot offers',
    'signUpSubtitle': 'Join Laza for a better shopping experience.',
    'clearCart': 'Clear cart',
    'invalidProduct': 'The selected product could not be opened.',
    'continueMessage': 'Your shopping journey is ready to begin.',
    'togglePasswordVisibility': 'Toggle password visibility',
    'checkoutDemo': 'Checkout is a demo and does not process a payment.',
  };
  static const Map<String, String> _ar = {
    'appName': 'لازا شوب',
    'welcome': 'أنشئ حسابك',
    'fullName': 'الاسم الكامل',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'confirmPassword': 'تأكيد كلمة المرور',
    'createAccount': 'إنشاء الحساب',
    'nameError': 'أدخل اسمًا يبدأ بحرف كبير.',
    'emailError': 'أدخل بريدًا إلكترونيًا صحيحًا.',
    'passwordError': 'يجب ألا تقل كلمة المرور عن 6 أحرف.',
    'confirmError': 'كلمتا المرور غير متطابقتين.',
    'accountCreated': 'تم إنشاء الحساب بنجاح',
    'continue': 'متابعة',
    'products': 'المنتجات',
    'addToCart': 'أضف إلى السلة',
    'added': 'تمت إضافة المنتج إلى السلة',
    'details': 'تفاصيل المنتج',
    'category': 'الفئة',
    'description': 'الوصف',
    'cart': 'سلتي',
    'emptyCart': 'سلتك فارغة',
    'remove': 'إزالة',
    'total': 'الإجمالي',
    'checkout': 'إتمام الشراء',
    'emptyNotice': 'أصبحت سلتك فارغة الآن.',
    'loadError': 'تعذر تحميل المنتجات. تحقق من اتصالك وحاول مرة أخرى.',
    'retry': 'إعادة المحاولة',
    'language': 'تغيير اللغة',
    'theme': 'تغيير المظهر',
    'noProducts': 'لا توجد منتجات.',
    'cachedNotice': 'يتم عرض المنتجات المحفوظة دون اتصال.',
    'welcomeBack': 'اكتشف أسلوبك',
    'hotOffers': 'عروض مميزة',
    'signUpSubtitle': 'انضم إلى لازا لتجربة تسوق أفضل.',
    'clearCart': 'إفراغ السلة',
    'invalidProduct': 'تعذر فتح المنتج المحدد.',
    'continueMessage': 'أصبح بإمكانك البدء بالتسوق الآن.',
    'togglePasswordVisibility': 'إظهار أو إخفاء كلمة المرور',
    'checkoutDemo': 'إتمام الشراء تجريبي ولا يعالج أي دفعة.',
  };
}
class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();
  @override bool isSupported(Locale locale) => ['en','ar'].contains(locale.languageCode);
  @override Future<AppStrings> load(Locale locale) async => AppStrings(locale);
  @override bool shouldReload(_AppStringsDelegate old) => false;
}
extension AppStringsContext on BuildContext {
  AppStrings get strings => Localizations.of<AppStrings>(this, AppStrings)!;
}
