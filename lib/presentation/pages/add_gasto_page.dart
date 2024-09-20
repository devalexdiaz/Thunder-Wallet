import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar Cloud Firestore
import 'package:wallet/data/repositories/movimiento_repository.dart'; // Importa el repositorio
import '../widgets/data_time_selector.dart';
import '../widgets/text_field_widget.dart';

/// Página para agregar un gasto.
class AddGastoPage extends StatefulWidget {
  const AddGastoPage({super.key});

  @override
  AddGastoPageState createState() => AddGastoPageState();
}

class AddGastoPageState extends State<AddGastoPage> {
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
            DateTimeSelector(
              selectedDateTime: _selectedDateTime,
              onPressed: _selectDateTime,
            ),
            const SizedBox(height: 20),
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

  Future<void> _selectDateTime() async {
    if (!mounted) return; // Verifica si el widget está montado

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (!mounted) return; // Verifica si el widget está montado

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        if (!mounted) return; // Verifica si el widget está montado

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

  Future<void> _saveGasto() async {
    final String titulo = _tituloController.text.trim();
    final String tipo = _tipoController.text.trim();
    final int? cantidad = int.tryParse(_cantidadController.text.trim());

    if (titulo.isNotEmpty &&
        tipo.isNotEmpty &&
        cantidad != null &&
        _selectedDateTime != null) {
      try {
        final repository =
            Provider.of<MovimientoRepository>(context, listen: false);

        // Convierte DateTime a Timestamp
        final Timestamp timestamp = Timestamp.fromDate(_selectedDateTime!);

        // Llama a la función genérica para agregar movimientos
        await repository.addMovimiento(
            'gastos', titulo, tipo, cantidad, timestamp);

        // Verifica si el widget sigue montado antes de usar Navigator.pop
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (_) {
        if (mounted) {
          _showErrorSnackbar('Error al guardar el gasto. Inténtelo de nuevo.');
        }
      }
    } else {
      if (mounted) {
        _showErrorSnackbar(
            'Por favor, complete todos los campos con datos válidos');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
