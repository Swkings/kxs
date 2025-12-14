import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class K9sTableColumn {
  final String title;
  final double? width;
  final double flex;
  final Alignment alignment;

  const K9sTableColumn({
    required this.title,
    this.width,
    this.flex = 1.0,
    this.alignment = Alignment.centerLeft,
  });
}

class K9sTableRow {
  final List<String> cells;
  final Color? statusColor;
  final VoidCallback? onSelect;

  const K9sTableRow({
    required this.cells,
    this.statusColor,
    this.onSelect,
  });
}

class K9sTable extends StatefulWidget {
  final List<K9sTableColumn> columns;
  final List<K9sTableRow> rows;
  final VoidCallback? onEnter;
  final ValueChanged<int>? onHighlightChanged;
  final void Function(RawKeyEvent event, int selectedIndex)? onKeyDown;

  const K9sTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.onEnter,
    this.onHighlightChanged,
    this.onKeyDown,
  }) : super(key: key);

  @override
  State<K9sTable> createState() => _K9sTableState();
}

class _K9sTableState extends State<K9sTable> {
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _updateIndex(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.rows.length) return;
    setState(() {
      _selectedIndex = newIndex;
    });
    widget.onHighlightChanged?.call(_selectedIndex);
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _updateIndex(_selectedIndex + 1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _updateIndex(_selectedIndex - 1);
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (widget.rows.isNotEmpty) {
           widget.rows[_selectedIndex].onSelect?.call();
           widget.onEnter?.call();
        }
      } else {
        widget.onKeyDown?.call(event, _selectedIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // K9s colors
    const headerColor = Color(0xFF00FFFF); // Cyan for headers
    const rowColor = Colors.transparent;
    const selectedColor = Color(0xFF00FFFF); // Cyan background for selection
    const defaultTextColor = Colors.white;
    const selectedTextColor = Colors.black;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: widget.columns.map((col) {
                return Expanded(
                  flex: (col.flex * 10).toInt(),
                  child: Text(
                    col.title.toUpperCase(),
                    style: const TextStyle(
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Courier', // Monospace for terminal feel
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              }).toList(),
            ),
          ),
          // Body
          Expanded(
            child: ListView.builder(
              itemCount: widget.rows.length,
              itemBuilder: (context, index) {
                final row = widget.rows[index];
                final isSelected = index == _selectedIndex;
                
                return GestureDetector(
                  onTap: () {
                    _updateIndex(index);
                    row.onSelect?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    color: isSelected ? selectedColor : rowColor,
                    child: Row(
                      children: List.generate(widget.columns.length, (colIndex) {
                        final col = widget.columns[colIndex];
                        final text = row.cells.length > colIndex ? row.cells[colIndex] : '';
                        
                        // Determine text color
                        Color textColor = isSelected ? selectedTextColor : defaultTextColor;
                        if (!isSelected && row.statusColor != null && col.title == 'STATUS') {
                           textColor = row.statusColor!;
                        }

                        return Expanded(
                          flex: (col.flex * 10).toInt(),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontFamily: 'Courier',
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer / Status Bar place holder (can be added by parent)
        ],
      ),
    );
  }
}
