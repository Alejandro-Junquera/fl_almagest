import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_almagest/models/models.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../models/articles.dart';
import '../models/catalog.dart';
import 'loading_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var contArticles = 0;
  var maxPermit = false;
  final catalogService = CatalogService();
  final articleService = ArticleService();
  bool visible = true;
  bool novisible = false;
  List<DataArticle> articles = [];
  List<DataArticle> articlesBuscar = [];
  List<CatalogData> catalog = [];
  Future getCatalog() async {
    setState(() => catalog.clear());
    await catalogService.getCatalog();
    setState(() {
      catalog = catalogService.catalogdata;
      contArticles = catalog.length;
      if (catalog.length == 5) {
        maxPermit = true;
      }
    });
  }

  Future getArticles() async {
    setState(() => catalog.clear());
    await articleService.getArticles();
    setState(() {
      articles = articleService.articles;
      articlesBuscar = articles;
    });
  }

  @override
  void initState() {
    super.initState();
    getCatalog();
    getArticles();
    articlesBuscar = articles;
  }

  void _runFilter(String enteredKeyword) {
    List<DataArticle> results = [];
    if (enteredKeyword.isEmpty) {
      results = articles;
    } else if (enteredKeyword == '###/') {
      articles.clear();
    } else {
      results = articles
          .where((x) => x.description!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      articlesBuscar = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final addProductService =
        Provider.of<ProductService>(context, listen: false);
    final deleteProductService =
        Provider.of<DeleteProductService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Personal Area : '),
          backgroundColor: Colors.blueGrey[800],
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              })),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.blueGrey,
        items: <Widget>[
          Icon(Icons.business_rounded, size: 30),
          Icon(Icons.add_business, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              visible = true;
              novisible = false;
              getCatalog();
            });
          } else if (index == 1) {
            setState(() {
              visible = false;
              novisible = true;
              getArticles();
            });
          }
        },
      ),
      body: catalogService.isLoading && articleService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Center(
                        child: Text('Catalog ' + contArticles.toString() + '/5',
                            style: Theme.of(context).textTheme.headline3),
                      ),
                    ),
                    visible: visible,
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            onChanged: (value) => _runFilter(value),
                            decoration: const InputDecoration(
                                labelText: '  Search',
                                suffixIcon: Icon(Icons.search)),
                          ),
                        ),
                      ],
                    ),
                    visible: novisible,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 500.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.elasticInOut,
                      ),
                      items: catalog.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.blueGrey, width: 5),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2),
                                      child: Text(i.id.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: AssetImage(
                                                  'assets/images/' +
                                                      i.compamyName.toString() +
                                                      '.jpg'))),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      i.compamyName.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      i.compamyDescription.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      i.price.toString() + '€',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      disabledColor: Colors.grey,
                                      elevation: 0,
                                      color: Colors.blueGrey[600],
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Delete Product'),
                                            content:
                                                const Text('Are you sure?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteProductService
                                                      .deleteProduct(i.id!);
                                                  setState(() {
                                                    catalog.removeWhere(
                                                        (element) =>
                                                            (element == i));
                                                    contArticles--;
                                                    if (contArticles < 5) {
                                                      maxPermit = false;
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80, vertical: 15),
                                        child: Text(
                                          'Remove Product',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        );
                      }).toList(),
                    ),
                    visible: visible,
                  ),
                  Visibility(
                    child: CarouselSlider(
                      options: CarouselOptions(height: 500.0),
                      items: articlesBuscar.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            double valorPrueba = double.parse(i.priceMin!);
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.blueGrey, width: 5),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5),
                                      child: Text(i.id.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: AssetImage(
                                                  'assets/images/' +
                                                      i.name.toString() +
                                                      '.jpg'))),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      i.name.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      i.description.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Precio:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(10),
                                            width: 150,
                                            height: 50,
                                            child: SpinBox(
                                                min: double.parse(i.priceMin!),
                                                max: double.parse(i.priceMax!),
                                                step: 0.1,
                                                readOnly: true,
                                                decimals: 2,
                                                value: valorPrueba,
                                                onChanged: (value) {
                                                  valorPrueba = value;
                                                })),
                                      ],
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      disabledColor: Colors.grey,
                                      elevation: 0,
                                      color: Colors.blueGrey[600],
                                      onPressed: maxPermit
                                          ? null
                                          : () {
                                              FocusScope.of(context).unfocus();
                                              if (valorPrueba <
                                                      double.parse(
                                                          i.priceMin!) ||
                                                  valorPrueba >
                                                      double.parse(
                                                          i.priceMax!)) {
                                                customToast(
                                                    'Price error', context);
                                              } else {
                                                addProductService.setProduct(
                                                    i.id!,
                                                    valorPrueba,
                                                    i.familyId!);
                                                setState(() {
                                                  articles.removeWhere(
                                                      (element) =>
                                                          (element == i));
                                                  articlesBuscar.removeWhere(
                                                      (element) =>
                                                          (element == i));
                                                  valorPrueba =
                                                      double.parse(i.priceMin!);
                                                  contArticles++;
                                                  if (contArticles >= 5) {
                                                    maxPermit = true;
                                                  }
                                                });
                                              }
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80, vertical: 15),
                                        child: Text(
                                          'Add Product',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        );
                      }).toList(),
                    ),
                    visible: novisible,
                  )
                ]),
              ),
            ),
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
