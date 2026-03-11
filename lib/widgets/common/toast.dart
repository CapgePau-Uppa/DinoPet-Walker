
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class Toast {
  static void show ({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color color
  }){
    DelightToastBar(
      builder: (context){
        return ToastCard(
          leading: Icon(icon,color: color,),
          title: Text(
            message,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 17
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3)
    ).show(context);
  }
}