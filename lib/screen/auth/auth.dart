import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/gen/assets.gen.dart';
import 'package:ecommerce_app/screen/auth/bloc/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const Color onBackground = Colors.white;
    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: Colors.white.withOpacity(0.6),
          labelStyle: TextStyle(
            color: onBackground.withOpacity(0.6),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeData.colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: onBackground.withOpacity(0.3),
            ),
          ),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final AuthBloc authBloc = AuthBloc(
                context.read<AuthRepository>(),
                context.read<CartRepository>(),
              );
              authBloc.stream.forEach((state) {
                if (state is AuthSuccessState) {
                  Navigator.pop(context);
                } else if (state is AuthErrorState) {
                  showSnackBar(context, message: state.error.message);
                }
              });
              authBloc.add(AuthStartedEvent());
              return authBloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 48, left: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoadingState ||
                      current is AuthErrorState ||
                      current is AuthInitialState;
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.img.nikeLogo.image(
                        width: 120,
                        color: onBackground,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        state.isLoginMode ? 'خوش آمدید' : 'ایجاد حساب کاربری',
                        style: themeData.textTheme.headline4!
                            .copyWith(color: onBackground),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        state.isLoginMode
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'ایمیل و رمز عبور خود را وارد کنید',
                        style: const TextStyle(
                          fontFamily: faPrimaryFontFamily,
                          color: onBackground,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: usernameController,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: faPrimaryFontFamily,
                            fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        cursorHeight: 18,
                        cursorColor: Colors.white,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          label: Text(
                            'ایمیل',
                            style: TextStyle(
                                fontSize: 16, fontFamily: faPrimaryFontFamily),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      PasswordTextField(
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      OutlinedButton(
                        onPressed: state is AuthLoadingState
                            ? null
                            : () async {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(AuthButtonIsClickedEvent(
                                  usernameController.text,
                                  passwordController.text,
                                ));
                              },
                        child: state is AuthLoadingState
                            ? CircularProgressIndicator(
                                color: themeData.colorScheme.secondary)
                            : Text(
                                state.isLoginMode ? 'ورود' : 'ثبت نام',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: faPrimaryFontFamily,
                                    fontWeight: FontWeight.w700,
                                    color: themeData.colorScheme.secondary),
                              ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                themeData.colorScheme.secondary),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            fixedSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width - 96, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ))),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isLoginMode
                                ? 'حساب کاربری دارید؟'
                                : 'قبلا ثبت نام کردید؟',
                            style: TextStyle(
                              fontFamily: faPrimaryFontFamily,
                              fontSize: 15,
                              color: onBackground.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthModeChangedIsClickedEvent());
                            },
                            child: Text(
                              state.isLoginMode ? 'ثبت نام' : 'ورود',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: faPrimaryFontFamily,
                                color: themeData.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          message,
          style: const TextStyle(
              fontFamily: faPrimaryFontFamily, color: Colors.white),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorHeight: 18,
      cursorColor: Colors.white,
      keyboardType: TextInputType.visiblePassword,
      maxLines: 1,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      style: const TextStyle(
          color: Colors.white, fontFamily: faPrimaryFontFamily, fontSize: 16),
      decoration: InputDecoration(
        label: const Text(
          'رمز عبور',
          style: TextStyle(fontSize: 16, fontFamily: faPrimaryFontFamily),
        ),
        suffixIcon: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(!obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined)),
      ),
    );
  }
}
