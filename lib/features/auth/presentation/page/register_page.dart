import 'package:flutter/material.dart';
import 'package:next_trip/core/constants/app_constants_colors.dart';
import 'package:next_trip/core/widgets/custom_button.dart';
import 'package:next_trip/core/widgets/header.dart';
import 'package:next_trip/core/widgets/input.dart';
import 'package:next_trip/features/auth/presentation/page/login_page.dart';
import 'package:next_trip/features/flights/presentation/pages/flight_search_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: SingleChildScrollView(
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

                      // Inputs
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Input(
                                  labelText: "Nombres",
                                  icon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Input(
                                  labelText: "Apellidos",
                                  icon: Icon(Icons.person),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          Input(labelText: "CC", icon: Icon(Icons.account_box)),
                          SizedBox(height: 10),

                          Input(labelText: "Email", icon: Icon(Icons.email)),
                          SizedBox(height: 10),

                          Input(labelText: "Teléfono", icon: Icon(Icons.phone)),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: Input(
                                  labelText: "Fecha",
                                  icon: Icon(Icons.date_range),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Input(
                                  labelText: "Género",
                                  icon: Icon(Icons.transgender),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          Input(
                            labelText: "Contraseña",
                            icon: Icon(Icons.visibility),
                          ),
                          SizedBox(height: 15),

                          CustomButton(
                            text: "Registrarse",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FlightSearchPage(),
                                ),
                              );
                            },
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

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
                                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                side: const BorderSide(color: Colors.black12),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
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
      ),
    );
  }
}
