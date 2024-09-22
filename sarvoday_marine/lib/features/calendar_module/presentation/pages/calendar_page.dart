import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_floating_action.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_no_available_widget.dart';
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
  DateTime? _previousFirstDayOfWeek;
  DateTime? _previousLastDayOfWeek;
  DateTime? _selectedDay;
  bool isClientOREmployee = false;
  bool isClientOrSuperAdmin = false;

  final ScrollController _scrollController = ScrollController();
  Map<DateTime, List<SalesOrderModel>> events = {};
  DateTime today = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(_onScroll);
      _previousFirstDayOfWeek = _getFirstDayOfWeek(_focusedDay);
      _previousLastDayOfWeek = _getLastDayOfWeek(_focusedDay);

      await context.read<CalendarCubit>().getUserType();
      if (mounted) {
        isClientOREmployee =
            (context.read<CalendarCubit>().userType == 'client' ||
                context.read<CalendarCubit>().userType == 'employee');
        isClientOrSuperAdmin =
            (context.read<CalendarCubit>().userType == 'client' ||
                context.read<CalendarCubit>().userType == 'superAdmin');
      }
      await _fetchDataForWeek();
    });
  }

  Future<void> _fetchDataForWeek() async {
    if (_previousFirstDayOfWeek != null && _previousLastDayOfWeek != null) {
      await context.read<CalendarCubit>().getSalesOrdersForWeek(
          _focusedDay, _previousFirstDayOfWeek!, _previousLastDayOfWeek!);
    }
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        _refreshData();
      }
    }
  }

  Future<void> _refreshData() async {
    await _fetchDataForWeek();
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);

    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: "Dashboard").appBar(),
      drawer:
          DrawerWidget(userRole: context.read<CalendarCubit>().userType ?? ""),
      drawerEnableOpenDragGesture: true,
      floatingActionButton: isClientOREmployee
          ? null
          : CommonFloatingAction(
              context: context,
              onPressed: () async {
                final result = await context.router.push(
                  AddUpdateSalesOrderRoute(
                      isFromEdit: false,
                      isClientOrSuperAdmin: isClientOrSuperAdmin,
                      isDisabled: isClientOREmployee),
                );
                if (result != null) {
                  await _fetchDataForWeek();
                }
              }).addActionButton(),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CMStateOnSuccess) {
            events = state.response;
          }
          return Column(
            children: [
              SizedBox(height: SmTextTheme.getResponsiveSize(context, 8)),
              TableCalendar<SalesOrderModel>(
                firstDay: DateTime.utc(24, 01, 01),
                lastDay: DateTime.now().add(const Duration(days: 365 * 3)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                  context.read<CalendarCubit>().setSelectedDay(selectedDay);
                },
                onFormatChanged: (format) {
                  _calendarFormat = format;
                  context.read<CalendarCubit>().setCalendarFormat(format);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  context.read<CalendarCubit>().setFocusedDay(focusedDay);
                  DateTime firstDayOfWeek = _getFirstDayOfWeek(focusedDay);
                  DateTime lastDayOfWeek = _getLastDayOfWeek(focusedDay);

                  if (firstDayOfWeek != _previousFirstDayOfWeek ||
                      lastDayOfWeek != _previousLastDayOfWeek) {
                    _previousFirstDayOfWeek = firstDayOfWeek;
                    _previousLastDayOfWeek = lastDayOfWeek;
                    _fetchDataForWeek();
                  }
                },
                eventLoader: (day) => events[day] ?? [],
              ),
              SizedBox(height: SmTextTheme.getResponsiveSize(context, 8)),
              state is CMStateLoading
                  ? const Center(child: CircularProgressIndicator())
                  : events.isEmpty
                      ? const NoItemsAvailable()
                      : Expanded(
                          child: _buildEventList(events),
                        ),
            ],
          );
        },
      ),
    );
  }

  DateTime _getFirstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  DateTime _getLastDayOfWeek(DateTime date) {
    return date.add(const Duration(days: 6));
  }

  Widget _buildEventList(Map<DateTime, List<SalesOrderModel>> events) {
    final orders =
        events[CommonMethods.normalizeDateTime(_selectedDay ?? _focusedDay)] ??
            [];

    return orders.isEmpty
        ? const NoItemsAvailable()
        : ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 12)),
                child: GestureDetector(
                  onTap: () async {
                    final result = await context.router.push(
                      AddUpdateSalesOrderRoute(
                          isFromEdit: true,
                          isClientOrSuperAdmin: isClientOrSuperAdmin,
                          salesOrderModel: orders[index],
                          isDisabled: isClientOREmployee),
                    );
                    if (result != null) {
                      await _fetchDataForWeek();
                    }
                  },
                  child: _buildOrderCard(orders[index]),
                ),
              );
            },
          );
  }

  Widget _buildOrderCard(SalesOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getCardRow(Icons.receipt_long, order.orderId.toString(),
                      SmTextTheme.infoContentStyle5(context)),
                  SizedBox(height: SmTextTheme.getResponsiveSize(context, 8)),
                  _getCardRow(Icons.person, order.clientName.toString(),
                      SmTextTheme.infoContentStyle5(context)),
                  SizedBox(height: SmTextTheme.getResponsiveSize(context, 8)),
                  _getCardRow(
                      Icons.home_repair_service,
                      order.services!.map((e) => e.serviceName).join(', '),
                      SmTextTheme.infoContentStyle4(context)),
                  SizedBox(height: SmTextTheme.getResponsiveSize(context, 8)),
                ],
              ),
            ),
            SizedBox(width: SmTextTheme.getResponsiveSize(context, 8)),
            SizedBox(
              height: SmTextTheme.getResponsiveSize(context, 75),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                          text: getOrderStatus(order),
                          style: SmTextTheme.infoContentStyle5(context))),
                  RichText(
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                          text: order.locationName.toString(),
                          style: SmTextTheme.infoContentStyle5(context))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCardRow(IconData icon, String data, TextStyle style) {
    return Row(
      children: [
        Icon(
          icon,
          color: SmCommonColors.secondaryColor,
          size: SmTextTheme.getResponsiveSize(context, 14),
        ),
        SizedBox(width: SmTextTheme.getResponsiveSize(context, 12)),
        Flexible(
            child: RichText(
                maxLines: 2,
                overflow: TextOverflow.clip,
                text: TextSpan(text: data, style: style))),
      ],
    );
  }

  String getOrderStatus(SalesOrderModel order) {
    if (order.orderDate != null && order.status == "booked") {
      final parsedOrderDate = DateTime.parse(order.orderDate!).toLocal();
      final today = DateTime.now();

      if (DateFormat('yyyy-MM-dd').format(today) ==
          DateFormat('yyyy-MM-dd').format(parsedOrderDate)) {
        return "Active";
      } else if (today.isAfter(parsedOrderDate)) {
        return "OverDue";
      }
    }

    return order.status.toString();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
