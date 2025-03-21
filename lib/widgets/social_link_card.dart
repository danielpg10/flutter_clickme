import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/link_model.dart';

class SocialLinkCard extends StatefulWidget {
  final LinkModel link;
  final bool isCurrentItem;
  
  const SocialLinkCard({
    Key? key,
    required this.link,
    this.isCurrentItem = false,
  }) : super(key: key);

  @override
  State<SocialLinkCard> createState() => _SocialLinkCardState();
}

class _SocialLinkCardState extends State<SocialLinkCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;
  bool isLowPerformanceDevice = false;
  
  @override
  void initState() {
    super.initState();
    
    if (!kIsWeb) {
      isLowPerformanceDevice = Platform.isAndroid || Platform.isIOS;
    }
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.link.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String _getDetailText() {
    switch (widget.link.title) {
      case 'LinkedIn':
        return 'Marlon Daniel Portuguez Gomez';
      case 'Email':
        return 'danielpg2020md@gmail.com';
      case 'Portfolio':
        return 'https://portafolio-85235.web.app/';
      case 'GitHub':
        return 'danielpg10';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;
    
    Widget cardContent = Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isDesktop ? 25 : 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.link.color.withOpacity(0.5),
                  blurRadius: isLowPerformanceDevice ? 10 : 20,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              widget.link.icon,
              color: Colors.white,
              size: isDesktop ? 50 : 35,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            _getTitleInSpanish(widget.link.title),
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
              thickness: 1,
            ),
          ),
          
          if (isDesktop || widget.isCurrentItem)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _getDetailText(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: isDesktop ? 14 : 12,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.link.color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
    
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: _launchUrl,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: isDesktop ? 300 : double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.125),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.link.color.withOpacity(0.3),
                  blurRadius: isLowPerformanceDevice ? 10 : 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isLowPerformanceDevice
                ? Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(17, 25, 40, 0.85),
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.link.color.withOpacity(0.4),
                          widget.link.color.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: isDesktop ? 0.85 : 1.0,
                      child: cardContent,
                    ),
                  )
                : BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(17, 25, 40, 0.7),
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.link.color.withOpacity(0.3),
                            widget.link.color.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: isDesktop ? 0.85 : 1.0,
                        child: cardContent,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _getTitleInSpanish(String title) {
    switch (title) {
      case 'GitHub':
        return 'GitHub';
      case 'Portfolio':
        return 'Portafolio';
      case 'LinkedIn':
        return 'LinkedIn';
      case 'Email':
        return 'Correo';
      default:
        return title;
    }
  }
}