import 'package:app/pages/landing.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/scanner.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/books/v1.dart' as books;


late List<CameraDescription> _cameras;

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  
  // Hard Coded Login
  final creds = auth.ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "bookshifter",
    "private_key_id": "474b1ab1472acd6c191595056502582635260f93",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCNbtQ/4M52q6+H\nO0iJ+2leNJ8YojNQzDdXgtff/7KTYHHEwHLzZjOIieocG07aSlwdUN7B9310K32S\nXcyg8m3tl4fSfkiBVfPmKIM9ILo6rLok8dnvAnEvk+x44u74G3HmSYS36biwx6fv\nZf7lttm0sARYmFj3/KiCHFTdv+0pBnVOHoNwgAE7I0LuD7l17MoBq1oRHNC9fIE4\nu8GB5OvLxjPE/dY+splr4GL2EX8bbRjsmcWw+kA4vEl/F/d4CR5bG0icc6er/jgh\nuyA/h84KGv6Hia88IthlocDKKtWOKAETEmqMCcNK9teMQoCpkwVuNu76Y248aWKd\nFJix+JV5AgMBAAECggEAQyLgewAWUau20z03dlRTFKZq/TEFpe2CubZBDjIdDStj\nZe+qwVJ61O4OpM/rsuBIcJwSWcXHFg2M+p0vBRl/SCC9lxReC5MHB3KktbAi5rZW\nWDI77uJcYybXQh0LLdgtTZEJgJngE356/7+Na3LMTiKdtYZ/+RvEy5pySJ8SD34u\nE8IOoNxV6fHDvGQNCFUNYPO85Kp4GWWwW+SCD/1ButBIHVpoXhgH2gIeDjI3I923\nMO75Zthw5DfLNXTnQkKJVImIgzCMJ8amYKDCb3Evij5ne+KiepWdnH0FGQcVGAdj\nqUQqazi5o8tfujRvEFZ/2lVgDvxGxsmjLldfiutKvwKBgQDEeTKyiv/oyU+e/3Bs\npmosSW/cAaNgt/l06LBVmECPpWe3wD65UbpvJ9yQJ2+3kg4g/hange/bg+q6yq8O\ng7uP9O4bEHp3UwDIM2jguVkKxUoZfhQRGhcWl8fgqV+8l4TmpMyNNML+BU+GLf2m\n8z307QWhslK9wh89IUe0CXA1ZwKBgQC4SJlkJIn1tS36EFJfNA9EvEBVFLFTpifx\nWHfUqejxV01/C7MppMCnGWjYooOZ1x6mcVwwGHx4U7or1dsLXdulRm8qdHd+Ltvv\ni0BSHJ6+PMOuX5qN/4yXvaBkIQnqq5fJbFg54YwPVTkFMiTL2ScbqiA4KKgONaXt\nxgFBWOwyHwKBgQDDNVQs1zR6uwHUDSJLoXDePbzZT/tfDovZH5SMBvEmiAYsKONp\nR43AAVABHl2+e2x0VWB24ABMD566JsWV20cROh8VXuL/CcY+I+4xUZbpv6nm+EDB\n2TVVakraqg6IF9ehPd5K8kBHGUmxHKLoLMfDQXiV9tKE3YoiN53BgJsvQwKBgA5m\nVd4WYNVbR/FvTxBzX/IOB7TePhD8PcjFEfADKtmY6cxQnLpXTlqASMoMwN3HinSV\nDRARCcDZQgXk2w3jUqNygoM9wIySmsr4BZmk9N6Gnv/EJq6L1m+Q+LR6RG0a5Wxu\n0+IJ9sjH7wGx7mAjYsPtokDhJGif1oxi2XxCt4ofAoGBAIB73NiyvpS5FtmFZKkX\nD6kDPhNv+pEYUOakTdOsLovUABHVN9tAbUDVwPn514zrkjVrRl07JV3gFXswV99y\nGG7/pPcsX0fpUT7iydJPqKnt0ox4118CWMy4NpmtObOzgerUlwxgbIb08YZWGXZ6\nF0hoYHX7NcH173E4Vn9pczZk\n-----END PRIVATE KEY-----\n",
    "client_email": "bookshifter-account@bookshifter.iam.gserviceaccount.com",
    "client_id": "103991878972110230142",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/bookshifter-account%40bookshifter.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  });

  final client =
      await auth.clientViaServiceAccount(creds, [books.BooksApi.booksScope]);

  runApp(MyApp(client: client, camera: _cameras.first));
}

class MyApp extends StatelessWidget {
  final dynamic client;
  final CameraDescription camera;

  const MyApp({super.key, required this.client, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookShifter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/landing': (context) => LandingPage(client: client),
        '/scanner': (context) => ScannerPage(camera: camera),
        },
    );
  }
}
