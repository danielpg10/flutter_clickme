import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Container(
            width: isDesktop ? 180 : 120,
            height: isDesktop ? 180 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/img/avatar - 01.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Marlon Daniel Portuguez Gomez',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Full-Stack Developer | Web & Apps',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}