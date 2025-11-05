import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSection extends StatelessWidget {
  final Color textColor;
  final VoidCallback onLogoutPressed;
  final bool isLoggingOut;

  const UserSection({
    super.key,
    required this.textColor,
    required this.onLogoutPressed,
    this.isLoggingOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return _buildAuthenticatedSection(context);
    } else {
      return _buildUnauthenticatedSection(context);
    }
  }

  Widget _buildAuthenticatedSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoggingOut ? null : onLogoutPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoggingOut
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : const Icon(Icons.logout, color: Colors.red, size: 16),
                const SizedBox(width: 6),
                Text(
                  isLoggingOut ? 'Saliendo...' : 'Salir',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón de iniciar sesión
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: Icon(Icons.login, size: 16, color: textColor),
            label: Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: 13, color: textColor),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: textColor.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Botón de registrarse
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            icon: const Icon(Icons.person_add, size: 16),
            label: const Text('Registrarse', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
