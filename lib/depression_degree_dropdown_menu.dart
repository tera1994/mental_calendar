import 'package:flutter/material.dart';

class DepressionDegreeDropdownMenu extends StatefulWidget {
  DepressionDegreeDropdownMenu({Key? key}) : super(key: key);

  String isSelectedValue = 'わからない';

  @override
  State<DepressionDegreeDropdownMenu> createState() => _DDepressionDegreeDropdownMenuState();
}

class _DDepressionDegreeDropdownMenuState extends State<DepressionDegreeDropdownMenu> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: const[
        DropdownMenuItem(
          value: 'ない',
          child: Text('ない'),
        ),
        DropdownMenuItem(
            value: 'ほとんどない',
            child: Text('ほとんどない'),
        ),
        DropdownMenuItem(
            value: 'わからない',
            child: Text('わからない'),
        ),
        DropdownMenuItem(
            value: 'すこしある',
            child: Text('すこしある'),
        ),
        DropdownMenuItem(
            value: 'ある',
            child: Text('ある'),
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