import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore
import 'package:wallet/data/repositories/movimiento_repository.dart';
import '../widgets/data_time_selector.dart';
import '../widgets/text_field_widget.dart';

class EditGastoPage extends StatefulWidget {
  const EditGastoPage({super.key});

  @override
  State<EditGastoPage> createState() => _EditGastoPageState();
}

class _EditGastoPageState extends State<EditGastoPage> {
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  DateTime? _selectedDateTime;
  bool _isInitialized = false;

  @override
  void dispose() {
    _cantidadController.dispose();
    _tituloController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      _cantidadController.text = arguments['cantidad'].toString();
      _tituloController.text = arguments['titulo'];
      _tipoController.text = arguments['tipo'];
      _selectedDateTime = arguments['fecha'] is Timestamp
          ? (arguments['fecha'] as Timestamp).toDate()
          : arguments['fecha'] as DateTime;
      _isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
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
                onPressed: _updateGasto,
                child: const Text('Actualizar',
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
    final DateTime? pickedDate = await _showDatePicker();

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await _showTimePicker();

      if (pickedTime != null) {
        if (mounted) {
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
  }

  Future<DateTime?> _showDatePicker() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  Future<TimeOfDay?> _showTimePicker() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
  }

  Future<void> _updateGasto() async {
    final String titulo = _tituloController.text.trim();
    final String tipo = _tipoController.text.trim();
    final int? cantidad = int.tryParse(_cantidadController.text.trim());

    if (titulo.isNotEmpty &&
        tipo.isNotEmpty &&
        cantidad != null &&
        _selectedDateTime != null) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      final repository =
          Provider.of<MovimientoRepository>(context, listen: false);

      try {
        // Convierte DateTime a Timestamp
        final Timestamp timestamp = Timestamp.fromDate(_selectedDateTime!);

        // Llama a la función genérica para actualizar movimientos
        await repository.updateMovimiento(
          'gastos', // Colección de gastos
          arguments['id'],
          titulo,
          tipo,
          cantidad,
          timestamp,
        );

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackbar('Error al actualizar el gasto: $e');
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
    // Verifica que el widget esté montado antes de mostrar el Snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
