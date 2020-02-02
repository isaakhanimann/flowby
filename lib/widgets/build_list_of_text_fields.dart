// TODO: Use Listenable Class (similar to Provider) to refactor the BuildList of TextFields
// https://stackoverflow.com/questions/50430273/how-to-set-state-from-another-widget
// https://api.flutter.dev/flutter/foundation/Listenable-class.html

import 'package:flutter/cupertino.dart';

class BuildListOfTextFields extends StatelessWidget {
  final List<TextEditingController> skillKeywordControllers;
  final List<TextEditingController> skillDescriptionControllers;
  final List<TextEditingController> skillPriceControllers;

  final List<TextEditingController> wishKeywordControllers;
  final List<TextEditingController> wishDescriptionControllers;
  final List<TextEditingController> wishPriceControllers;

  BuildListOfTextFields({
    @required this.skillKeywordControllers,
    @required this.skillDescriptionControllers,
    @required this.skillPriceControllers,
    @required this.wishKeywordControllers,
    @required this.wishDescriptionControllers,
    @required this.wishPriceControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
