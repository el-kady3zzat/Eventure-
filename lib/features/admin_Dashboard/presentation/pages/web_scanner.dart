import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class WebScannerPage extends StatefulWidget {
  const WebScannerPage({Key? key}) : super(key: key);

  @override
  State<WebScannerPage> createState() => _WebScannerPageState();
}

class _WebScannerPageState extends State<WebScannerPage> {
  String? result;

  void startScanning() async {
    final code = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FutureBuilder<String?>(
            future: SimpleBarcodeScanner.scanBarcode(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Text('Scanned Code: ${snapshot.data}');
                } else {
                  return const Text('No code scanned.');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );

    if (code != null) {
      setState(() {
        result = code;
      });

      // TODO: Verify the scanned code with your backend or Firestore
      print('Scanned Code: $code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Ticket')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startScanning,
              child: const Text('Start Scanning'),
            ),
            const SizedBox(height: 20),
            if (result != null) Text('Scanned Code: $result'),
          ],
        ),
      ),
    );
  }
}
