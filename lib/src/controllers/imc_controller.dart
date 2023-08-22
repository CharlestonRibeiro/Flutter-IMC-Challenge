import 'package:imc_challenge/src/models/person_model.dart';

class ImcService {
  double calculateIMC({required PersonModel personModel}) {
    double imc = personModel.weight / (personModel.height * personModel.height);
    return double.parse(imc.toStringAsFixed(1));
  }

  String interpretIMC({required double imc, required String name}) {
    if (imc < 18.5) {
      return 'IMC: $imc. $name vc está abaixo do peso.';
    } else if (imc >= 18.5 && imc < 24.9) {
      return 'IMC: $imc. $name vc está com o peso normal.';
    } else if (imc >= 25 && imc < 29.9) {
      return 'IMC: $imc. $name vc está com sobrepeso.';
    } else {
      return 'IMC: $imc. $name vc está com obesidade.';
    }
  }
}