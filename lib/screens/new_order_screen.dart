import 'dart:io';
import 'dart:math';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:fl_almagest/models/catalog.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../models/cicles.dart';
import '../providers/register_form_provider.dart';
import '../services/cicles_service.dart';
import '../services/user_alone.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Form(
          child: Column(children: [
            ChangeNotifierProvider(
              create: (_) => RegisterFormProvider(),
              child: const _RegisterForm(),
            ),
          ]),
        )),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({super.key});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  List<CatalogData> products = [];
  List<bool> isChecked = [];
  Map<String, String> pedido = {};
  String? company_id = "";
  getCompanyId() async {
    company_id = await UserAloneService().readCompany_id();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyId();
  }

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final ciclesService = Provider.of<CiclesService>(context);
    final productsService = Provider.of<CatalogService2>(context);
    List<Data> ciclos = ciclesService.ciclos;
    List<Data> aux = [];

    Data miEmpresa = Data();
    double precioTotal = 0;
    getPrecio(int cant, double precio) {
      double preci = cant * precio;
      precioTotal += preci;
      return preci;
    }

    for (var i in ciclos) {
      if (i.id.toString() != company_id) {
        aux.add(i);
      }
    }
    for (var i in ciclos) {
      if (i.id.toString() == company_id) {
        miEmpresa = i;
      }
    }

    DateTime now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String fechaFormat = formatter.format(date);
    Future<String> getlocalPath() async {
      final directory = await getApplicationDocumentsDirectory();

      return directory.path;
    }

    getList() async {
      products.clear();
      await productsService.getCatalog(registerForm.cicle_id);
      setState(() {
        products = productsService.aux;
        isChecked = List<bool>.filled(products.length, false);
      });
    }

    return Column(
      children: [
        DropdownButtonFormField(
          hint: const Text('Select a company'),
          items: aux.map((e) {
            return DropdownMenuItem(
              value: e.id,
              child: Text(e.name.toString()),
            );
          }).toList(),
          onChanged: (value) {
            registerForm.cicle_id = value!;
          },
          validator: (value) {
            return (value != null && value != 0) ? null : 'select a Company';
          },
        ),
        const SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          elevation: 0,
          color: Colors.blueGrey[600],
          onPressed: () {
            getList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (BuildContext ctxt, int index) {
              double valorPrueba = 0;
              return Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.blueGrey[500],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[index] = value!;
                            if (!isChecked[index]) {
                              pedido
                                  .remove(products[index].articleId.toString());
                            }
                          });
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text(
                          products[index].compamyDescription.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Visibility(
                          visible: isChecked[index],
                          child: SpinBox(
                              min: 1,
                              max: 40,
                              step: 1,
                              readOnly: true,
                              decimals: 0,
                              value: valorPrueba,
                              onChanged: (value) {
                                valorPrueba = value;
                                print(pedido);
                                pedido[products[index].articleId.toString()] =
                                    value.toInt().toString();
                              }),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          elevation: 0,
          color: Colors.blueGrey[600],
          onPressed: () async {
            if (pedido.isEmpty) {
              customToast('No se ha seleccionado ningun producto', context);
            } else {
              final newOrderService =
                  Provider.of<NewOrderService>(context, listen: false);
              int num = 1 + Random().nextInt((99999 + 1) - 1);
              newOrderService.getNewOrder(num.toString(), pedido, date,
                  company_id!, registerForm.cicle_id.toString());
              final pdf = pw.Document();
              Data targetCompany = Data();
              for (var i in ciclos) {
                if (i.id.toString() == registerForm.cicle_id.toString()) {
                  targetCompany = i;
                }
              }
              pdf.addPage(pw.Page(
                  pageFormat: PdfPageFormat.a4,
                  build: (pw.Context context) {
                    return pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(targetCompany.name.toString()),
                                  pw.Text(targetCompany.address.toString()),
                                  pw.Text(targetCompany.city.toString()),
                                  pw.Text(targetCompany.cif.toString()),
                                  pw.Text(targetCompany.email.toString()),
                                ]),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(children: [
                                    pw.Text('PEDIDO Nº: ',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text(num.toString())
                                  ]),
                                  pw.SizedBox(height: 50),
                                  pw.Row(children: [
                                    pw.Text('FECHA: ',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text(fechaFormat)
                                  ]),
                                ])
                          ]),
                      pw.SizedBox(height: 25),
                      pw.Row(children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(children: [
                                pw.Text("DIRECCIÓN DE ENVÍO: ",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(miEmpresa.address.toString())
                              ]),
                              pw.Row(children: [
                                pw.Text("TRANSPORTE: ",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text("A NUESTRO CARGO")
                              ]),
                            ])
                      ]),
                      pw.SizedBox(height: 20),
                      pw.Table(border: pw.TableBorder.all(), children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("REF. COD",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("DESCRIPCIÓN",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("CANTIDAD",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("PRECIO",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("IMPORTE",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                        ]),
                        for (var producto in products)
                          for (var entry in pedido.entries)
                            if (producto.articleId.toString() == entry.key)
                              pw.TableRow(children: [
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(producto.articleId.toString()),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(producto.compamyDescription
                                          .toString()),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(pedido[
                                              producto.articleId.toString()] ??
                                          'Err data not founf'),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(producto.price.toString()),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(getPrecio(
                                              int.parse(pedido[producto
                                                      .articleId
                                                      .toString()] ??
                                                  "1"),
                                              double.parse(producto.price!))
                                          .toStringAsFixed(2)),
                                    ]),
                              ]),
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("TOTAL: ",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: []),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: []),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: []),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(precioTotal.toString()),
                              ])
                        ])
                      ])
                    ]);
                  }));

              final file = File(
                  "${"/storage/emulated/0/Download/" + "pedido" + num.toString()}.pdf");
              await file.writeAsBytes(await pdf.save());
              final Email email = Email(
                body: 'Se adjunta una copia de su pedido realizado',
                subject: 'Pedido realizado',
                recipients: ['raulreyes@cadiz.salesianos.edu '],
                attachmentPaths: [file.path],
                isHTML: false,
              );
              String platformResponse;

              try {
                await FlutterEmailSender.send(email);
                platformResponse = 'success';
              } catch (error) {
                platformResponse = error.toString();
              }
              customToast('Pedido realizado correctamente', context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'Realizar pedido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.blueGrey[500],
      alignment: Alignment.bottomCenter,
      position: StyledToastPosition.top,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromTop,
      context: context,
    );
  }
}
