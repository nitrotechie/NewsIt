import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool selected;
  const CategoryCard(
      {required this.title,
      required this.onTap,
      this.selected = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
