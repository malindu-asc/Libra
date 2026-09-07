import 'package:flutter/material.dart';

/// Corner radius scale, design system section 12.
abstract final class AppRadius {
  static const small = 8.0;
  static const input = 12.0;
  static const button = 14.0;
  static const card = 16.0;
  static const largeCard = 20.0;
  static const sheet = 24.0;
  static const bookCover = 16.0;
  static const pill = 999.0;

  static BorderRadius get inputRadius => BorderRadius.circular(input);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get largeCardRadius => BorderRadius.circular(largeCard);
  static BorderRadius get bookCoverRadius => BorderRadius.circular(bookCover);
  static BorderRadius get sheetRadius =>
      const BorderRadius.vertical(top: Radius.circular(sheet));
}
