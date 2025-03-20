import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/link_model.dart';

class AppConstants {
  static const String appName = 'ClickMe';
  static const String appDescription = 'Conecta conmigo a través de mis redes sociales';
  
  static List<LinkModel> socialLinks = [
    LinkModel(
      title: 'GitHub',
      url: 'https://github.com/danielpg10',
      icon: FontAwesomeIcons.github,
      color: const Color(0xFF24292E),
      description: 'Revisa mis repositorios de código',
      detailText: 'danielpg10',
    ),
    LinkModel(
      title: 'Portfolio',
      url: 'https://portafolio-85235.web.app/',
      icon: FontAwesomeIcons.briefcase,
      color: const Color(0xFF6C63FF),
      description: 'Mira mi trabajo profesional',
      detailText: 'https://portafolio-85235.web.app/',
    ),
    LinkModel(
      title: 'LinkedIn',
      url: 'https://www.linkedin.com/in/marlon-daniel-portuguez-gomez-65271231a/',
      icon: FontAwesomeIcons.linkedin,
      color: const Color(0xFF0077B5),
      description: 'Conéctate conmigo profesionalmente',
      detailText: 'Marlon Daniel Portuguez Gomez',
    ),
    LinkModel(
      title: 'Email',
      url: 'https://mail.google.com/mail/?view=cm&fs=1&to=danielpg2020md@gmail.com',
      icon: FontAwesomeIcons.envelope,
      color: const Color(0xFFEA4335),
      description: 'Envíame un correo',
      detailText: 'danielpg2020md@gmail.com',
    ),
  ];
}