import 'package:flutter/material.dart';
import 'package:wallet/services/firebase_service.dart';
import 'package:intl/intl.dart'; // Para el formato de fecha

class EditGastoPage extends StatefulWidget {
  const EditGastoPage({super.key});

  @override
  State<EditGastoPage> createState() => _EditGastoPageState();
}

class _EditGastoPageState extends State<EditGastoPage> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();

  DateTime? selectedDateTime; // Campo para la fecha y hora seleccionadas
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      cantidadController.text =
          arguments['cantidad'].toString(); // Convertir cantidad a texto
      tituloController.text = arguments['titulo'];
      tipoController.text = arguments['tipo'];
      selectedDateTime =
          arguments['fecha'] != null ? (arguments['fecha'].toDate()) : null;
      isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
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
              decoration: const InputDecoration(
                  hintText: 'Ingrese el tipo de movimiento'),
            ),
            TextField(
              controller: cantidadController,
              decoration:
                  const InputDecoration(hintText: 'Ingrese la cantidad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
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
                  // Asegúrate de que selectedDateTime sea de tipo DateTime
                  final Map arguments =
                      ModalRoute.of(context)!.settings.arguments as Map;
                  await updateGasto(
                    arguments['id'],
                    titulo,
                    tipo,
                    cantidad,
                    selectedDateTime!,
                  ).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  // Mostrar mensaje de error si los campos están vacíos o si la conversión falló
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, complete todos los campos con datos válidos')),
                  );
                }
              },
              child: const Text('Actualizar'),
            )
          ],
        ),
      ),
    );
  }
}
