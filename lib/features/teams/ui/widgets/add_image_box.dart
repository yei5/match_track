import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class AddImageBox extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? selectedImageBytes;
  final Function(Uint8List)? onImageSelected;
  final VoidCallback? onTap;

  const AddImageBox({
    super.key,
    this.imageUrl,
    this.selectedImageBytes,
    this.onImageSelected,
    this.onTap,
  });

  @override
  State<AddImageBox> createState() => _AddImageBoxState();
}

class _AddImageBoxState extends State<AddImageBox> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _currentSelectedImageBytes;

  @override
  void initState() {
    super.initState();
    _currentSelectedImageBytes = widget.selectedImageBytes;
  }

  @override
  void didUpdateWidget(covariant AddImageBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedImageBytes != oldWidget.selectedImageBytes) {
      _currentSelectedImageBytes = widget.selectedImageBytes;
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _currentSelectedImageBytes = bytes;
        });
        widget.onImageSelected?.call(bytes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo seleccionar la imagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage? backgroundImage;
    if (_currentSelectedImageBytes != null) {
      backgroundImage = DecorationImage(
        image: MemoryImage(_currentSelectedImageBytes!),
        fit: BoxFit.cover,
      );
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      backgroundImage = DecorationImage(
        image: NetworkImage(widget.imageUrl!),
        fit: BoxFit.cover,
      );
    }

    return InkWell(
      onTap: widget.onTap ?? _pickImage,
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
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            image: backgroundImage,
          ),
          child: backgroundImage == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_outlined, size: 30, color: Colors.grey),
                      SizedBox(height: 6),
                      Text('Subir imagen', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
