import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/link_model.dart';
import 'social_link_card.dart';

class LinkCarousel extends StatefulWidget {
  final List<LinkModel> links;
  
  const LinkCarousel({
    Key? key,
    required this.links,
  }) : super(key: key);

  @override
  State<LinkCarousel> createState() => _LinkCarouselState();
}

class _LinkCarouselState extends State<LinkCarousel> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;
    
    final extendedLinks = [...widget.links, ...widget.links, ...widget.links, ...widget.links, ...widget.links, ...widget.links, ...widget.links];
    
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: extendedLinks.length,
      itemBuilder: (context, index, realIndex) {
        final link = extendedLinks[index];
        final isCurrentItem = index % widget.links.length == _currentIndex;
        
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isCurrentItem ? _scaleAnimation.value : 0.9,
              child: Opacity(
                opacity: isCurrentItem ? 1.0 : 0.9,
                child: SocialLinkCard(
                  link: link, 
                  isCurrentItem: isCurrentItem,
                ),
              ),
            );
          },
        );
      },
      options: CarouselOptions(
        height: isDesktop ? 400 : 300,
        viewportFraction: isDesktop ? 0.26 : 0.65,
        initialPage: widget.links.length * 3,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(milliseconds: 2000),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOutCubic,
        enlargeCenterPage: true,
        enlargeFactor: isDesktop ? 0.15 : 0.2,
        scrollPhysics: const BouncingScrollPhysics(),
        pageSnapping: true,
        onPageChanged: (index, reason) {
          if (reason != CarouselPageChangedReason.controller) {
            _animationController.reset();
            _animationController.forward();
          }
          
          setState(() {
            _currentIndex = index % widget.links.length;
          });
        },
      ),
    );
  }
}