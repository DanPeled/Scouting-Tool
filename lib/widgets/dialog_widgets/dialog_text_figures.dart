// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DialogTagTextInput extends StatefulWidget {
  final String title;
  final List<String> tags;
  final Function(String tag)? onTagAdded, onTagRemoved;
  final List<String>? initialSelection;

  const DialogTagTextInput(
      {super.key,
      required this.title,
      required this.tags,
      this.onTagAdded,
      this.onTagRemoved,
      this.initialSelection});

  @override
  State<DialogTagTextInput> createState() => _DialogTagTextInputState();
}

class _DialogTagTextInputState extends State<DialogTagTextInput> {
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> _selectedFigures = [];

  @override
  void initState() {
    super.initState();
    // Set the initial selection if provided
    if (widget.initialSelection != null) {
      _selectedFigures = List.from(widget.initialSelection!);
    }
  }

  List<String> _getSuggestions(String query) {
    return widget.tags
        .where((figure) =>
            figure.toLowerCase().contains(query.toLowerCase()) &&
            !_selectedFigures.contains(figure))
        .toList();
  }

  void _addFigure(String figure) {
    setState(() {
      if (!_selectedFigures.contains(figure)) {
        widget.onTagAdded?.call(figure);
        _selectedFigures.add(figure);
      }
    });
    _typeAheadController.clear();
  }

  void _removeFigure(String figure) {
    setState(() {
      widget.onTagRemoved?.call(figure);
      _selectedFigures.remove(figure);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Wrap selected items as tags within the search bar
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: _selectedFigures.map((figure) {
                    return Chip(
                      label: Text(figure),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeFigure(figure),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 5),
                // Autocomplete search bar next to the tags
                Expanded(
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _typeAheadController,
                      decoration: InputDecoration(
                        hintText: widget.title,
                        border: InputBorder.none,
                      ),
                    ),
                    suggestionsCallback: _getSuggestions,
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (String suggestion) {
                      _addFigure(suggestion);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
