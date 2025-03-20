import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/profile_header.dart';
import '../widgets/link_carousel.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.link,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ClickMe',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const ProfileHeader(),
                Container(
                  height: isDesktop ? 450 : 350,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20),
                  child: LinkCarousel(links: AppConstants.socialLinks),
                ),
                const SizedBox(height: 40),
                Text(
                  '© ${DateTime.now().year} Marlon Daniel Portuguez Gomez',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}