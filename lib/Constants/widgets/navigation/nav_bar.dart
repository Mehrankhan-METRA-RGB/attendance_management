import 'package:flutter/material.dart';

import 'nav_bar_item.dart';
import 'nav_bar_tile.dart';
/// Takes the data from [items] and builds [NavItemTile] with it.
///
/// [selectedIndex] is handled by the user. It defines what item of the navigation
/// options is currently selected.
///
/// Use [onTap] to provide a callback that [selectedIndex] has changed.
///
class NavBar extends StatefulWidget {
  /// The current index of the navigation bar
  final int selectedIndex;

  /// The items to put into the bar
  final List<NavItem> items;

  /// What to do when an item as been tapped
  final ValueChanged<int> onTap;

  /// The background [Color] of the [NavBar]. If nothing or null is passed it defaults to the
  /// color of the parent container
  final Color? color;

  /// The [Color] of an selected [NavItem]. If nothing or null is passed it defaults to
  /// Colors.blue[200]
  final Color? selectedItemColor;

  /// Specifies wheter that [NavBar] is expanded or not. Default is true
  final bool expandable;

  /// The [IconData] to use when building the button to toggle [expanded]
  final IconData expandIcon;
  final IconData shrinkIcon;
  const NavBar(
      {Key? key,
        required this.selectedIndex,
        required this.items,
        required this.onTap,
        this.color,
        this.selectedItemColor,
        this.expandable = true,
        this.expandIcon = Icons.arrow_right,
        this.shrinkIcon = Icons.arrow_left})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();

  static _NavBarState of(BuildContext context) =>
      context.findAncestorStateOfType<_NavBarState>()!;
}

class _NavBarState extends State<NavBar>
    with SingleTickerProviderStateMixin {
  final double minWidth = 50;
  final double maxWidth = 200;
  late double width;

  bool expanded = true;

  @override
  void initState() {
    super.initState();
    width = maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        // border: Border(
        //   right: BorderSide(
        //     width: 0,
        //     color: MediaQuery.of(context).platformBrightness == Brightness.light
        //         ? Colors.black54
        //         : Colors.white,
        //   ),
        // ),
      ),
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
        vsync: this,
        child: SizedBox(
            width: width,
            height: double.infinity,
            child: Column(
              children: [
                // Header
                // TODO: implement header
                // Navigation content
                Expanded(
                  child:  Column(
                      children: _generateItems(expanded),
                    ),

                ),
                // Toggler widget (Footer)
                widget.expandable
                    ? Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(maxWidth:width,maxHeight: 40 ),
                      child: Icon(
                          expanded ? widget.shrinkIcon : widget.expandIcon),
                    ),
                    onPressed: () {
                      setState(() {
                        if (expanded) {
                          width = minWidth;
                        } else {
                          width = maxWidth;
                        }
                        expanded = !expanded;
                      });
                    },
                  ),
                )
                    : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(),
                ),
              ],
            )),
      ),
    );
  }

  /// Takes [NavItem] data and builds new widgets with it.
  List<Widget> _generateItems(final bool _expanded) {
    List<Widget> _items = widget.items
        .asMap()
        .entries
        .map<NavItemTile>(
            (MapEntry<int, NavItem> entry) {
          return NavItemTile(
              icon: entry.value.icon,
              label: entry.value.label,
              onTap: widget.onTap,
              index: entry.key,
              expanded: expanded,
              color: _validateSelectedItemColor());
        }).toList();
    return _items;
  }

  /// Checks what was passed as [widget.selectedItemColor]
  /// If nothing was passed return the default value
  /// If a color was passed use that
  Color _validateSelectedItemColor() {
    final Color? color;
    if (widget.selectedItemColor == null) {
      color = Colors.blue[200]!;
    } else {
      color = widget.selectedItemColor!;
    }
    return color;
  }
}
