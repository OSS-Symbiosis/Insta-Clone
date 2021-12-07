import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/enums/enums.dart';
import 'package:instagram_app/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:instagram_app/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routename = '/nav';

  static Route route() {
    //This will make the screen on the top of splash screen
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  NavScreen({Key key}) : super(key: key);

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) => Scaffold(
          body: Stack(
            children: items
                .map(
                  (item, _) => MapEntry(
                    item,
                    _buildOffStageNavigator(item, item == state.selectedItem),
                  ),
                )
                .values
                .toList(),
          ),
          bottomNavigationBar: BottomNavBar(
            items: items,
            selectedItems: state.selectedItem,
            onTap: (index) {
              final selectedItem = BottomNavItem.values[index];
              _selectBottomNavItem(
                context,
                selectedItem,
                selectedItem == state.selectedItem,
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      //feed screen --> post's comments
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        item: currentItem,
      ),
    );
  }
}
