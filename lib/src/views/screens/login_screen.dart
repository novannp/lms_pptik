import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/features/auth/data/auth_repository.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:riverpod_lint/riverpod_lint.dart';

import '../../features/auth/provider/auth_notifier.dart';
import '../components/loading_widget.dart';

final obsecureProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/login.png'),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masuk',
                        style: poppins.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        onTap: () {
                          // Scroll to the bottom of the screen when TextFormField is tapped
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        controller: _usernameController,
                        cursorColor: Colors.black,
                        style: poppins.copyWith(fontSize: 12),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: blueForm,
                          hintText: 'Masukkan username',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onTap: () {
                          // Scroll to the bottom of the screen when TextFormField is tapped
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        controller: _passwordController,
                        cursorColor: Colors.black,
                        style: poppins.copyWith(fontSize: 12),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: ref.watch(obsecureProvider),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              ref.watch(obsecureProvider.notifier).state =
                                  !ref.watch(obsecureProvider.notifier).state;
                            },
                            child: const Icon(
                              Icons.visibility_outlined,
                              color: Color(0xffaaaaaa),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: blueForm,
                          hintText: 'Masukkan kata sandi',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Lupa Kata Sandi?',
                              style: poppins.copyWith(
                                fontSize: 12,
                                color: kPrimaryColor,
                              ),
                            )),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                            ),
                            onPressed: () async {
                              await auth.login(_usernameController.text,
                                  _passwordController.text);
                              if (auth.message == 'success') {
                                GoRouter.of(context)
                                    .pushReplacementNamed('main');
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  showCloseIcon: true,
                                  backgroundColor: Colors.red,
                                  content: Text(auth.message.toString()),
                                ));
                              }
                            },
                            child: ref.watch(loadingStateProvider)
                                ? Loading(
                                    color: Colors.white,
                                  )
                                : Text('Masuk'),
                          )),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun?',
                            style: poppins.copyWith(fontSize: 12),
                          ),
                          Text(
                            ' Daftar',
                            style: poppins.copyWith(
                              fontSize: 12,
                              color: kPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
