import 'package:listkontrakapp/model/enum_app.dart';

class ValidatorTextField{
    String validator(EnumValidatorTextFieldForm enumValidat,String value){
     switch (enumValidat) {
       case EnumValidatorTextFieldForm.email:
         {
           return _validatorEmail(value);
         }
         break;
       case EnumValidatorTextFieldForm.onlynumber:
         {
           return _validatorMustNumber(value);
         }
         break;
       case EnumValidatorTextFieldForm.bebas:
         {
           return null;
         }
         break;
       case EnumValidatorTextFieldForm.onlyText:
         {
           return _validatorOnlyText(value);
         }
         break;
       case EnumValidatorTextFieldForm.phoneNumber:
         {
           return this._validatorPhoneNumber(value);
         }
         break;
     }
     return null;
   }

   /// value tidak boleh null / kosong
   String _validatorEmail(value) {
     bool emailValid = RegExp(
         r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
         .hasMatch(value);
     if (emailValid) {
       return null;
     } else {
       return 'Email tidak valid.';
     }
   }

   /// value tidak boleh null / kosong
   String _validatorMustNumber(String value) {
     int val = int.tryParse(value);
     if (val == null) {
       return '* Harus angka positif.';
     } else {
       if (val < 0) {
         return '* Harus angka positif.';
       }
     }

     return null;
   }

   /// value tidak boleh null / kosong
   String _validatorOnlyText(String value) {
     bool emailValid = RegExp(r"^[a-zA-Z ]*$").hasMatch(value);
     if (emailValid) {
       return null;
     } else {
       return 'Harus text';
     }
   }

   /// value tidak boleh null / kosong
   String _validatorPhoneNumber(String value) {
     if (value.length <= 15) {
       bool phoneNumberValid =
       RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$")
           .hasMatch(value);
       if (phoneNumberValid) {
         return null;
       } else {
         return 'Nomor kontak tidak valid.';
       }
     } else {
       return 'Nomor kontak tidak valid.';
     }
   }
}