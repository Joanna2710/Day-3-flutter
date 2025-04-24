import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'start_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Manage your tasks',
      description: 'You can easily manage all of your daily tasks in DoMe for free',
      image: 'assets/images/Group 182.png',
    ),
    OnboardingContent(
      title: 'Create daily routine',
      description: 'In Uptodo, you can create your personalized routine to stay productive',
      image: 'assets/images/Frame 162.png',
    ),
    OnboardingContent(
      title: 'Organize your tasks',
      description: 'You can organize your daily tasks by adding your tasks into separate categories',
      image: 'assets/images/Frame 161.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const StartScreen()),
                      );
                    },
                    child: const Text(
                      'SKIP',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  _currentPage == 2
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            '',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            _contents[index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _contents.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: Color(0xFF8875FF),
                            dotColor: Colors.grey,
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _contents[index].title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _contents[index].description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage == 0
                      ? const SizedBox(width: 60)
                      : TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            'BACK',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                  _currentPage == 2
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const StartScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 50),
                          ),
                          child: const Text('GET STARTED'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 50),
                          ),
                          child: const Text('NEXT'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
