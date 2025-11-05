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
import 'package:next_trip/features/auth/presentation/widgets/register_form_fields.dart';
import 'package:next_trip/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:next_trip/routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ccController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ccController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    DateTime? birthDate;
    if (_birthDateController.text.isNotEmpty) {
      final parts = _birthDateController.text.trim().split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          birthDate = DateTime(year, month, day);
        }
      }
    }

    final birthDateToUse = birthDate ?? DateTime.now();

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        cc: _ccController.text.trim(),
        gender: _genderController.text.trim(),
        birthDate: birthDateToUse,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.searchCountry);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                title: 'NEXTRIP',
                containerHeight: 150,
                imageSize: 220,
                top: -65,
                right: -100,
                radial: AppConstantsColors.radialBackground,
                textColor: Colors.black,
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "REGISTRARSE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 400 ? 18 : 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: screenWidth < 400 ? 2 : 3,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Error message
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthError) {
                              return AuthErrorMessage(message: state.message);
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              FullNameField(controller: _fullNameController),
                              const SizedBox(height: 10),

                              CCField(controller: _ccController),
                              const SizedBox(height: 10),

                              EmailField(controller: _emailController),
                              const SizedBox(height: 10),

                              PhoneField(controller: _phoneController),
                              const SizedBox(height: 10),

                              DateAndGenderRow(
                                birthDateController: _birthDateController,
                                genderController: _genderController,
                              ),
                              const SizedBox(height: 10),

                              PasswordField(controller: _passwordController),
                              const SizedBox(height: 25),

                              // Register button
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return CustomButton(
                                    text: isLoading
                                        ? "Registrando..."
                                        : "Registrarse",
                                    onPressed: isLoading
                                        ? null
                                        : _handleRegister,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Social auth
                        SocialAuthButton(
                          logoPath: "assets/images/google_logo.webp",
                          text: "Google",
                          onPressed: () {
                            _showSnackBar('Google Sign In no implementado aún');
                          },
                        ),

                        const SizedBox(height: 20),

                        // Login link
                        AuthFooter(
                          questionText: "¿Ya tienes una cuenta?",
                          actionText: "Iniciar sesión",
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
