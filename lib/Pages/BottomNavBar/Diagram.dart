import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Style/styleapp.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../DataAccess//Dataaccess.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Diagram extends StatefulWidget {
  static String routeName = '/diagram';

  const Diagram({super.key});

  @override
  State<Diagram> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  double penduduk2020 = 0.0;
  double penduduk2021 = 0.0;
  double penduduk2022 = 0.0;
  double penduduk2023 = 0.0;
  final String dataNameReceive = "Dispendukcapil";
  late int jumlahPendudukJawaTimur;
  late List<Map> teksUI;
  late Future<bool> fetchDataFuture;
  late String datapenduduk = '';

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchDataFromAPI(datapenduduk);
    getData();
    teksUI = [
      {
        'Header': 'Halo, $dataNameReceive',
        'SubHeader': 'Data Penduduk Indonesia',
        'teksPenduduk2020': '2020',
        'teksPenduduk2021': '2021',
        'teksPenduduk2022': '2022',
        'teksPenduduk2023': '2023',
        'Penduduk2020': '',
        'Penduduk2021': '',
        'Penduduk2022': '',
        'Penduduk2023': '',

        'HeaderWarning2': 'Konfirmasi Keluar',
        'DescriptionWarning2': 'Perubahan yang anda lakukan, tidak akan disimpan!'
      }
    ].cast<Map<String, String>>();
  }

  Future<bool> fetchDataFromAPI(String datapenduduk) async {
    return await DataAccessPenduduk.fetchDataFromAPI(datapenduduk);
  }

  Future<void> getData() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Data')
          .doc('Penduduk')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data =
        snapshot.data() as Map<String, dynamic>;

        setState(() {
          penduduk2020 = data['penduduk2020']?.toDouble() ?? 0.0;
          penduduk2021 = data['penduduk2021']?.toDouble() ?? 0.0;
          penduduk2022 = data['penduduk2022']?.toDouble() ?? 0.0;
          penduduk2023 = data['penduduk2023']?.toDouble() ?? 0.0;
        });

        setState(() {
          teksUI[0]['Penduduk2020'] = 'Jumlah: ${NumberFormat.decimalPattern('en_US').format(penduduk2020)}';
          teksUI[0]['Penduduk2021'] = 'Jumlah: ${NumberFormat.decimalPattern('en_US').format(penduduk2021)}';
          teksUI[0]['Penduduk2022'] = 'Jumlah: ${NumberFormat.decimalPattern('en_US').format(penduduk2022)}';
          teksUI[0]['Penduduk2023'] = 'Jumlah: ${NumberFormat.decimalPattern('en_US').format(penduduk2023)}';
        });

      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<charts.Series<OrdinalSales, String>> _createSeries() {
    final data = [
      OrdinalSales('2020', penduduk2020),
      OrdinalSales('2021', penduduk2021),
      OrdinalSales('2022', penduduk2022),
      OrdinalSales('2023', penduduk2023),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Penduduk',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await _onBackPressed(context);
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                for (final teks in teksUI)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.green, Colors.green],
                              ).createShader(bounds);
                            },
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(
                                text: teks['Header'],
                                style: StyleApp.extraLargeTextStyle.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(teks['SubHeader'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: StyleApp.largeTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        FutureBuilder(
                          future: fetchDataFromAPI(datapenduduk),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 10),
                                    Text("Memuat Data"),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return SizedBox(
                                height: 300,
                                child: charts.BarChart(
                                  _createSeries(),
                                  animate: true,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [Colors.redAccent.shade200, Colors.purpleAccent],
                                                ).createShader(bounds);
                                              },
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text: teks['teksPenduduk2020'],
                                                  style: StyleApp.largeTextStyle.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(teks['Penduduk2020'],
                                                style: StyleApp.semiLargeTextStyle.copyWith(
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [Colors.orangeAccent, Colors.yellow.shade700],
                                                ).createShader(bounds);
                                              },
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text: teks['teksPenduduk2021'],
                                                  style: StyleApp.largeTextStyle.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(teks['Penduduk2021'],
                                                style: StyleApp.semiLargeTextStyle.copyWith(
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [Colors.deepPurple, Colors.purpleAccent],
                                                ).createShader(bounds);
                                              },
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text: teks['teksPenduduk2022'],
                                                  style: StyleApp.largeTextStyle.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(teks['Penduduk2022'],
                                                style: StyleApp.semiLargeTextStyle.copyWith(
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [Colors.blue.shade700, Colors.green],
                                                ).createShader(bounds);
                                              },
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text: teks['teksPenduduk2023'],
                                                  style: StyleApp.largeTextStyle.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(teks['Penduduk2023'],
                                                style: StyleApp.semiLargeTextStyle.copyWith(
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          )
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBackPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        for (final teks in teksUI) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(16.0),
            children: [
              Text(teks['HeaderWarning2'],
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: StyleApp.mediumTextStyle.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
              const Icon(Icons.warning, color: Colors.red),
              const SizedBox(height: 10,),
              Text(teks['DescriptionWarning2'],
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: StyleApp.smallTextStyle.copyWith(
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _performExitAction();
                      },
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  void _performExitAction() {
    SystemNavigator.pop();
  }
}

class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}
