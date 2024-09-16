import 'package:flutter/material.dart';
import 'package:wallet/services/firebase_service.dart';

// Componentes de formulario
import 'widgets/data_time_selector.dart';
import 'widgets/text_field_widget.dart';

/// Página para agregar un gasto.
class AddGastoPage extends StatefulWidget {
  const AddGastoPage({super.key});

  @override
  _AddGastoPageState createState() => _AddGastoPageState();
}

class _AddGastoPageState extends State<AddGastoPage> {
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _cantidadController.dispose();
    _tituloController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usa el nuevo TextFieldWidget que acepta los colores del theme.
            TextFieldWidget(
              controller: _tituloController,
              hintText: 'Ingrese el título',
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              controller: _tipoController,
              hintText: 'Ingrese el tipo de movimiento',
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              controller: _cantidadController,
              hintText: 'Ingrese la cantidad',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Usa el nuevo DateTimeSelector que acepta los colores del theme.
            DateTimeSelector(
              selectedDateTime: _selectedDateTime,
              onPressed: _selectDateTime,
            ),
            const SizedBox(height: 20),
            // Botón actualizado con colores del theme.
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    elevation: 1),
                onPressed: _saveGasto,
                child: const Text('Guardar',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo para seleccionar la fecha y la hora.
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  /// Guarda el gasto si todos los campos son válidos.
  Future<void> _saveGasto() async {
    final String titulo = _tituloController.text.trim();
    final String tipo = _tipoController.text.trim();
    final int? cantidad = int.tryParse(_cantidadController.text.trim());

    if (titulo.isNotEmpty &&
        tipo.isNotEmpty &&
        cantidad != null &&
        _selectedDateTime != null) {
      try {
        await addGasto(titulo, tipo, cantidad, _selectedDateTime!);
        Navigator.pop(context);
      } catch (_) {
        _showErrorSnackbar('Error al guardar el gasto. Inténtelo de nuevo.');
      }
    } else {
      _showErrorSnackbar(
          'Por favor, complete todos los campos con datos válidos');
    }
  }

  /// Muestra un mensaje de error en un Snackbar.
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
