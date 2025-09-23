import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/header.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/features/auth/data/controllers/auth_controller.dart';
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
  final _authController = AuthController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FlightSearchPage()),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Por favor ingresa tu correo electrónico primero');
      return;
    }

    final success = await _authController.resetPassword(
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      _showSnackBar('Se ha enviado un enlace de recuperación a tu correo');
    }
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

    // Responsive values
    final headerHeight = screenHeight < 600 ? 150.0 : 200.0;
    final horizontalPadding = screenWidth < 400 ? 20.0 : 25.0;
    final verticalPadding = screenHeight < 600 ? 20.0 : 35.0;

    return Scaffold(
      backgroundColor: const Color(0xFF535353),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                      decoration: BoxDecoration(
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
                                SizedBox(height: screenHeight < 600 ? 15 : 20),

                                // Error message display
                                AnimatedBuilder(
                                  animation: _authController,
                                  builder: (context, child) {
                                    if (_authController.errorMessage != null) {
                                      return Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(12),
                                        margin: EdgeInsets.only(
                                          bottom: screenHeight < 600 ? 15 : 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(color: Colors.red),
                                        ),
                                        child: Text(
                                          _authController.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Input(
                                      controller: _emailController,
                                      labelText: "Correo electrónico",
                                      keyboardType: TextInputType.emailAddress,
                                      validator: FormValidators.validateEmail,
                                      prefixIcon: Icons.email,
                                    ),
                                    SizedBox(height: 20),
                                    Input(
                                      controller: _passwordController,
                                      labelText: "Contraseña",
                                      validator:
                                          FormValidators.validatePassword,
                                      prefixIcon: Icons.lock,
                                      obscureText: _obscurePassword,
                                      suffix: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight < 600 ? 15 : 20,
                                    ),
                                    GestureDetector(
                                      onTap: _handleForgotPassword,
                                      child: Text(
                                        "¿Olvidaste tu contraseña?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    AnimatedBuilder(
                                      animation: _authController,
                                      builder: (context, child) {
                                        return CustomButton(
                                          text: _authController.isLoading
                                              ? "Accediendo..."
                                              : "Acceder",
                                          onPressed: _authController.isLoading
                                              ? null
                                              : _handleLogin,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Google section
                                Column(
                                  children: [
                                    // lineas con continuar
                                    Row(
                                      children: const [
                                        Expanded(
                                          child: Divider(
                                            color: Color(0xFFEFECEC),
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            "Continuar con",
                                            style: TextStyle(
                                              color: Color(0xFFEFECEC),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Color(0xFFEFECEC),
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    // Botón Google
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _showSnackBar(
                                            'Google Sign In no implementado aún',
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.black12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/google_logo.webp",
                                              height: 24,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Google",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 15),

                            // Registrarse
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿Aún no tienes cuenta?",
                                  style: TextStyle(
                                    color: Color(0xFFEFECEC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.register,
                                    );
                                  },
                                  child: Text(
                                    "Registrarse",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}
