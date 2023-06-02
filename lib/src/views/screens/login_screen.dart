import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/provider/auth_notifier.dart';
import '../components/loading_widget.dart';

final obsecureProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/images/login.svg',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoFormSection(
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      // backgroundColor: Colors.transparent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masuk',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle
                                .copyWith(color: Colors.black, fontSize: 24),
                          ),
                          Text(
                            'Silahkan masuk menggunakan akun LMS PPTIK',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      footer: const SizedBox(height: 12),
                      children: [
                        CupertinoTextFormFieldRow(
                          onTap: () {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          enableSuggestions: true,
                          enableInteractiveSelection: true,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          placeholder: 'Masukkan username',
                          prefix: const Icon(CupertinoIcons.person),
                          controller: _usernameController,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(color: Colors.black),
                        ),
                        CupertinoFormRow(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CupertinoTextFormFieldRow(
                                  onTap: () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Kata sandi tidak boleh kosong';
                                    } else if (value.length < 8) {
                                      return 'Kata sandi minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                  enableSuggestions: true,
                                  enableInteractiveSelection: true,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  placeholder: 'Masukkan kata sandi',
                                  prefix: const Icon(CupertinoIcons.lock),
                                  controller: _passwordController,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(color: Colors.black),
                                  obscureText: ref.watch(obsecureProvider),
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  ref.watch(obsecureProvider.notifier).state =
                                      !ref.watch(obsecureProvider);
                                },
                                child: ref.watch(obsecureProvider)
                                    ? const Icon(CupertinoIcons.eye_slash_fill)
                                    : const Icon(CupertinoIcons.eye),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton.filled(
                        child: ref.watch(loadingStateProvider)
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Masuk'),
                                ],
                              ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            auth
                                .login(_usernameController.text,
                                    _passwordController.text)
                                .then(
                              (value) {
                                if (value == 'success') {
                                  GoRouter.of(context)
                                      .pushReplacementNamed('main');
                                } else {
                                  showCupertinoDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Gagal masuk !'),
                                        content: Text(
                                          auth.message.toString(),
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .textStyle,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
