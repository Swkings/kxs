import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart' as xterm;
import 'package:xterm/xterm.dart' show Terminal, TerminalController, TerminalStyle, TerminalThemes;
import 'package:kxs/features/terminal/controllers/terminal_controller.dart';
import 'package:kxs/features/terminal/models/terminal_settings.dart';

class TerminalView extends ConsumerStatefulWidget {
  const TerminalView({super.key});

  @override
  ConsumerState<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends ConsumerState<TerminalView> {
  late final Terminal _terminal;
  final TerminalController _terminalController = TerminalController();
  Pty? _pty;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _terminal = Terminal(maxLines: 10000);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _startPty();
      _isInit = true;
    }
  }

  void _startPty() async {
    final settings = ref.read(terminalSettingsControllerProvider);
    
    _pty = Pty.start(
      settings.shellPath,
      columns: _terminal.viewWidth,
      rows: _terminal.viewHeight,
      environment: Platform.environment,
      workingDirectory: Platform.environment['HOME'] ?? '/',
    );

    // Pass output from PTY to Terminal
    _pty!.output.cast<List<int>>().transform(const Utf8Decoder()).listen(_terminal.write);

    // Pass input from Terminal to PTY
    _terminal.onOutput = (data) {
      _pty!.write(const Utf8Encoder().convert(data));
    };

    // Handle Resize
    _terminal.onResize = (w, h, pw, ph) {
      _pty!.resize(h, w);
    };
  }

  @override
  void dispose() {
    _pty?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to settings for font changes
    final settings = ref.watch(terminalSettingsControllerProvider);
    
    return Scaffold(
      backgroundColor: Colors.black, 
      body: xterm.TerminalView( 
        _terminal,
        controller: _terminalController,
        autofocus: true,
        textStyle: TerminalStyle(
          fontFamily: 'Courier New',
          fontSize: settings.fontSize,
        ),
        theme: TerminalThemes.defaultTheme, 
      ),
    );
  }
}
