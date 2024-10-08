import 'package:flutter/material.dart';
import 'package:wallet/services/firebase_service.dart';

// Componentes de formulario
import 'widgets/data_time_selector.dart';
import 'widgets/text_field_widget.dart';

class EditIngresoPage extends StatefulWidget {
  const EditIngresoPage({super.key});

  @override
  State<EditIngresoPage> createState() => _EditIngresoPageState();
}

class _EditIngresoPageState extends State<EditIngresoPage> {
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
      _selectedDateTime = arguments['fecha']?.toDate();
      _isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usa el TextFieldWidget que acepta los colores del tema
            TextFieldWidget(
              controller: _tituloController,
              hintText: 'Ingrese el título',
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              controller: _tipoController,
              hintText: 'Ingrese el tipo de ingreso',
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              controller: _cantidadController,
              hintText: 'Ingrese la cantidad',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Usa el DateTimeSelector que acepta los colores del tema
            DateTimeSelector(
              selectedDateTime: _selectedDateTime,
              onPressed: _selectDateTime,
            ),
            const SizedBox(height: 20),
            // Botón actualizado con colores del theme
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
                onPressed: _updateIngreso,
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

  Future<void> _updateIngreso() async {
    final String titulo = _tituloController.text.trim();
    final String tipo = _tipoController.text.trim();
    final int? cantidad = int.tryParse(_cantidadController.text.trim());

    if (titulo.isNotEmpty &&
        tipo.isNotEmpty &&
        cantidad != null &&
        _selectedDateTime != null) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      await updateIngreso(
        arguments['id'],
        titulo,
        tipo,
        cantidad,
        _selectedDateTime!,
      );
      Navigator.pop(context);
    } else {
      _showErrorSnackbar(
          'Por favor, complete todos los campos con datos válidos');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
