import 'package:http/http.dart' as http;
import 'dart:convert';

String API_Penduduk = 'a2a4790b483150f6aea3d93ff7f68ba9';
String API_Provinsi = '26c6eb8463fdd820aa4e18969b52b329';

class DataAccessPenduduk {
  static Future<bool> fetchDataFromAPI(String datapenduduk) async {

    http.Response response = http.Response('', 400);

    try {
      response = await http.get(
        Uri.parse('https://api.bps.go.id/v1/population/total'),
        headers: {'Api-Key': '$API_Penduduk'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int jumlahPendudukIndonesia = jsonResponse['data']['population'];

        datapenduduk = 'Penduduk Indonesia 2020 : $jumlahPendudukIndonesia';

        return true;
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print('Gagal mengambil data: $e\nKunjungi halaman untuk memeriksa kesalahan di:\nhttps://api.bps.go.id/v1/population/total');
      print('Response body:\n${response.body}');
      return false;
    }
  }
}

class DataAccessProvinsi {
  static Future<List<Map<String, String>>> fetchData() async {
    final response = await http.get(Uri.parse('https://webapi.bps.go.id/v1/api/domain/type/prov/key/$API_Provinsi/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dataList = data['data'][1];
      return dataList
          .map((domain) => {
        'domain_id': domain['domain_id']?.toString() ?? '',
        'domain_name': domain['domain_name']?.toString() ?? '',
        'domain_url': domain['domain_url']?.toString() ?? '',
      })
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
