import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatelessWidget {
  final String cardNumber;
  final String balance;
  final String cardType;
  final List<Color> colors;
  const MyCard({
    super.key,
    required this.cardNumber,
    required this.balance,
    required this.colors,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar el ancho dinámico según la longitud del balance
    double containerWidth = 150; // Ancho mínimo

    // Incrementar el ancho gradualmente si el balance tiene más de 9 dígitos
    if (balance.length > 11) {
      containerWidth += (balance.length - 11) * 3; // Incrementar 3 píxeles por cada dígito extra
    }

    // Limitar el ancho al máximo de 180
    containerWidth = containerWidth.clamp(150, 180);

    return Container(
      height: 56,
      width: containerWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cardType,
                    style: GoogleFonts.baloo2(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Truncar el texto si es demasiado largo
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 5), // Espacio entre los textos
                Text(
                  cardNumber,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                '\$${balance.toString()}',
                style: GoogleFonts.baloo2(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
