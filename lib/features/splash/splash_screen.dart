import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/core/storage/storage_service.dart';
import 'package:cr_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    final bool isLoggedIn = StorageService.containsKey(Constants.keyAuthToken);
    
    if (isLoggedIn) {
      AppRouter.go('/main');
    } else {
      AppRouter.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.dark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: UColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(
                  Constants.appLogo,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                Constants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Your Academic Companion",
                style: TextStyle(
                  color: UColors.textSecondary,
                  fontSize: 14.sp,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
