import 'package:flutter/material.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/core/utils/form_validators.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      labelText: "Correo electrónico",
      keyboardType: TextInputType.emailAddress,
      validator: FormValidators.validateEmail,
      prefixIcon: Icons.email,
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;

  const PasswordField({super.key, required this.controller, this.labelText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: widget.controller,
      labelText: widget.labelText ?? "Contraseña",
      validator: FormValidators.validatePassword,
      prefixIcon: Icons.lock,
      obscureText: _obscurePassword,
      suffix: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }
}

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPasswordLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        "¿Olvidaste tu contraseña?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
