import 'package:flutter/material.dart';

class LinkModel {
  final String title;
  final String url;
  final IconData icon;
  final Color color;
  final String? description;
  final String? detailText;

  LinkModel({
    required this.title,
    required this.url,
    required this.icon,
    required this.color,
    this.description,
    this.detailText,
  });
}