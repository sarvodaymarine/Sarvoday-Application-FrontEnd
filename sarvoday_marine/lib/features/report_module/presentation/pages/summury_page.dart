import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/summary_item_model.dart';

@RoutePage()
class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key, required this.salesOrderModel});

  final SalesOrderModel? salesOrderModel;

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<ItemModel> data = [];

  @override
  void initState() {
    super.initState();
    if (widget.salesOrderModel != null) {
      List<ItemModel> services =
          widget.salesOrderModel!.services?.map((service) {
                return ItemModel(
                  name: service.serviceName ?? "service",
                  price: (service.price ?? 0).toStringAsFixed(2),
                  total: (service.totalPrice ?? 0).toStringAsFixed(2),
                );
              }).toList() ??
              [];

      List<ItemModel> taxes = widget.salesOrderModel!.tax?.map((tax) {
            return ItemModel(
              name: "tax (SGST + CGST)%",
              price:
                  "${(tax.cGST ?? 0.0).toStringAsFixed(2)}% \n${(tax.sGST ?? 0.0).toStringAsFixed(2)}% ",
              total: (tax.taxPrice ?? 0).toStringAsFixed(2),
            );
          }).toList() ??
          [];

      List<ItemModel> expenses =
          widget.salesOrderModel!.otherExpenses?.map((expense) {
                return ItemModel(
                  name: expense.expenseName ?? "Expenses",
                  price: (expense.price ?? 0).toStringAsFixed(2),
                  total: (expense.price ?? 0).toStringAsFixed(2),
                );
              }).toList() ??
              [];

      setState(() {
        data = [...services, ...expenses, ...taxes];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);

    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: "Summary",
      ).appBar(),
      body: Padding(
        padding: EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(
                color: Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: SmColorLightTheme.primaryColor,
                  ),
                  children: [
                    _buildTableCell('Name', isHeader: true),
                    _buildTableCell('Price', isHeader: true),
                    _buildTableCell('Total', isHeader: true),
                  ],
                ),
                ...data.map((item) => TableRow(
                      children: [
                        _buildTableCell(item.name),
                        _buildTableCell(item.price),
                        _buildTableCell(item.total),
                      ],
                    )),
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  children: [
                    _buildTableCell('Total Invoice', isHeader: true),
                    _buildTableCell(''),
                    _buildTableCell(
                        (widget.salesOrderModel?.totalInvoice ?? 0)
                            .toStringAsFixed(2),
                        isHeader: true),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
