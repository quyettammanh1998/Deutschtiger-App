import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Landing/Onboarding Screen for mobile
class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _features = [
    _FeatureData(
      icon: '🎯',
      title: 'Học theo mục tiêu',
      description: 'Từ vựng được phân loại theo mục đích sử dụng: du lịch, công việc, y tế...',
    ),
    _FeatureData(
      icon: '🎮',
      title: 'Học qua trò chơi',
      description: '15+ trò chơi học tiếng Đức giúp bạn ghi nhớ từ vựng một cách tự nhiên.',
    ),
    _FeatureData(
      icon: '📚',
      title: 'Khoá học DW',
      description: 'Học tiếng Đức từ Deutsche Welle với video và bài tập tương tác.',
    ),
    _FeatureData(
      icon: '🎯',
      title: 'Luyện thi Goethe',
      description: 'Chuẩn bị cho kỳ thi Goethe với bài tập ngữ pháp, từ vựng và luyện viết.',
    ),
    _FeatureData(
      icon: '🗣️',
      title: 'Luyện phát âm',
      description: 'Cải thiện phát âm với AI và các bài tập luyện nói.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _goToHome(context),
                child: const Text('Bỏ qua'),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _features.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _FeaturePage(feature: _features[index]);
                },
              ),
            ),
            
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _features.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _features.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _goToHome(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _features.length - 1 ? 'Tiếp tục' : 'Bắt đầu học',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });
  
  final String icon;
  final String title;
  final String description;
}

class _FeaturePage extends StatelessWidget {
  const _FeaturePage({required this.feature});
  final _FeatureData feature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                feature.icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          Text(
            feature.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Welcome Screen (for logged out users)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    '🇩🇪',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Deutschtiger',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Học tiếng Đức hiệu quả',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              
              const Spacer(),
              
              // Google Sign In button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google Sign In
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Đăng nhập với Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Email Sign In
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Đăng nhập / Đăng ký'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue without account
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Tiếp tục không cần tài khoản'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
