import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFeild extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? confirmPasswordController;
  final String hintText;
  final Color? hintTextColor;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffix;
  final Widget? prefix;
  final double? textFieldHeight;
  final FocusNode? focusNode;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final TextInputType? keyboardType; // New parameter
  final String? validator;
  final bool? typingEnabled;
  final String? heightFormat;

  const MyTextFeild({
    super.key,
    this.controller,
    required this.hintText,
    this.onChange,
    this.textFieldHeight,
    this.suffix,
    this.fillColor,
    this.validator,
    this.focusNode,
    this.onSubmit,
    this.maxLines,
    this.maxLength,
    this.hintTextColor,
    this.keyboardType,
    this.typingEnabled,
    this.prefix,
    this.confirmPasswordController,
    this.heightFormat,
  });

  @override
  State<MyTextFeild> createState() => _MyTextFeildState();
}

class _MyTextFeildState extends State<MyTextFeild> {
  bool observeTextField = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    String inputText = widget.controller!.text;
    final isPasswordField =
        widget.validator == 'Password' || widget.validator == 'ConfirmPassword';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // height: textFieldHeight ?? height * 0.05,
          child: TextFormField(
            enabled: widget.typingEnabled ?? true,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            onChanged: widget.onChange,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: widget.controller,
            cursorColor: AppColor.primaryColor1,
            maxLines: widget.maxLines ?? 1,
            obscureText: isPasswordField ? observeTextField : false,
            inputFormatters: widget.validator == "Phone"
                ? [
                    FilteringTextInputFormatter.digitsOnly, // Only numbers
                    LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                  ]
                : [],
            decoration: InputDecoration(
              suffixIcon: isPasswordField
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          observeTextField = !observeTextField;
                        });
                      },
                      icon: Icon(
                        observeTextField
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
                        color: AppColor.primaryColor1,
                        size: width * 0.06,
                      ),
                    )
                  : widget.suffix ?? const SizedBox(),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.manrope(
                color: AppColor.primaryColor1.withAlpha(100),
                fontSize: width * 0.03,
                fontWeight: FontWeight.w700,
              ),
              contentPadding: EdgeInsets.only(top: 0, left: width * 0.035),
              hoverColor: AppColor.primaryColor1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.4),
              ),
              fillColor: widget.fillColor ?? Colors.transparent,
              filled: true,
              focusColor: Colors.black,
            ),
            validator: (value) {
              if (widget.validator == "Password") {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }

                // Password validation: At least 6 characters
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              } else if (widget.validator == "ConfirmPassword") {
                // Confirm password validation in the same structure as password
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
              } else if (widget.validator == "Height") {
                print('Height validation');
                print(widget.controller?.text);
                print(widget.heightFormat);
                print(value);

                if (value == null || value.isEmpty) {
                  return 'Please enter the Value';
                }

                // Regular expression to match numbers with up to 2 decimal places
                final RegExp decimalRegExp = RegExp(r'^\d+(\.\d{1,2})?$');

                if (!decimalRegExp.hasMatch(value)) {
                  return 'Please enter a valid height with up to 2 decimal places';
                }
                if (widget.heightFormat == 'cm') {
                  if (double.parse(value) < 60 || double.parse(value) > 304) {
                    return 'Height must be between 60 and 304 cm';
                  }
                } else if (widget.heightFormat == 'Feet') {
                  if (double.parse(value) < 2 || double.parse(value) > 10) {
                    return 'Height must be between 2 and 10 Feet';
                  }
                }

                return null;
              } else if (widget.validator == "Email") {
                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegExp.hasMatch(value!)) {
                  return 'Please enter a valid email address';
                }
              } else if (widget.validator == "Phone") {
                // Phone number validation: 10 digits
                final phoneRegExp = RegExp(r'^\d{10}$');
                if (!phoneRegExp.hasMatch(value!)) {
                  return 'Please enter a valid phone number';
                }
              } else if (widget.validator == "Name") {
                if (value == null || value.trim().isEmpty) {
                  return 'Name cannot be empty';
                }
                final trimmedValue = value.trim();
                final nameRegExp = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
                if (!nameRegExp.hasMatch(trimmedValue)) {
                  return 'Only letters and single spaces between words are allowed';
                }
                return null;
              }
              // else if (widget.validator == "Name") {
              //   // Updated regex to allow letters, numbers, underscores, and spaces
              //   // final usernameRegExp = RegExp(r'^[a-zA-Z0-9_ ]+$');
              //   print(widget.validator);
              //   // final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
              //
              //   final usernameRegExp = RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$');
              //
              //   print("(((((((+++++++++++++++++)))))))");
              //   print(inputText.isEmpty);
              //   if (inputText.trim().isEmpty) {
              //     return 'Name cannot be empty';
              //   }
              //   print(widget.controller!.text.isEmpty);
              //   print(value);
              //   if (!usernameRegExp.hasMatch(value!) ||
              //       inputText.trim().isEmpty) {
              //     return 'Only letters and a single space between words are allowed';
              //   }
              //   return null;
              // }
              else if (widget.validator == "LastName") {
                if (value == null || value.trim().isEmpty) {
                  return 'Last Name cannot be empty';
                }
                final trimmedValue = value.trim();
                final nameRegExp = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
                if (!nameRegExp.hasMatch(trimmedValue)) {
                  return 'Only letters and single spaces between words are allowed';
                }
                return null;
                // // Updated regex to allow letters, numbers, underscores, and spaces
                // // final usernameRegExp = RegExp(r'^[a-zA-Z0-9_ ]+$');
                // print(widget.validator);
                // // final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
                //
                // final usernameRegExp = RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$');
                //
                // print("(((((((+++++++++++++++++)))))))");
                // print(inputText.isEmpty);
                // if (inputText.trim().isEmpty) {
                //   return 'Last name cannot be empty';
                // }
                // print(widget.controller!.text.isEmpty);
                // print(value);
                // if (!usernameRegExp.hasMatch(value!) ||
                //     inputText.trim().isEmpty) {
                //   return 'Only letters and a single space between words are allowed';
                // }
                // return null;
              } else if (widget.validator == "ConfirmPassword1") {
                print("(((((((+++++++++++++++++)))))))");
                print(value);
                print(widget.confirmPasswordController?.text);
                return Validator.validateConfirmPassword(
                  value: value,
                  valController: widget.confirmPasswordController?.text ?? '',
                );
              }
              // else if (widget.validator == "Name") {
              //   // Phone number validation: 10 digits
              //   final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
              //   if (!usernameRegExp.hasMatch(value!)) {
              //     return 'Name  can only contain letters, numbers, and underscores';
              //   }
              //   return null;
              // }
              else if (value == null || value.isEmpty) {
                // _debouncer.run(() {
                //
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Center(
                //         child: MyTextLato(
                //           text: "Please enter the Value In Each Field",
                //           fontSize: width * 0.035,
                //         )),
                //   ));
                // });
                return 'Please enter the Value';
              } else if (value.trim().isEmpty) {
                return 'Filed Cannot be empty or only contain spaces ';
              }
            },
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}

class NewMyTextFeild extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? hintTextColor;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffix;
  final Widget? prefix;
  final double? textFieldHeight;
  final FocusNode? focusNode;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final TextInputType? keyboardType; // New parameter
  final String? Function(String?)? validator;
  final bool? typingEnabled;
  final String? heightFormat;
  final bool? isPasswordField;

  const NewMyTextFeild({
    super.key,
    this.controller,
    required this.hintText,
    this.onChange,
    this.textFieldHeight,
    this.suffix,
    this.fillColor,
    this.validator,
    this.focusNode,
    this.onSubmit,
    this.maxLines,
    this.maxLength,
    this.hintTextColor,
    this.keyboardType,
    this.typingEnabled,
    this.prefix,
    this.heightFormat,
    this.isPasswordField,
  });

  @override
  State<NewMyTextFeild> createState() => _NewMyTextFeildState();
}

class _NewMyTextFeildState extends State<NewMyTextFeild> {
  bool observeTextField = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // height: textFieldHeight ?? height * 0.05,
          child: TextFormField(
            enabled: widget.typingEnabled ?? true,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            onChanged: widget.onChange,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: widget.controller,
            cursorColor: AppColor.primaryColor1,
            maxLines: widget.maxLines ?? 1,
            obscureText: widget.isPasswordField ?? false
                ? observeTextField
                : false,
            decoration: InputDecoration(
              suffixIcon: widget.isPasswordField ?? false
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          observeTextField = !observeTextField;
                        });
                      },
                      icon: Icon(
                        observeTextField
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
                        color: AppColor.primaryColor1,
                        size: width * 0.06,
                      ),
                    )
                  : widget.suffix ?? const SizedBox(),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.manrope(
                color: AppColor.primaryColor1,
                fontSize: width * 0.03,
                fontWeight: FontWeight.w700,
              ),
              contentPadding: EdgeInsets.only(top: 0, left: width * 0.035),
              hoverColor: AppColor.primaryColor1,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primaryColor1,
                  width: 1.4,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.4),
              ),
              fillColor: widget.fillColor ?? Colors.transparent,
              filled: true,
              focusColor: Colors.black,
            ),
            validator: widget.validator,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}
