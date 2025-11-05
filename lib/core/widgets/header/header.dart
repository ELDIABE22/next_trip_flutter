import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/auth/application/bloc/auth_bloc.dart';
import 'package:next_trip/features/auth/application/bloc/auth_state.dart';
import 'package:next_trip/core/widgets/header/logout_dialog.dart';
import 'package:next_trip/core/widgets/header/user_section.dart';

class Header extends StatelessWidget {
  final double containerHeight;
  final double imageSize;
  final double top;
  final double right;
  final BoxDecoration? radial;
  final Color? textColor;
  final String title;
  final bool showUserBelowTitle;

  const Header({
    super.key,
    required this.containerHeight,
    required this.imageSize,
    required this.top,
    required this.right,
    this.radial,
    this.textColor,
    required this.title,
    this.showUserBelowTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fondo
          Container(
            decoration: radial,
            width: double.infinity,
            height: containerHeight,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: radial == null ? Colors.black : null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 7,
                    ),
                  ),
                  if (showUserBelowTitle) _buildUserSection(context),
                ],
              ),
            ),
          ),
          Positioned(
            top: top,
            right: right,
            child: Image.asset(
              textColor == null
                  ? 'assets/images/logo-app-white.webp'
                  : 'assets/images/logo-app-black.webp',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return UserSection(
          textColor: textColor ?? Colors.white,
          isLoggingOut: isLoading,
          onLogoutPressed: () => _showLogoutDialog(context),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<AuthBloc>(),
          child: const LogoutDialog(),
        );
      },
    );
  }
}
