import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/screen/auth/auth.dart';
import 'package:ecommerce_app/screen/order/order.dart';
import 'package:ecommerce_app/screen/profile/bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc? bloc;

  @override
  void initState() {
    AuthRepositoryImpl.authChangeNotifier
        .addListener(authChangeNotifyChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    AuthRepositoryImpl.authChangeNotifier
        .removeListener(authChangeNotifyChangeListener);
    bloc?.close();
    super.dispose();
  }

  void authChangeNotifyChangeListener() {
    bloc?.add(
      ProfileAuthChanged(AuthRepositoryImpl.authChangeNotifier.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'پروفایل',
          style: TextStyle(
            fontSize: 18,
            fontFamily: faPrimaryFontFamily,
            color: themeData.colorScheme.secondary,
          ),
        ),
        leading: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.arrow_right,
            color: themeData.colorScheme.secondary,
          ),
        ),
        backgroundColor: themeData.colorScheme.surface,
      ),
      body: Center(
        child: BlocProvider<ProfileBloc>(
          create: (context) {
            bloc = ProfileBloc(
              context.read<AuthRepository>(),
            )..add(
                ProfileStarted(AuthRepositoryImpl.authChangeNotifier.value),
              );
            return bloc!;
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 32, bottom: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeData.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      'assets/img/nike_logo.png',
                    ),
                  ),
                  Text(state is ProfileUserState
                      ? state.username
                      : 'کاربر مهمان'),
                  const SizedBox(
                    height: 32,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  rowContainerItem(
                    text: 'لیست علاقه مندی ها',
                    iconData: CupertinoIcons.heart,
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                  ),
                  if (state is ProfileUserState)
                    rowContainerItem(
                      text: 'سوابق سفارش',
                      iconData: CupertinoIcons.cart,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen(),
                          ),
                        );
                      },
                    ),
                  if (state is ProfileUserState)
                    const Divider(
                      height: 1,
                    ),
                  rowContainerItem(
                    text: state is ProfileUserState
                        ? 'خروج از حساب کاربری'
                        : 'ورود به حساب کاربری',
                    iconData: state is ProfileUserState
                        ? CupertinoIcons.arrow_right_square
                        : CupertinoIcons.arrow_left_square,
                    onTap: () {
                      state is ProfileUserState
                          ? showExitDialog(
                              context: context,
                              onOKClicked: (context) {
                                Navigator.pop(context);
                                bloc?.add(ProfileSignOut());
                              },
                              onCancelClicked: (context) {
                                Navigator.pop(context);
                              },
                            )
                          : Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                    },
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> showExitDialog({
    required BuildContext context,
    required Function(BuildContext) onOKClicked,
    required Function(BuildContext) onCancelClicked,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text('خروج از حساب کاربری'),
              content: const Text('آیا میخواهید از حساب کاربری خود خارج شوید؟'),
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8),
              actions: [
                TextButton(
                    onPressed: () {
                      onCancelClicked(context);
                    },
                    child: const Text('خیر')),
                TextButton(
                    onPressed: () {
                      onOKClicked(context);
                    },
                    child: const Text('بله')),
              ],
            ),
          );
        });
  }

  Widget rowContainerItem({
    required String text,
    required Function() onTap,
    required IconData iconData,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(iconData),
              const SizedBox(
                width: 16,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
