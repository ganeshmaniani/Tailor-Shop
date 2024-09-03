import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/entities/entites.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../core/core.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final NavigatorState navigatorState;
  const LoginScreen({super.key, required this.navigatorState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Login Successfully..!')));
              widget.navigatorState
                  .pushNamedAndRemoveUntil('home', (route) => false);
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(AppAssets.logoIcon, scale: 8)),
                  const SizedBox(height: 32),
                  const Text(
                    'Log in',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Enter your password',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    hintText: 'password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  state is AuthLoading
                      ? const CustomLoading()
                      : CustomButton(
                          text: 'Log in',
                          onTap: () {
                            if (formKey.currentState?.validate() ?? false) {
                              LoginEntity loginEntity = LoginEntity(
                                  email: emailController.text,
                                  password: passwordController.text);
                              BlocProvider.of<AuthCubit>(context)
                                  .userLogin(loginEntity);
                            }
                          })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
