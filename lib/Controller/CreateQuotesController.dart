import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/EmojiModel.dart';

class CreateQuotesController extends GetxController {
  var isEmojiVisable = true.obs;
  var color = Colors.white.obs;
  var backgroundImage = "".obs;
  int selectedIndex = 0;
  var bottomSheetName = "Photo Gallery".obs;

  List<EmojiModel> emojiList = [];

  List<String> fontsList = [
    "AnotherFlight",
    "ArimaKoshi-Regular",
    "beatiful",
    "Brown Choco",
    "Calligraffitti-Regular",
    "DSFetteGotisch",
    "evanescent",
    "Exo2-RegularExpanded",
    "FingerPaint-Regular",
    "Greylight Demo",
    "Hartford Demo",
    "herdrey demo",
    "Jellee-Roman",
    "Junction-regular",
    "JustBeDemo-Regular",
    "LillyMae-Regular",
    "LuxuriousScript-Regular",
    "Margueritas",
    "MINUS_CRE",
    "Rhonde-Free",
    "RubikWetPaint-Regular",
    "Satanyc Demoniac St",
    "ShortStack-Regular",
    "Tribal Script",
    "Barbed Wires",
    "Bellvast Personal Use Only",
    "Bukhari Script",
    "BukhariScriptAlternates",
    "DALMANTI",
    "Growonk",
    "Maghfirea",
    "NicemilkDEMO",
    "SOPHIA demo",
    "The Evil Within",
    "Ventilla Script",
  ];
}
