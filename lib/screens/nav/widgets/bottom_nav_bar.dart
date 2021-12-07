import 'package:flutter/material.dart';

import 'package:instagram_app/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItems;
  final Function(int) onTap;

  const BottomNavBar({
    Key key,
    @required this.items,
    @required this.selectedItems,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      currentIndex: BottomNavItem.values.indexOf(selectedItems),
      items: items
          .map(
            (item, icon) => MapEntry(
              item.toString(),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  icon,
                  size: 30,
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
