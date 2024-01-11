import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Style/styleapp.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
  late List<Map<String, dynamic>> provinsiData;
  late int jumlahPendudukJawaTimur;
  late List<Map> teksUI;
  late Future<bool> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    getData();
    teksUI = [
      {
        'Header': 'Halo, $dataNameReceive',
        'SubHeader': 'Data Penduduk Indonesia',
        'Penduduk2020': '',
        'Penduduk2021': '',
        'Penduduk2022': '',
        'Penduduk2023': '',

        'HeaderWarning1': 'Register Gagal!',
        'DescriptionWarning1': 'Maaf, username atau nomor WhatsApp sudah digunakan. Coba masukkan username atau nomor WhatsApp lain',
        'HeaderWarning2': 'Konfirmasi Keluar',
        'DescriptionWarning2': 'Perubahan yang anda lakukan, tidak akan disimpan!'
      }
    ].cast<Map<String, String>>();
  }

  Future<bool> fetchData() async {
    http.Response response = http.Response('', 500);

    try {
      response = await http.get(
        Uri.parse('https://api.bps.go.id/v1/population/total'),
        headers: {'Authorization': 'Bearer f49f7f03bfadeb96abe0d0749a387750'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int jumlahPendudukIndonesia = jsonResponse['data']['population'];

        setState(() {
          teksUI[0]['SubHeader'] = 'Jumlah Penduduk Indonesia: $jumlahPendudukIndonesia';
        });

        return true;
      } else {
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      print('Response body: ${response.body}');
      return false;
    }
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
          teksUI[0]['Penduduk2020'] = 'Penduduk Indonesia 2020 : $penduduk2020';
          teksUI[0]['Penduduk2021'] = 'Penduduk Indonesia 2020 : $penduduk2021';
          teksUI[0]['Penduduk2022'] = 'Penduduk Indonesia 2020 : $penduduk2022';
          teksUI[0]['Penduduk2023'] = 'Penduduk Indonesia 2020 : $penduduk2023';
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
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: 300,
                          child: charts.BarChart(
                            _createSeries(),
                            animate: true,
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(teks['Penduduk2020'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: StyleApp.mediumTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(teks['Penduduk2021'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: StyleApp.mediumTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(teks['Penduduk2022'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: StyleApp.mediumTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(teks['Penduduk2023'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: StyleApp.mediumTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black
                            ),
                          ),
                        ),
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
