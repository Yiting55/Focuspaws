import 'package:flutter/material.dart';

class FoodItem {
  final IconData icon;
  final String level;
  final int quantity;
  final DateTime expiryDate;

  FoodItem({
    required this.icon,
    required this.level,
    required this.quantity,
    required this.expiryDate,
  });
}