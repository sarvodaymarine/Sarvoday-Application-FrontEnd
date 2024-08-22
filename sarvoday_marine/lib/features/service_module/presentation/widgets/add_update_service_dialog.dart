// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
// import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
// import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
// import 'package:sarvoday_marine/features/service_module/presentation/cubit/service_cubit.dart';
//
// class AddUpdateDialog {
//   static showAlertDialog(BuildContext context2, bool isEditDialog,
//       {String serviceName = "",
//       double container1Price = 0.0,
//       double container2Price = 0.0,
//       double container3Price = 0.0,
//       double container4Price = 0.0,
//       String serviceId = ""}) {
//     final FormGroup form = FormGroup({
//       "serviceName": FormControl<String>(validators: [
//         Validators.required,
//       ], value: serviceName),
//       "container1Price": FormControl<double>(validators: [
//         Validators.required,
//       ], value: container1Price),
//       "container2Price": FormControl<double>(validators: [
//         Validators.required,
//       ], value: container2Price),
//       "container3Price": FormControl<double>(validators: [
//         Validators.required,
//       ], value: container3Price),
//       "container4Price": FormControl<double>(validators: [
//         Validators.required,
//       ], value: container4Price),
//     });
//     return showDialog(
//       context: context2,
//       builder: (BuildContext context) {
//         SmTextTheme.init(context);
//         return AlertDialog(
//           title: Padding(
//             padding: EdgeInsets.only(
//                 left: SmTextTheme.getResponsiveSize(context, 8.0),
//                 top: SmTextTheme.getResponsiveSize(context, 12.0)),
//             child: RichText(
//               text: TextSpan(
//                   text: isEditDialog ? "Edit Service" : "Add Service",
//                   style: SmTextTheme.labelStyle3(context)),
//             ),
//           ),
//           content: SafeArea(
//             child: SingleChildScrollView(
//               child: Container(
//                 width: SmTextTheme.getResponsiveSize(context, 320),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                         SmTextTheme.getResponsiveSize(context, 12.0))),
//                 child: ReactiveForm(
//                   formGroup: form,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                       ReactiveTextField<String>(
//                         formControlName: "serviceName",
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16.0)),
//                           labelText: "Service Name",
//                           labelStyle: TextStyle(
//                               fontSize:
//                                   SmTextTheme.getResponsiveSize(context, 16.0),
//                               fontWeight: FontWeight.w400,
//                               color: SmAppTheme.isDarkMode(context)
//                                   ? SmColorDarkTheme.secondaryTextColor
//                                   : SmColorLightTheme.secondaryTextColor),
//                         ),
//                         validationMessages: {
//                           ValidationMessage.required: (error) =>
//                               "Service Name is Required",
//                         },
//                       ),
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                       ReactiveTextField<double>(
//                         formControlName: "container1Price",
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16.0)),
//                             labelText: "1 container price",
//                             labelStyle: TextStyle(
//                                 fontSize: SmTextTheme.getResponsiveSize(
//                                     context, 16.0),
//                                 fontWeight: FontWeight.w400,
//                                 color: SmAppTheme.isDarkMode(context)
//                                     ? SmColorDarkTheme.secondaryTextColor
//                                     : SmColorLightTheme.secondaryTextColor)),
//                         validationMessages: {
//                           ValidationMessage.required: (error) =>
//                               "Price is Required",
//                         },
//                       ),
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                       ReactiveTextField<double>(
//                         formControlName: "container2Price",
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16.0)),
//                             labelText: "2 container price",
//                             labelStyle: TextStyle(
//                                 fontSize: SmTextTheme.getResponsiveSize(
//                                     context, 16.0),
//                                 fontWeight: FontWeight.w400,
//                                 color: SmAppTheme.isDarkMode(context)
//                                     ? SmColorDarkTheme.secondaryTextColor
//                                     : SmColorLightTheme.secondaryTextColor)),
//                         validationMessages: {
//                           ValidationMessage.required: (error) =>
//                               "Price is Required",
//                         },
//                       ),
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                       ReactiveTextField<double>(
//                         formControlName: "container3Price",
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16.0)),
//                             labelText: "3 container price",
//                             labelStyle: TextStyle(
//                                 fontSize: SmTextTheme.getResponsiveSize(
//                                     context, 16.0),
//                                 fontWeight: FontWeight.w400,
//                                 color: SmAppTheme.isDarkMode(context)
//                                     ? SmColorDarkTheme.secondaryTextColor
//                                     : SmColorLightTheme.secondaryTextColor)),
//                         validationMessages: {
//                           ValidationMessage.required: (error) =>
//                               "Price is Required",
//                         },
//                       ),
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                       ReactiveTextField<double>(
//                         formControlName: "container4Price",
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16.0)),
//                             labelText: "4 container price",
//                             labelStyle: TextStyle(
//                                 fontSize: SmTextTheme.getResponsiveSize(
//                                     context, 16.0),
//                                 fontWeight: FontWeight.w400,
//                                 color: SmAppTheme.isDarkMode(context)
//                                     ? SmColorDarkTheme.secondaryTextColor
//                                     : SmColorLightTheme.secondaryTextColor)),
//                         validationMessages: {
//                           ValidationMessage.required: (error) =>
//                               "Price is Required",
//                         },
//                       ),
//                       SizedBox(
//                           height: SmTextTheme.getResponsiveSize(context, 20.0)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: RichText(
//                   text: TextSpan(
//                       text: 'Cancel',
//                       style: SmTextTheme.cancelButtonTextStyle(context)
//                           .copyWith(
//                               fontSize:
//                                   SmTextTheme.getResponsiveSize(context, 14)))),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: RichText(
//                   text: TextSpan(
//                       text: 'Submit',
//                       style: SmTextTheme.confirmButtonTextStyle(context)
//                           .copyWith(
//                               fontSize:
//                                   SmTextTheme.getResponsiveSize(context, 14)))),
//               onPressed: () async {
//                 if (form.valid) {
//                   if (isEditDialog) {
//                     await context2.read<ServiceCubit>().updatedService(
//                         serviceId,
//                         form.control("serviceName").value,
//                         form.control('container1Price').value,
//                         form.control('container2Price').value,
//                         form.control('container3Price').value,
//                         form.control('container4Price').value);
//                   } else {
//                     await context2.read<ServiceCubit>().addService(
//                         form.control("serviceName").value,
//                         form.control('container1Price').value,
//                         form.control('container2Price').value,
//                         form.control('container3Price').value,
//                         form.control('container4Price').value);
//                   }
//                 } else {
//                   form.markAllAsTouched();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
