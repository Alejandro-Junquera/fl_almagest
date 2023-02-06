import 'package:fl_almagest/models/oders.dart';
import 'package:fl_almagest/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrdersService>(context);
    List<DataOrders> orders = [];
    orders = ordersService.orders;
    if (ordersService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    Color color;
    Color color2;
    DateTime now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: orders.length,
                  itemBuilder: (BuildContext ctx, index) {
                    if (DateTime.parse(orders[index].issueDate.toString())
                            .compareTo(date) >
                        0) {
                      color = Colors.red;
                    } else {
                      color = Colors.green;
                    }
                    if (orders[index].invoices == 0) {
                      color2 = Colors.red;
                    } else {
                      color2 = Colors.green;
                    }

                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.25,
                                top: 5),
                            child: Text(orders[index].num.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              orders[index].targetCompanyName.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            orders[index].createdAt.toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            orders[index].issueDate.toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.flight, color: color),
                                Icon(Icons.playlist_add_check_circle,
                                    color: color2),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('neworder');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
