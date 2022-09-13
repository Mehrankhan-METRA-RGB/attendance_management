import 'package:flutter/material.dart';

/// This acts as a data holder to provide [icon] and [label]
class NavItem {
  /// The [IconData] you want to display
  final IconData icon;

  /// Information about the navigatable route
  final String label;
  const NavItem({required this.icon, required this.label});
}
