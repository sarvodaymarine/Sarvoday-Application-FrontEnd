import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

class ClientCardView extends StatelessWidget {
  const ClientCardView(
      {super.key,
      required this.name,
      required this.email,
      required this.mobile,
      required this.onDeleteClick,
      required this.isActive,
      required this.onDisableClick,
      required this.date});

  final String name;
  final String email;
  final String mobile;
  final bool isActive;
  final void Function(BuildContext)? onDisableClick;
  final void Function(BuildContext)? onDeleteClick;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.6,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.symmetric(
                  horizontal: SmTextTheme.getResponsiveSize(context, 4.0),
                  vertical: SmTextTheme.getResponsiveSize(context, 12.0)),
              borderRadius: BorderRadius.circular(
                  SmTextTheme.getResponsiveSize(context, 12.0)),
              onPressed: onDisableClick,
              backgroundColor: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.primaryColor
                  : SmColorLightTheme.primaryColor,
              foregroundColor: isActive
                  ? SmAppTheme.isDarkMode(context)
                      ? SmColorDarkTheme.backgroundColor
                      : SmColorLightTheme.backgroundColor
                  : SmCommonColors.secondaryColor,
              icon: isActive
                  ? Icons.lock_person_rounded
                  : Icons.person_add_rounded,
              label: isActive
                  ? StringConst.disableAccount
                  : StringConst.provideAuth,
            ),
            SlidableAction(
              padding: EdgeInsets.symmetric(
                  horizontal: SmTextTheme.getResponsiveSize(context, 4.0),
                  vertical: SmTextTheme.getResponsiveSize(context, 12.0)),
              borderRadius: BorderRadius.circular(
                  SmTextTheme.getResponsiveSize(context, 12.0)),
              onPressed: onDeleteClick,
              backgroundColor: SmCommonColors.errorColor,
              foregroundColor: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.backgroundColor
                  : SmColorLightTheme.backgroundColor,
              icon: Icons.delete,
              label: StringConst.deleteActionTxt,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: SmTextTheme.getResponsiveSize(context, 12.0),
                vertical: SmTextTheme.getResponsiveSize(context, 4.0)),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  SmTextTheme.getResponsiveSize(context, 12.0)),
            ),
            child: Padding(
              padding:
                  EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: name,
                        style: SmTextTheme.labelStyle3(context),
                      )),
                  SizedBox(
                      height: SmTextTheme.getResponsiveSize(context, 10.0)),
                  RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: email,
                        style: SmTextTheme.confirmButtonTextStyle(context)
                            .copyWith(
                                fontSize:
                                    SmTextTheme.getResponsiveSize(context, 14)),
                      )),
                  SizedBox(
                      height: SmTextTheme.getResponsiveSize(context, 4.0)),
                  RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: mobile,
                        style: SmTextTheme.labelDescriptionStyle(context)
                            .copyWith(
                                fontSize:
                                    SmTextTheme.getResponsiveSize(context, 12)),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RichText(
                        text: TextSpan(
                      text: DateFormat('d MMMM, yyyy')
                          .format(DateTime.parse(date)),
                      style: SmTextTheme.hintTextStyle(context),
                    )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
