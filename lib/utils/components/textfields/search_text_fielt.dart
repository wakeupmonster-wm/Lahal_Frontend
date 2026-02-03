import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? hintTextColor;
  final Color? fillColor;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prifix;
  final double? textFieldHeight;
  final FocusNode? focusNode;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final String? validator;

  const MySearchTextFeild({
    super.key,
    this.controller,
    required this.hintText,
    this.onChange,
    this.onTap,
    this.textFieldHeight,
    this.suffix,
    this.prifix,
    this.fillColor,
    this.validator,
    this.focusNode,
    this.onSubmit,
    this.maxLines,
    this.hintTextColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    double borderRadius = width * 0.03;

    OutlineInputBorder lineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: width * 0.003, color: Colors.white),
    );
    return Container(
      // height: 80,
      // decoration: ReusableDecoration.reusableBoxDecoration(
      //     color: fillColor ?? Colors.white, context: context),
      decoration: BoxDecoration(
        color: fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColor.greyTextColor.withOpacity(0.2), // Shadow color
            blurRadius: 0.5, // Spread of the shadow
            spreadRadius: 0.5, // Extent of the shadow in all directions
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        onTap: onTap,
        keyboardType: keyboardType,
        onChanged: onChange,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        cursorColor: Colors.black,
        maxLines: maxLines ?? 1,
        style: TextStyle(fontSize: width * 0.03, color: AppColor.primaryColor1),
        autocorrect: true,
        enableSuggestions: true,
        decoration: InputDecoration(
          suffixIconConstraints: BoxConstraints(
            minHeight: height * 0.055,
            minWidth: width * 0.07,
          ),
          suffixIcon: suffix ?? const SizedBox(),
          prefixIcon: prifix ?? const SizedBox(),
          prefixIconConstraints: BoxConstraints(
            minHeight: height * 0.05,
            minWidth: width * 0.07,
          ),
          contentPadding: EdgeInsets.zero,
          // contentPadding: EdgeInsets.only(top: 0, left: width * 0.0, right: 50),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: hintText,
          hintStyle: GoogleFonts.manrope(
            color: AppColor.greyTextColor,
            fontSize: width * 0.03,
            fontWeight: FontWeight.w600,
          ),

          fillColor: fillColor ?? Colors.transparent,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: AppColor.primaryColor4,
              width: width * 0.003,
            ),
          ),
          enabledBorder: lineBorder,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusColor: Colors.white,
        ),
        focusNode: focusNode,
        onFieldSubmitted: onSubmit,
      ),
    );
  }
}
