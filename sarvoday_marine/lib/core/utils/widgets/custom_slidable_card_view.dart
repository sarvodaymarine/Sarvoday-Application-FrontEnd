import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

class CustomSlidableCardView extends StatelessWidget {
  const CustomSlidableCardView({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.isFromServicePage,
    required this.date,
    /*  this.container2Price = '',
      this.container3Price = '',
      this.container4Price = ''*/
  });

  final String title;
  final String subTitle;

/*  final String container2Price;
  final String container3Price;
  final String container4Price;*/
  final String date;
  final bool isFromServicePage;
  final void Function(BuildContext)? onEditClick;
  final void Function(BuildContext)? onDeleteClick;

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
              onPressed: onEditClick,
              backgroundColor: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.primaryColor
                  : SmColorLightTheme.primaryColor,
              foregroundColor: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.backgroundColor
                  : SmColorLightTheme.backgroundColor,
              icon: Icons.edit,
              label: StringConst.editActionTxt,
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
            color: SmAppTheme.isDarkMode(context)
                ? SmColorDarkTheme.cardColor
                : SmColorLightTheme.cardColor,
            shadowColor: SmAppTheme.isDarkMode(context)
                ? SmColorDarkTheme.onPrimary
                : SmColorLightTheme.onPrimary,
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
                        text: title,
                        style: SmTextTheme.infoLabelStyle(context).copyWith(
                            color: SmAppTheme.isDarkMode(context)
                                ? SmColorDarkTheme.primaryDarkColor
                                : SmColorLightTheme.primaryDarkColor,
                            fontWeight: FontWeight.bold),
                      )),
                  if (subTitle.isNotEmpty)
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 6.0)),
                  if (subTitle.isNotEmpty)
                    RichText(
                        maxLines: isFromServicePage ? 1 : 5,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: subTitle,
                          style: isFromServicePage
                              ? SmTextTheme.labelDescriptionStyle(context)
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: SmAppTheme.isDarkMode(context)
                                          ? SmColorDarkTheme.onSecondary
                                          : SmColorLightTheme.onSecondary)
                              : SmTextTheme.labelDescriptionStyle(context),
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
