import 'package:flutter/material.dart';
import '../../DataAccess//Dataaccess.dart';
import '../../Style/styleapp.dart';

class TabelAPI extends StatefulWidget {
  static String routeName = '/tabelapi';

  const TabelAPI({Key? key}) : super(key: key);

  @override
  State<TabelAPI> createState() => _TabelAPIState();
}

class _TabelAPIState extends State<TabelAPI> {
  late List<Map<String, String>> domainList;
  late List<Map> teksUI;

  @override
  void initState() {
    super.initState();
    domainList = [];
    teksUI = [
      {
        'Header': 'Daftar Tabel BPS Indonesia',
        'SubHeader': 'Data dihimpun dari Website BPS Pusat',
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
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, String>> data = await DataAccessProvinsi.fetchData();
      setState(() {
        domainList = data;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                for (final teks in teksUI)
                Column(
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
                            maxLines: 1,
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
                  ],
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Domain ID')),
                              DataColumn(label: Text('Domain Name')),
                              DataColumn(label: Text('Domain URL')),
                            ],
                            rows: domainList
                                .map(
                                  (domain) => DataRow(
                                cells: [
                                  DataCell(Text(domain['domain_id']!)),
                                  DataCell(Text(domain['domain_name']!)),
                                  DataCell(Text(domain['domain_url']!)),
                                ],
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
