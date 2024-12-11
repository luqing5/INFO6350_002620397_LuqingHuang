import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/sign_in.dart';
import 'item_detail.dart';
import 'new_post.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const SignIn();
        }
        return _MyHomePageContent(user: snapshot.data!);
      },
    );
  }
}

class _MyHomePageContent extends StatefulWidget {
  final User user;
  const _MyHomePageContent({Key? key, required this.user}) : super(key: key);

  @override
  State<_MyHomePageContent> createState() => _MyHomePageContentState();
}

class _MyHomePageContentState extends State<_MyHomePageContent> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hyper Garage Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _firebaseAuth.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPost(user: widget.user)),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('userId', isEqualTo: widget.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          print("User UID: ${widget.user.uid}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          print("Fetched documents: ${snapshot.data!.docs}");

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final List<dynamic> images = doc['images'];
                final String imageUrl = images.isNotEmpty ? images[0] : '';

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: imageUrl.isNotEmpty
                        ? FutureBuilder(
                      future:
                      precacheImage(NetworkImage(imageUrl), context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Icon(Icons.error, size: 50);
                          } else {
                            return Image.network(
                              imageUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    )
                        : Image.asset(
                      'assets/placeholder-image.jpg',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      doc['title'],
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    subtitle: Text(
                      '\$${doc['price'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetail(docId: doc.id),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: snapshot.data!.docs.length,
            ),
          );
        },
      ),
    );
  }
}