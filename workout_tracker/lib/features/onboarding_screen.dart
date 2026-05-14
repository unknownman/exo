import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions.dart';
import '../core/app_providers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPageData(
      icon: Icons.fitness_center,
      title: 'به ردیاب تمرین خوش آمدی!',
      subtitle: 'برنامه‌های تمرینی حرفه‌ای بساز\nو پیشرفت خودت رو دنبال کن',
      color: Colors.indigo,
    ),
    _OnboardingPageData(
      icon: Icons.calendar_view_week,
      title: 'برنامه‌ریزی هوشمند',
      subtitle: 'روزهای تمرینی رو مشخص کن\nو تمرینات هر روز رو برنامه‌ریزی ببین',
      color: Colors.green,
    ),
    _OnboardingPageData(
      icon: Icons.timer,
      title: 'تمرین کن و پیشرفت کن',
      subtitle: 'تایمر تمرین، زمان استراحت\nو تاریخچه کامل تمریناتت',
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await setOnboardingComplete();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) {
                  setState(() => _currentPage = i);
                  _animController.reset();
                  _animController.forward();
                },
                itemCount: _pages.length,
                itemBuilder: (_, i) => _buildPage(_pages[i], cs),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? cs.primary
                              : cs.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _nextPage,
                    icon: Icon(
                      _currentPage == _pages.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentPage == _pages.length - 1
                          ? 'شروع کن!'
                          : 'ادامه',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        'رد کردن',
                        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPageData page, ColorScheme cs) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (_, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(page.icon, size: 72, color: page.color),
            ),
            const SizedBox(height: 40),
            Text(
              page.title,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              page.subtitle,
              style: context.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
