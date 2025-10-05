import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/features/auth/data/controllers/auth_controller.dart';

class Header extends StatefulWidget {
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
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final AuthController _authController = AuthController();
  bool _isLoggingOut = false;

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Fondo
          Container(
            decoration: widget.radial,
            width: double.infinity,
            height: widget.containerHeight,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: widget.radial == null ? Colors.black : null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 7,
                    ),
                  ),
                  if (widget.showUserBelowTitle)
                    _buildUserSection(context, textColor: widget.textColor),
                ],
              ),
            ),
          ),

          // Imagen posicionada
          Positioned(
            top: widget.top,
            right: widget.right,
            child: Image.asset(
              widget.textColor == null
                  ? 'assets/images/logo-app-white.webp'
                  : 'assets/images/logo-app-black.webp',
              width: widget.imageSize,
              height: widget.imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, {Color? textColor}) {
    final user = FirebaseAuth.instance.currentUser;
    final color = textColor ?? Colors.white;

    if (user != null) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de cerrar sesión
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoggingOut ? null : () => _showLogoutDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isLoggingOut
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 16,
                            ),
                      const SizedBox(width: 6),
                      Text(
                        _isLoggingOut ? 'Saliendo...' : 'Salir',
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
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de iniciar sesión
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              icon: Icon(Icons.login, size: 16, color: color),
              label: Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 13, color: color),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

  // Diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Estás seguro de que quieres cerrar sesión?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Deberás iniciar sesión nuevamente para acceder a tus reservas y preferencias.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                // Botón Cancelar
                TextButton(
                  onPressed: _isLoggingOut
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),

                // Botón Cerrar sesión
                ElevatedButton.icon(
                  onPressed: _isLoggingOut
                      ? null
                      : () async {
                          // Actualizar estado en el diálogo
                          setDialogState(() {
                            _isLoggingOut = true;
                          });

                          // Actualizar estado en el widget principal
                          setState(() {
                            _isLoggingOut = true;
                          });

                          // Ejecutar logout
                          final success = await _authController.signOut();

                          // Cerrar diálogo
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }

                          // Actualizar estado
                          if (mounted) {
                            setState(() {
                              _isLoggingOut = false;
                            });
                          }

                          if (context.mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Sesión cerrada correctamente'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _authController.errorMessage ??
                                              'Error al cerrar sesión',
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  icon: _isLoggingOut
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.logout, size: 18),
                  label: Text(
                    _isLoggingOut ? 'Cerrando...' : 'Cerrar sesión',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
