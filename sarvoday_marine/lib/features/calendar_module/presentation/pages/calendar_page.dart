import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_floating_action.dart';
import 'package:sarvoday_marine/features/calendar_module/calendar_injection_container.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/calendar_cubit.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/widgets/drawer_widget.dart';
import 'package:table_calendar/table_calendar.dart';

@RoutePage()
class CalendarPage extends StatefulWidget implements AutoRouteWrapper {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => calendarSl<CalendarCubit>(),
      child: this,
    );
  }
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  bool isClientOREmployee = false;

  Map<DateTime, List<SalesOrderModel>> events = {};

  List<SalesOrderModel> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<CalendarCubit>()
          .getAllSalesOrders(isFromCalendar: true);
      if (mounted) {
        await context.read<CalendarCubit>().getUserType();
      }
      if (mounted) {
        isClientOREmployee =
            (context.read<CalendarCubit>().userType == 'client' ||
                context.read<CalendarCubit>().userType == 'employee');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return BlocConsumer<CalendarCubit, CalendarState>(
      listener: (context, state) {
        if (state is CMStateLoading) {
          // showLoadingDialog(context);
        }
      },
      builder: (context, state) {
        if (state is CMStateOnSuccess) {
          // hideLoadingDialog(context);
          events = state.response;
        }
        return Scaffold(
          appBar: CommonAppBar(context: context, title: "Dashboard").appBar(),
          drawer: DrawerWidget(
              userRole: context.read<CalendarCubit>().userType ?? ""),
          drawerEnableOpenDragGesture: true,
          floatingActionButton: isClientOREmployee
              ? null
              : CommonFloatingAction(
                  context: context,
                  onPressed: () async {
                    context.router
                        .push(AddUpdateSalesOrderRoute(
                            isFromEdit: false, isDisabled: isClientOREmployee))
                        .then((Object? value) {
                      if (value != null && mounted) {
                        context
                            .read<CalendarCubit>()
                            .getAllSalesOrders(isFromCalendar: true);
                      }
                    });
                  }).addActionButton(),
          body: Column(
            children: [
              SizedBox(
                height: SmTextTheme.getResponsiveSize(context, 8),
              ),
              TableCalendar<SalesOrderModel>(
                firstDay: DateTime.utc(24, 01, 01),
                lastDay: DateTime.now().add(const Duration(days: 365 * 3)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: _getEventsForDay,
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _buildEventList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventList() {
    final order = _getEventsForDay(
        CommonMethods.normalizeDateTime(_selectedDay ?? _focusedDay));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: order.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 12)),
          child: GestureDetector(
            onTap: () {
              context.router
                  .push(AddUpdateSalesOrderRoute(
                      isFromEdit: true,
                      salesOrderModel: order[index],
                      isDisabled: isClientOREmployee))
                  .then((_) async {
                await context
                    .read<CalendarCubit>()
                    .getAllSalesOrders(isFromCalendar: true);
              });
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(
                  SmTextTheme.getResponsiveSize(context, 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getCardRow(
                              Icons.receipt_long,
                              order[index].orderId.toString(),
                              SmTextTheme.infoContentStyle5(context)),
                          SizedBox(
                            height: SmTextTheme.getResponsiveSize(context, 8),
                          ),
                          getCardRow(
                              Icons.person,
                              order[index].clientName.toString(),
                              SmTextTheme.infoContentStyle5(context)),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 8)),
                          getCardRow(
                              Icons.home_repair_service,
                              order[index]
                                  .services!
                                  .map((element) => element.serviceName)
                                  .join(', '),
                              SmTextTheme.infoContentStyle4(context)),
                          SizedBox(
                            height: SmTextTheme.getResponsiveSize(context, 8),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SmTextTheme.getResponsiveSize(context, 8),
                    ),
                    SizedBox(
                      height: SmTextTheme.getResponsiveSize(context, 75),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  text: order[index].status.toString(),
                                  style:
                                      SmTextTheme.infoContentStyle5(context))),
                          RichText(
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  text: order[index].locationName.toString(),
                                  style:
                                      SmTextTheme.infoContentStyle5(context))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCardRow(IconData icon, String data, TextStyle style) {
    return Row(
      children: [
        Icon(
          icon,
          color: SmCommonColors.secondaryColor,
          size: SmTextTheme.getResponsiveSize(context, 14),
        ),
        SizedBox(
          width: SmTextTheme.getResponsiveSize(context, 12),
        ),
        Flexible(
            child: RichText(
                maxLines: 2,
                overflow: TextOverflow.clip,
                text: TextSpan(text: data, style: style))),
      ],
    );
  }
}
