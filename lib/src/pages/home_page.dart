import 'package:flutter/material.dart';
import 'package:imc_challenge/src/controllers/imc_controller.dart';
import 'package:imc_challenge/src/data/db.dart';
import 'package:imc_challenge/src/models/person_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final weight = TextEditingController();
  final height = TextEditingController();
  final imcController = ImcController();
  final Db _db = Db();

  @override
  void dispose() {
    name.dispose();
    weight.dispose();
    height.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadIMCList(); // Carregue a lista do banco de dados ao iniciar a tela
  }

  Future<void> _loadIMCList() async {
    final imcList = await _db.getIMCList();
    setState(() {
      imcController.listIMC.addAll(imcList.map((item) => item['item']));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('IMC')),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: "Nome"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome Obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Peso (KG)"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso Obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: height,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Altura (M)"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura Obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final personModel = PersonModel(
                          name: name.text,
                          height: double.parse(height.text),
                          weight: double.parse(weight.text));
                      final imc =
                          imcController.calculateIMC(personModel: personModel);
                      final result =
                          imcController.interpretIMC(imc: imc, name: name.text);
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('IMC'),
                          content: Text(result.toString(),
                              style: const TextStyle(fontSize: 20)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Calcular'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Historico de IMC:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: imcController,
                  builder: (BuildContext context, Widget? child) {
                    return Column(
                      children: imcController.listIMC.isEmpty
                          ? [const Text('Lista Vazia!')]
                          : imcController.listIMC.map((item) {
                              return ListTile(
                                title: Text(item),
                              );
                            }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
