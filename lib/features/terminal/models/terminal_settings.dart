import 'package:flutter/material.dart';

class TerminalSettings {
  final String shellPath;
  final double fontSize;
  final String fontFamily;
  final Color cursorColor;
  final Color selectionColor;
  final bool cursorBlink;

  const TerminalSettings({
    this.shellPath = '/bin/zsh', // Default for Mac
    this.fontSize = 14.0,
    this.fontFamily = 'Courier New',
    this.cursorColor = const Color(0xFF888888),
    this.selectionColor = const Color(0xFF264F78),
    this.cursorBlink = true,
  });

  TerminalSettings copyWith({
    String? shellPath,
    double? fontSize,
    String? fontFamily,
    Color? cursorColor,
    Color? selectionColor,
    bool? cursorBlink,
  }) {
    return TerminalSettings(
      shellPath: shellPath ?? this.shellPath,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      cursorBlink: cursorBlink ?? this.cursorBlink,
    );
  }
}
