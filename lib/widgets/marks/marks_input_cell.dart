// widgets/marks/marks_input_cell.dart
import 'package:flutter/material.dart';
import 'package:lms/models/marks.dart';

class MarksInputCell extends StatefulWidget {
  final MarkEntry markEntry;
  final Function(double? marks, bool isAbsent) onChanged;
  final bool isMobile;

  const MarksInputCell({
    required this.markEntry,
    required this.onChanged,
    this.isMobile = false,
  });

  @override
  _MarksInputCellState createState() => _MarksInputCellState();
}

class _MarksInputCellState extends State<MarksInputCell> {
  final TextEditingController _controller = TextEditingController();
  bool _isAbsent = false;

  @override
  void initState() {
    super.initState();
    _isAbsent = widget.markEntry.isAbsent;
    _updateController();
  }

  void _updateController() {
    if (!_isAbsent && widget.markEntry.marksObtained != null) {
      _controller.text = widget.markEntry.marksObtained!.toStringAsFixed(0);
    } else {
      _controller.text = '';
    }
  }

  void _onMarksChanged(String value) {
    if (_isAbsent) return;
    final marks = double.tryParse(value);
    widget.onChanged(marks, _isAbsent);
  }

  void _onAbsentChanged(bool? value) {
    setState(() {
      _isAbsent = value ?? false;
      _updateController();
      widget.onChanged(null, _isAbsent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMobile ? _buildMobileCell() : _buildDesktopCell();
  }

  Widget _buildDesktopCell() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            height: 40,
            child: TextField(
              controller: _controller,
              enabled: !_isAbsent,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: _isAbsent ? 'Absent' : 'Marks',
                hintStyle: TextStyle(color: _isAbsent ? Colors.red : Colors.grey),
              ),
              onChanged: _onMarksChanged,
              style: TextStyle(color: _isAbsent ? Colors.red : Colors.black),
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Absent', style: TextStyle(fontSize: 12)),
              SizedBox(width: 4),
              Checkbox(
                value: _isAbsent,
                onChanged: _onAbsentChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          Text('/${widget.markEntry.totalMarks.toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMobileCell() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.markEntry.subjectName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  child: TextField(
                    controller: _controller,
                    enabled: !_isAbsent,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: _isAbsent ? 'Abs' : '0',
                    ),
                    onChanged: _onMarksChanged,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Checkbox(value: _isAbsent, onChanged: _onAbsentChanged),
              Text('Abs', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}