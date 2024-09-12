import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final void Function()? onTap;
  const ThemeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determina si el tema actual es oscuro o claro
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle, // Cambia la forma del contenedor a circular
        ),
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.nightlight_sharp,
            color: Theme.of(context)
                .colorScheme
                .tertiary, // Color del ícono basado en el tema
          ),
        ),
      ),
    );
  }
}
