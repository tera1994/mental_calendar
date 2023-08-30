import 'package:flutter/material.dart';

class DepressionDegreeDropdownMenu extends StatefulWidget {
  DepressionDegreeDropdownMenu({Key? key}) : super(key: key);

  String isSelectedValue = '普通';

  @override
  State<DepressionDegreeDropdownMenu> createState() => _DepressionDegreeDropdownMenuState();
}

class _DepressionDegreeDropdownMenuState extends State<DepressionDegreeDropdownMenu> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: const[
        DropdownMenuItem(
          value: '良い',
          child: Text('良い'),
        ),
        DropdownMenuItem(
            value: '少し良い',
            child: Text('少し良い'),
        ),
        DropdownMenuItem(
            value: '普通',
            child: Text('普通'),
        ),
        DropdownMenuItem(
            value: '少し悪い',
            child: Text('少し悪い'),
        ),
        DropdownMenuItem(
            value: '悪い',
            child: Text('悪い'),
        ),
      ],
      value: widget.isSelectedValue,
      onChanged: (String? value) {
        setState(() {
          widget.isSelectedValue = value!;
        });
      },
    );
  }
}