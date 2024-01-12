import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/BottomNavigationBar.dart';
import '../Style/styleapp.dart';
import 'package:get/get.dart';

class EnterPage extends StatefulWidget {
  static String routeName = '/login';
  const EnterPage({super.key});

  @override
  State<EnterPage> createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool kondisiUsernameKosong = false;
  bool kondisiUsernameKurang4 = false;
  bool kondisiPasswordKosong = false;
  bool kondisiPasswordKurang6 = false;

  final List<Map> teksUI = [
    {
      'Header': 'MASUK',
      'SubHeader': 'Kami senang melihatmu kembali',
      'Email': 'Klik tombol "Masuk" dibawah ini',
      'ButtonLogin': 'Masuk',

      'HeaderWarning2': 'Keluar dari Aplikasi?',
      'DescriptionWarning2': 'Tekan "Keluar" untuk menutup aplikasi'
    }
  ].cast<Map<String, String>>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Kode untuk desain UI-nya
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
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: teks['Header'],
                                  style: StyleApp.extraLargeTextStyle.copyWith(
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: [Colors.lightGreen, Colors.green],
                                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 80.0, 100.0)),
                                      fontWeight: FontWeight.w900
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['SubHeader'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: StyleApp.mediumTextStyle.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            const SizedBox(height: 40,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['Email'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: StyleApp.mediumTextStyle.copyWith(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 6,),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Material(
                                  color: Colors.greenAccent.shade400,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    splashColor: Colors.green.shade800,
                                    highlightColor: Colors.green.shade600,
                                    onTap: () async {
                                      if (_validateInputs()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      child: _isLoading
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Memproses...',
                                            style: StyleApp.largeInputTextStyle.copyWith(
                                                fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            teks['ButtonLogin'],
                                            style: StyleApp.largeInputTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Kondisi untuk mengecek inputan Username dan Password
  bool _validateInputs() {
    Get.to(() => CustomBottomNavigationBar(), transition: Transition.topLevel, duration: const Duration(milliseconds: 2500));
    return true;
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