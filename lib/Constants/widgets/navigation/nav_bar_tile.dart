import 'package:flutter/material.dart';

import 'nav_bar.dart';
import 'nav_bar_item.dart';
/// This widget uses the [icon] and [label] value from the [NavItem]
/// to generate a completely new widget which provides an [onTap] callback while
/// it also holds the [index] of its position defined in the [NavBar]'s
/// [NavBar.items]
class NavItemTile extends StatefulWidget {
  /// From [NavItem]
  /// What [IconData] to display
  final IconData icon;

  /// From [NavItem]
  /// Info text about the choosable navigation option
  final String label;

  /// From [NavBar]
  /// What to do on item tap
  final ValueChanged<int> onTap;

  /// From [NavBar]
  /// The currently selected index which the end user chooses
  final int index;

  final Color color;
  final bool expanded;
  const NavItemTile(
      {Key? key,
        required this.icon,
        required this.label,
        required this.onTap,
        required this.index,
        required this.color,
        required this.expanded})
      : super(key: key);

  @override
  _NavItemTileState createState() =>
      _NavItemTileState();
}

class _NavItemTileState extends State<NavItemTile> {
  @override
  Widget build(BuildContext context) {
    // Get the data holders from the parent
    final List<NavItem> barItems =
        NavBar.of(context).widget.items;
    // Get the current selected index from the parent
    final int selectedIndex =
        NavBar.of(context).widget.selectedIndex;
    // Check if this tile is selected
    final bool isSelected = isTileSelected(barItems, selectedIndex);

    /// Return a basic listtile for now
    return widget.expanded
        ? ListTile(
tileColor: isSelected?Colors.white24:null,
      leading: Icon(
        widget.icon,
        color: getTileColor(isSelected),
      ),
      title: Text(
        widget.label,
        style: TextStyle(
          color: getTileColor(isSelected),
        ),
      ),
      onTap: () {
        widget.onTap(widget.index);
      },
    )
        : IconButton(
      icon: Icon(
        widget.icon,
        color: getTileColor(isSelected),
      ),
      onPressed: () {
        widget.onTap(widget.index);
      },
    );
  }

  /// Determines if this tile is currently selected
  ///
  /// Looks at the both item labels to compare wheter they are equal
  /// and compares the parents [index] with this tiles index
  bool isTileSelected(
      final List<NavItem> items, final int index) {
    for (final NavItem item in items) {
      if (item.label == widget.label && index == widget.index) {
        return true;
      }
    }
    return false;
  }

  /// Check if this item [isSelected] and return the passed [widget.color]
  /// If it is not selected return either [Colors.white] or [Colors.grey] based on the
  /// [Brightness]
  Color getTileColor(final bool isSelected) {
    return isSelected
        ? widget.color
        : (Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey);
  }
}
