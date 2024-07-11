import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ImageAssetsScreen extends StatefulWidget {
  const ImageAssetsScreen({super.key});
  
  @override
  _ImageAssetsPageState createState() => _ImageAssetsPageState();
}

class _ImageAssetsPageState extends State<ImageAssetsScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String x="";

  Future<String> _getImageUrl(String imageFilename) async {
    try {
      return await _storage.ref(imageFilename).getDownloadURL();
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images')),
      body: StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No images found'));
          } else {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            print('Data received: $data'); // Debugging print statement
            List<Map<dynamic, dynamic>> images = data.entries
                .where((entry) => entry.value is Map)
                .map((entry) => entry.value as Map<dynamic, dynamic>)
                .toList();

            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                var image = images[index];
                print('Image data: $image'); // Debugging print statement
                var imageUrl = 'https://tester6-b39ff.appspot.com/${image['Image Filename']}';
                return ListTile(
                  title: Image.network(imageUrl),
                  subtitle: Text('Person Count: ${image['Person Count']}, Person Detected: ${image['Person Detected']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

