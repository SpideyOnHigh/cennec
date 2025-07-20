import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';

class CustomConnectionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final double fontSize;
  final Function(String)? onChanged;

  const CustomConnectionTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.fontSize = 16,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomConnectionTextField> createState() => _CustomConnectionTextFieldState();
}

class _CustomConnectionTextFieldState extends State<CustomConnectionTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _isEditing = false);
      }
    });
  }

  void _handleTap() {
    setState(() => _isEditing = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    // Show static view if not editing and has text
    if (!_isEditing && hasText) {
      return GestureDetector(
        onTap: _handleTap,
        child: Column(
          children: [
            Text(
              widget.controller.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w600,
                fontSize: widget.fontSize,
                color: AppColors.colorGrey,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: double.infinity,
              color: AppColors.colorGreyExtraLight,
            )
          ],
        ),
      );
    }

    // Show placeholder style view if empty and not editing
    if (!_isEditing && !hasText) {
      return GestureDetector(
        onTap: _handleTap,
        child: Column(
          children: [
            Text(
              widget.hintText ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w400,
                fontSize: widget.fontSize,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: double.infinity,
              color: Colors.black26,
            )
          ],
        ),
      );
    }

    // Editable textfield
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      autofocus: true,
      textAlign: TextAlign.center,
      cursorColor: AppColors.colorDarkBlue,
      style: TextStyle(
        fontFamily: AppFont.poppins,
        fontWeight: FontWeight.w600,
        fontSize: widget.fontSize,
        color: AppColors.colorHyperLink.withOpacity(0.8),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: AppFont.poppins,
          fontWeight: FontWeight.w400,
          fontSize: widget.fontSize,
          color: AppColors.colorHyperLink,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorDarkBlue, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorDarkBlue, width: 2),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorDarkBlue, width: 2),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 4),
      ),
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
    );
  }
}
