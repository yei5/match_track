import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddImageBox extends StatelessWidget {
  final VoidCallback onTap;
  const AddImageBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: const RectDottedBorderOptions(
          color: Colors.grey,
          strokeWidth: 1.5,
          dashPattern: [6, 3],
          borderPadding: EdgeInsets.all(6),
          strokeCap: StrokeCap.round,
        ),
        childOnTop: true,
        ignoring: true,
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_outlined, size: 30, color: Colors.grey),
                SizedBox(height: 6),
                Text('Subir imagen', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
