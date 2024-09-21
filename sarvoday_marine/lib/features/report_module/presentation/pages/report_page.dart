import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_no_available_widget.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/presentation/cubit/report_cubit.dart';
import 'package:sarvoday_marine/features/report_module/report_injection_container.dart';

@RoutePage()
class ReportPage extends StatefulWidget implements AutoRouteWrapper {
  const ReportPage({super.key, required this.orderId});

  final String orderId;

  @override
  State<ReportPage> createState() => _ReportPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => reportSl<ReportCubit>(),
      child: this,
    );
  }
}

class _ReportPageState extends State<ReportPage> {
  ReportModel? reportDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ReportCubit>().getReportDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: StringConst.smReportTitle,
      ).appBar(),
      body: BlocConsumer<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is StateErrorGeneral) {
            CommonMethods.showToast(context, state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is StateOnSuccess) {
            reportDetail = state.response;
          } else if (state is StateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: reportDetail != null &&
                    reportDetail?.serviceReports != null &&
                    reportDetail!.serviceReports!.isNotEmpty
                ? Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(
                            SmTextTheme.getResponsiveSize(context, 12)),
                        itemCount: reportDetail?.serviceReports?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              trailing: SizedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SmTextTheme.getResponsiveSize(
                                                    context, 12)),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Icon(
                                            reportDetail?.serviceReports?[index]
                                                        .reportStatus ==
                                                    "Reviewed"
                                                ? Icons.remove_red_eye
                                                : reportDetail
                                                            ?.serviceReports?[
                                                                index]
                                                            .reportStatus ==
                                                        "Completed"
                                                    ? Icons.check_circle
                                                    : Icons.pending,
                                            color: reportDetail
                                                        ?.serviceReports?[index]
                                                        .reportStatus ==
                                                    "Reviewed"
                                                ? SmColorLightTheme
                                                    .primaryDarkColor
                                                : reportDetail
                                                            ?.serviceReports?[
                                                                index]
                                                            .reportStatus ==
                                                        "Completed"
                                                    ? SmCommonColors.greenColor
                                                    : SmCommonColors
                                                        .secondaryColor,
                                          ),
                                        )),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        color: SmCommonColors.secondaryColor),
                                  ],
                                ),
                              ),
                              title: RichText(
                                  text: TextSpan(
                                      text: reportDetail
                                          ?.serviceReports?[index].serviceName,
                                      style: SmTextTheme.labelStyle3(context))),
                              onTap: () {
                                AutoRouter.of(context).push(ServiceDetailRoute(
                                    serviceId: reportDetail
                                            ?.serviceReports?[index]
                                            .serviceId ??
                                        "",
                                    orderId: widget.orderId,
                                    reportId: reportDetail?.id ?? ""));
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : const NoItemsAvailable(),
          );
        },
      ),
    );
  }
}
