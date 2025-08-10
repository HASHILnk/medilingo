import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_screen.dart';
import 'scanning_screen.dart'; // <-- Import the new screen
import 'history_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTabContent(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('MediLingo'),
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   foregroundColor: Colors.black,
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E8B57),
        onTap: _onItemTapped,
      ),
    );
  }
}


class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  // --- UPDATED FUNCTION WITH MORE DEBUGGING ---

  // In home_screen.dart

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // --- THE FIX: Capture the Navigator before the 'await' ---
    final navigator = Navigator.of(context);

    print("1. Trying to pick image from: $source");
    try {
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        print("2. Image picked successfully! Path: ${image.path}");

        // Now use the captured navigator
        await navigator.push(
          MaterialPageRoute(
            builder: (context) => ScanningScreen(imagePath: image.path),
          ),
        );
        print("3. Navigation to ScanningScreen completed."); // New debug line

      } else {
        print("2. Image picking was canceled by the user.");
      }
    } catch (e) {
      print("ERROR picking image: $e");
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // This correctly centers horizontally
        mainAxisAlignment: MainAxisAlignment.center,  // <-- 1. ADD THIS LINE for vertical centering
        children: <Widget>[
          // I removed the SizedBox from the top so it's perfectly centered
          const Icon(Icons.local_hospital, color: Color(0xFF2E8B57), size: 50),
          const SizedBox(height: 10),
          const Text(
            'MediLingo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          const SizedBox(height: 30),

          // Welcome card
          const Card(
            color: Color(0xFFE8F5E9),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Welcome! Let's take a look at your health report.",
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Scan button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E8B57),
              // -- 2. CHANGE THIS --
              // Remove infinite width and use padding instead
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              _showOptions(context);
            },
            icon: const Icon(Icons.document_scanner_outlined, color: Colors.white),
            label: const Text(
              'Scan New Report',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }}