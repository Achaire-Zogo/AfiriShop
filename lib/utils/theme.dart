import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF1B383A);
const kSecondaryColor = Color(0xFF59706F);
const kDarkGreyColor = Color(0xFFA8A8A8);
const kWhiteColor = Color(0xFFFFFFFF);
const kZambeziColor = Color(0xFF5B5B5B);
const kBlackColor = Color(0xFF272726);
const kTextFieldColor = Color(0xFF979797);
const kblue = Colors.blue;
const kwhite = Color(0xFFFFFFFF);
const kblack = Color(0xFF000000);
const kbrown300 = Color(0xFF8D6E63);
const kbrown = Color(0xFF795548);
const kgrey = Color(0xFFC0C0C0);
const primary = Color(0xFF12376F);
const Color primaryDark = Color(0xFF0C44A3);
const Color primaryLight = Color(0xFF43A3F3);
const Color green = Colors.green;
Color black = const Color(0xFF000000);
const kprimaryColor = Color(0xff212C42);
const ksecondryColor = Color(0xff9CA2FF);
const ksecondryLightColor = Color(0xffEDEFFE);
const klightContentColor = Color(0xffF1F2F7);
const blueClear = Color.fromARGB(255, 233, 239, 243);
const yellow = Colors.yellow;

const double kbigFontSize = 25;
const kscaffoldColor = Color(0xffffffff);
const kcontentColor = Color(0xffF5F5F5);
const double knormalFontSize = 18;
const double ksmallFontSize = 15;

String apiKey = "AIzaSyCRwQ16-quYEmufpTR4ba8tu2chhLwz7Ec";

const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);

TextStyle titleText =
    TextStyle(color: kPrimaryColor, fontSize: 22, fontWeight: FontWeight.w700);
TextStyle subTitle = TextStyle(
    color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle textButton = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}

class MyStringsSample {
  static const String lorem_ipsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam efficitur ipsum in placerat molestie.  Fusce quis mauris a enim sollicitudin"
      "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam efficitur ipsum in placerat molestie.  Fusce quis mauris a enim sollicitudin";
  static const String middle_lorem_ipsum =
      "Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.";
  static const String card_text =
      "Cards are surfaces that display content and actions on a single topic.";
}
