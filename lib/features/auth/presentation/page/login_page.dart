import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/header/header.dart';
import 'package:next_trip/features/auth/application/bloc/auth_bloc.dart';
import 'package:next_trip/features/auth/application/bloc/auth_event.dart';
import 'package:next_trip/features/auth/application/bloc/auth_state.dart';
import 'package:next_trip/features/auth/presentation/widgets/auth_error_message.dart';
import 'package:next_trip/features/auth/presentation/widgets/auth_footer.dart';
import 'package:next_trip/features/auth/presentation/widgets/auth_form_fields.dart';
import 'package:next_trip/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
import 'package:next_trip/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Por favor ingresa tu correo electrónico primero');
      return;
    }

    context.read<AuthBloc>().add(
      AuthResetPasswordRequested(email: _emailController.text.trim()),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final headerHeight = screenHeight < 600 ? 150.0 : 200.0;
    final horizontalPadding = screenWidth < 400 ? 20.0 : 25.0;
    final verticalPadding = screenHeight < 600 ? 20.0 : 35.0;

    return Scaffold(
      backgroundColor: const Color(0xFF535353),
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FlightSearchPage()),
            );
          } else if (state is AuthPasswordResetSent) {
            _showSnackBar(state.message);
            context.read<AuthBloc>().add(AuthErrorCleared());
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Header(
                      title: 'NEXTRIP',
                      containerHeight: headerHeight,
                      imageSize: screenWidth < 400 ? 200 : 250,
                      top: screenHeight < 600 ? -30 : -50,
                      right: screenWidth < 400 ? -80 : -120,
                      radial: AppConstantsColors.radialBackground,
                      textColor: Colors.black,
                    ),

                    Flexible(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight:
                              screenHeight -
                              headerHeight -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ).copyWith(
                              bottom: keyboardHeight > 0
                                  ? verticalPadding + 20
                                  : verticalPadding,
                            ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "INICIAR SESIÓN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth < 400 ? 18 : 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: screenWidth < 400 ? 2 : 3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight < 600 ? 15 : 20,
                                  ),

                                  // Error message
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthError) {
                                        return AuthErrorMessage(
                                          message: state.message,
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),

                                  // Form fields
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EmailField(controller: _emailController),
                                      const SizedBox(height: 20),
                                      PasswordField(
                                        controller: _passwordController,
                                      ),
                                      const SizedBox(height: 20),
                                      ForgotPasswordLink(
                                        onTap: _handleForgotPassword,
                                      ),
                                      const SizedBox(height: 20),

                                      // Login button
                                      BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          final isLoading =
                                              state is AuthLoading;
                                          return CustomButton(
                                            text: isLoading
                                                ? "Accediendo..."
                                                : "Acceder",
                                            onPressed: isLoading
                                                ? null
                                                : _handleLogin,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Social auth
                                  SocialAuthButton(
                                    logoPath: "assets/images/google_logo.webp",
                                    text: "Google",
                                    onPressed: () {
                                      _showSnackBar(
                                        'Google Sign In no implementado aún',
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // Register link
                              AuthFooter(
                                questionText: "¿Aún no tienes cuenta?",
                                actionText: "Registrarse",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.register,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
