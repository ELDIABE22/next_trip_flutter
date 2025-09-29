import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/utils/form_validators.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/header.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/auth/data/controllers/auth_controller.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';
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

  final AuthController _authController = AuthController();

  bool _obscurePassword = true;
  // ignore: unused_field
  bool _isLoading = false;
  String? _errorMessage;

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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ccController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
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

      final success = await _authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        cc: _ccController.text.trim(),
        gender: _genderController.text.trim(),
        birthDate: birthDateToUse,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.searchCountry);
      } else if (_authController.errorMessage != null) {
        setState(() {
          _errorMessage = _authController.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: AnimatedBuilder(
        animation: _authController,
        builder: (context, child) {
          return SingleChildScrollView(
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
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Full Name
                                Input(
                                  controller: _fullNameController,
                                  labelText: "Nombre completo",
                                  prefixIcon: Icons.person,
                                  validator: FormValidators.validateFullName,
                                ),
                                const SizedBox(height: 10),

                                // CC
                                Input(
                                  controller: _ccController,
                                  labelText: "CC",
                                  prefixIcon: Icons.credit_card,
                                  keyboardType: TextInputType.number,
                                  validator: FormValidators.validateCC,
                                ),
                                const SizedBox(height: 10),

                                // Email
                                Input(
                                  controller: _emailController,
                                  labelText: "Email",
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: FormValidators.validateEmail,
                                ),
                                const SizedBox(height: 10),

                                // Phone
                                Input(
                                  controller: _phoneController,
                                  labelText: "Teléfono",
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: FormValidators.validatePhoneNumber,
                                ),
                                const SizedBox(height: 10),

                                // Date and Gender Row
                                Row(
                                  children: [
                                    // Birth Date
                                    Expanded(
                                      child: Input(
                                        controller: _birthDateController,
                                        labelText: "Fecha de Nacimiento",
                                        prefixIcon: Icons.calendar_today,
                                        readOnly: true,
                                        onTap: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );
                                          if (picked != null) {
                                            _birthDateController.text =
                                                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requerido';
                                          }
                                          try {
                                            final parts = value.trim().split(
                                              '/',
                                            );
                                            if (parts.length != 3) {
                                              return 'Formato de fecha inválido (dd/mm/aaaa)';
                                            }
                                            final day = int.tryParse(parts[0]);
                                            final month = int.tryParse(
                                              parts[1],
                                            );
                                            final year = int.tryParse(parts[2]);

                                            if (day == null ||
                                                month == null ||
                                                year == null) {
                                              return 'Formato de fecha inválido (dd/mm/aaaa)';
                                            }

                                            final dt = DateTime(
                                              year,
                                              month,
                                              day,
                                            );
                                            return FormValidators.validateBirthDate(
                                              dt,
                                            );
                                          } catch (e) {
                                            return 'Formato de fecha inválido (dd/mm/aaaa)';
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Gender
                                    Expanded(
                                      child: Input(
                                        controller: _genderController,
                                        labelText: "Género",
                                        prefixIcon: Icons.transgender,
                                        readOnly: true,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: 3,
                                                itemBuilder: (context, index) {
                                                  final genders = [
                                                    'Masculino',
                                                    'Femenino',
                                                    'Otro',
                                                  ];
                                                  return ListTile(
                                                    title: Text(genders[index]),
                                                    onTap: () {
                                                      _genderController.text =
                                                          genders[index];
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        validator:
                                            FormValidators.validateGender,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Password
                                Input(
                                  controller: _passwordController,
                                  labelText: "Contraseña",
                                  prefixIcon: Icons.lock,
                                  obscureText: _obscurePassword,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  validator: FormValidators.validatePassword,
                                ),
                                SizedBox(height: 15),

                                const SizedBox(height: 10),

                                // Error Message
                                if (_errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                // Register Button
                                AnimatedBuilder(
                                  animation: _authController,
                                  builder: (context, child) {
                                    return CustomButton(
                                      text: _authController.isLoading
                                          ? "Registrando..."
                                          : "Registrarse",
                                      onPressed: _authController.isLoading
                                          ? null
                                          : _register,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Google
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FlightSearchPage(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 20),

                          // Registrarse
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¿Ya tienes una cuenta?",
                                style: TextStyle(
                                  color: Color(0xFFEFECEC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                                child: const Text(
                                  "Iniciar sesión",
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
