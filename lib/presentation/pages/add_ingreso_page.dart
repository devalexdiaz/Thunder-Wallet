import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/services/firebase_service.dart';

class AddIngresoPage extends StatefulWidget {
  const AddIngresoPage({super.key});

  @override
  State<AddIngresoPage> createState() => _AddIngresoPageState();
}

class _AddIngresoPageState extends State<AddIngresoPage> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();

  DateTime? selectedDateTime; // Campo para la fecha y hora seleccionadas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(hintText: 'Ingrese el título'),
            ),
            TextField(
              controller: tipoController,
              decoration:
                  const InputDecoration(hintText: 'Ingrese el tipo de ingreso'),
            ),
            TextField(
              controller: cantidadController,
              decoration:
                  const InputDecoration(hintText: 'Ingrese la cantidad'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDateTime == null
                        ? 'Seleccione la fecha y hora'
                        : DateFormat('yyyy-MM-dd HH:mm')
                            .format(selectedDateTime!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
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
                          selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text;
                final tipo = tipoController.text;
                final cantidadText = cantidadController.text;

                // Convertir el valor de cantidad a double
                final cantidad = int.tryParse(cantidadText);

                if (titulo.isNotEmpty &&
                    tipo.isNotEmpty &&
                    cantidad !=
                        null && // Validar que la conversión a double fue exitosa
                    selectedDateTime != null) {
                  await addIngreso(titulo, tipo, cantidad, selectedDateTime!)
                      .then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  // Mostrar mensaje de error si los campos están vacíos o la conversión falló
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, complete todos los campos con datos válidos')),
                  );
                }
              },
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
