import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

import '../helpers/format_helper.dart';
import '../theme/theme.dart';

extension GetTextStyleUtils on TextStyle {
  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle get primary => copyWith(color: Palette.blueColor);

  TextStyle get white => copyWith(color: Palette.whiteColor);
  TextStyle get black => copyWith(color: Palette.blackColor);
  TextStyle get grey => copyWith(color: Palette.greyColor);

  TextStyle get success => copyWith(color: Palette.greenColor);
  TextStyle get warning => copyWith(color: Palette.yellowColor);
  TextStyle get error => copyWith(color: Palette.redColor);

  TextStyle get clip => copyWith(overflow: TextOverflow.clip);
  TextStyle get ellipsis => copyWith(overflow: TextOverflow.ellipsis);
  TextStyle get fade => copyWith(overflow: TextOverflow.fade);
  TextStyle get visible => copyWith(overflow: TextOverflow.visible);
}

extension GetNumUtils on num {
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());
  Duration get seconds => Duration(milliseconds: (this * 1000).round());
  Duration get minutes => Duration(seconds: (this * 60).round());
  Duration get hours => Duration(minutes: (this * 60).round());
  Duration get days => Duration(hours: (this * 24).round());
  Duration get weeks => Duration(days: (this * 7).round());
  Duration get months => Duration(days: (this * 30).round());
  Duration get years => Duration(days: (this * 365).round());

  Future delay([FutureOr Function()? callback]) async => Future.delayed(seconds, callback);
  Timer interval(void Function(Timer timer) callback) => Timer.periodic(seconds, callback);
  Timer timer(Function() onDone) => Timer.periodic(1.seconds, (timer) {
        if (timer.tick.isEqual(round())) {
          timer.cancel();
          onDone();
        }
      });

  bool get isZero => this == 0;
  bool isLowerThan(num b) => this < b;
  bool isGreaterThan(num b) => this > b;
  bool isEqual(num b) => this == b;
  bool isLowerOrEqualThan(num b) => this <= b;
  bool isGreaterOrEqualThan(num b) => this >= b;
  bool isNotEqual(num b) => this != b;

  String format({String prefix = "IDR"}) => FormatHelper.format(toDouble(), prefix);
  String compactFormat() => FormatHelper.compactFormat(toDouble());
}

extension GetDateTimeUtils on DateTime {
  String format({String pattern = "dd MMMM yyyy"}) => FormatHelper.formatDateTime(this, pattern: pattern);
}

extension GetDurationUtils on Duration {
  Future delay([FutureOr Function()? callback]) async => Future.delayed(this, callback);
  Timer interval(void Function(Timer timer) callback) => Timer.periodic(this, callback);
  Timer timer(Function() onDone) => Timer.periodic(1.seconds, (timer) {
        if (timer.tick.isEqual(inSeconds)) {
          timer.cancel();
          onDone();
        }
      });
}

extension GetStringUtils on String {
  bool get isEmail =>
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this);

  String get removeAllWhitespace => replaceAll(' ', '');
}
