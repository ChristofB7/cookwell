import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String header;
  final IconButton icon;

  Header({@required this.header, this.icon});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(header, style: textTheme.headline6,),),
              icon ?? SizedBox(),
            ],
          ),
        ),
        Divider(
          color: colorScheme.secondary,
          height: 10,
          thickness: 1,
          indent: 3,
          endIndent: 3,
        ),
      ],
    );
  }
}
