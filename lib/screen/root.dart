import 'package:ecommerce_app/component/widget/badge.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/screen/cart/cart.dart';
import 'package:ecommerce_app/screen/home/home_screen.dart';
import 'package:ecommerce_app/screen/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const homePageIndex = 0;
const cartPageIndex = 1;
const profilePageIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndexPage = homePageIndex;
  bool lastPageIsSelected = false;
  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  final List<int> _history = [];

  late final keyMap = {
    homePageIndex: _homeKey,
    cartPageIndex: _cartKey,
    profilePageIndex: _profileKey,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndexPage,
          children: [
            _navigatorItem(_homeKey, homePageIndex, const HomeScreen()),
            _navigatorItem(_cartKey, cartPageIndex, const CartScreen()),
            _navigatorItem(
                _profileKey, profilePageIndex, const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: 'خانه'),
            BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cart),
                    Positioned(
                        right: -10,
                        child: ValueListenableBuilder<int>(
                            valueListenable:
                                CartRepositoryImpl.countItemNotifier,
                            builder: (context, value, child) {
                              return Badge(value: value);
                            })),
                  ],
                ),
                label: 'سبد خرید'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
          ],
          currentIndex: selectedIndexPage,
          onTap: (index) {
            setState(() {
              _history.remove(selectedIndexPage);
              _history.add(selectedIndexPage);
              selectedIndexPage = index;
            });
          },
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectNavigatorState =
        keyMap[selectedIndexPage]!.currentState!;
    if (currentSelectNavigatorState.canPop()) {
      currentSelectNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedIndexPage = _history.last;
        _history.removeLast();
      });
      return false;
    } else if (_history.isEmpty &&
        !lastPageIsSelected &&
        selectedIndexPage != homePageIndex) {
      setState(() {
        selectedIndexPage = homePageIndex;
        lastPageIsSelected = true;
      });
      return false;
    }
    return true;
  }

  Widget _navigatorItem(GlobalKey key, int index, Widget child) {
    return key.currentState == null && index != selectedIndexPage
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (setting) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedIndexPage != index, child: child)),
          );
  }

  @override
  void initState() {
    context.read<AuthRepository>().loadTokenFromDb().then((value) {
      if (AuthRepositoryImpl.authChangeNotifier.value != null &&
          AuthRepositoryImpl.authChangeNotifier.value!.accessToken.isNotEmpty) {
        context.read<CartRepository>().getAllCountItem();
      }
    });

    super.initState();
  }
}
