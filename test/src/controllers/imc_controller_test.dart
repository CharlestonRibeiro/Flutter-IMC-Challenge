import 'package:flutter_test/flutter_test.dart';
import 'package:imc_challenge/src/controllers/imc_controller.dart';
import 'package:imc_challenge/src/models/person_model.dart';

final imcService = ImcController();
final personModel = PersonModel(name: 'Charles', weight: 80, height: 1.70);

void main() {
  test('Calculate imc service success...', () async {
    final result = imcService.calculateIMC(personModel: personModel);
    expect(result, equals(27.7));
  });

  test('Interprete imc service success...', () async {
    final imc = imcService.calculateIMC(personModel: personModel);
    final result = imcService.interpretIMC(imc: imc, name: 'Charles');
    expect(result, equals('IMC: 27.7. Charles vc está com sobrepeso.'));
  });
}