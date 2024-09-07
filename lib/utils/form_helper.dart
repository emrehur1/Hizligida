import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    obscureText = false,
    Function? onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return TextFormField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: fieldDecoration(
        context,
        "",
        "",
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate!(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(16), // İçerik padding'i artırıldı
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // Kenar rengi gri olarak ayarlandı
          width: 2.0, // Kenar genişliği artırıldı
        ),
        borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlatıldı
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black, // Odaklanıldığında kenar rengi siyah olur
          width: 2.5, // Odaklanıldığında daha kalın bir kenar
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // Kenar rengi gri olarak ayarlandı
          width: 2.0, // Kenar genişliği artırıldı
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(BuildContext context, String labelName) {
    return FormHelper.textInput(
      context,
      labelName,
      (value) => {},
      onValidate: (value) {
        return null;
      },
      readOnly: false,
    );
  }

  static Widget saveButton(
    String buttonText,
    Function onTap, {
    String? color,
    String? textColor,
    bool? fullWidth,
  }) {
    return Container(
      height: 50.0,
      width: fullWidth == true ? double.infinity : 150, // Full width opsiyonu
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black, // Butonun arka plan rengini siyah yap
            borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 2), // Gölgenin pozisyonu
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white, // Yazı rengi beyaz
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    fontFamily: 'Poppins', // Yazı fontu olarak Poppins kullan
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget dropDownWidgetWithLabel(
    BuildContext context,
    String label,
    String hint,
    String? selectedValue,
    List<String> options,
    Function(String?) onChanged,
    String? Function(String?) validator, {
    String optionLabel = "",
    String optionValue = "",
    Color borderColor = Colors.grey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                return onPressed();
              },
              child: Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
