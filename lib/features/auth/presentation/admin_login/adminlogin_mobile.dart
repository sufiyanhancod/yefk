import 'package:app/features/auth/auth.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/shared/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_theme/buttons.dart';
import 'package:hancod_theme/forms.dart';

class AdminloginScreenMobile extends ConsumerStatefulWidget {
  const AdminloginScreenMobile({super.key});

  @override
  ConsumerState<AdminloginScreenMobile> createState() => _AdminloginScreenMobileState();
}

class _AdminloginScreenMobileState extends ConsumerState<AdminloginScreenMobile> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with pattern
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF2B6CA3), // Blue background color from image
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Pattern overlay (You may need to add your pattern asset)
                    Align(
                      alignment: Alignment.topRight,
                      child: Assets.images.loginBackgroundTop.image(fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Assets.images.loginBackgroundBottom.image(fit: BoxFit.cover),
                    ),
                    // Central form card
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo
                                Assets.images.yefkLogo.image(
                                  width: 70,
                                  height: 70,
                                ),

                                const SizedBox(height: 20),

                                // Get Started heading
                                const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Subtitle text
                                const Text(
                                  "We're so excited to see you again!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Form fields
                                FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),

                                      // Name Field
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      AppTextForm<String>(
                                        name: 'email',
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        decoration: InputDecoration(
                                          hintText: 'Enter your email',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Phone Number Field
                                      const Text(
                                        'Password',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      AppTextForm<String>(
                                        name: 'password',
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        enableObscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 30),

                                      // // Sign up as Admin link
                                      // Center(
                                      //   child: TextButton(
                                      //     onPressed: () {
                                      //       // Handle admin sign up
                                      //     },
                                      //     child: const Text(
                                      //       'Sign up as Admin',
                                      //       style: TextStyle(
                                      //         decoration: TextDecoration.underline,
                                      //         color: Colors.black54,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      const SizedBox(height: 20),

                                      // Sign Up Button
                                      SizedBox(
                                        width: double.infinity,
                                        child: AppButton(
                                          isLoading: ref.watch(authenticationNotifierProvider).status == AuthenticationStatus.loading,
                                          onPress: () {
                                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                                              ref.read(authenticationNotifierProvider.notifier).signInWithEmail(
                                                    email: _formKey.currentState!.value['email'] as String,
                                                    password: _formKey.currentState!.value['password'] as String,
                                                  );
                                            }
                                          },
                                          label: const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // style: ElevatedButton.styleFrom(
                                          //   backgroundColor: const Color(0xFF2B6CA3),
                                          //   padding: const EdgeInsets.symmetric(vertical: 15),
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(8),
                                          //   ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom home indicator
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
