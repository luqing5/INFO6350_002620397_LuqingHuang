import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'camera.dart';
import 'package:camera/camera.dart';
import 'display_picture.dart';
import 'package:flutter/cupertino.dart';


class NewPost extends StatefulWidget {
  final User user;
  const NewPost({Key? key, required this.user}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<File> _images = [];
  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameras = await availableCameras();
      final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: cameras.first),
        ),
      );

      if (imagePath != null) {
        setState(() {
          _images.add(File(imagePath));
        });
      }
    } else {
      final resultList = await ImagePicker().pickMultiImage(
        maxHeight: 960,
        maxWidth: 960,
      );

      if (resultList != null) {
        setState(() {
          _images.addAll(resultList.map((xFile) => File(xFile.path)).toList());
        });
      }
    }
  }

  Future<void> _uploadImages(String postId) async {
    for (var i = 0; i < _images.length; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts/$postId/images/img_$i.jpg');
      await ref.putFile(_images[i]);
      final String imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.doc('items/$postId').update({
        "images": FieldValue.arrayUnion([imageUrl])
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      double? price;
      try {
        price = double.parse(_priceController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid price'),
          ),
        );
        return;
      }

      try {
        final newPost =
        await FirebaseFirestore.instance.collection('items').add({
          'title': _titleController.text,
          'price': price,
          'description': _descriptionController.text,
          'userId': widget.user.uid,
          'images': [],
        });

        await _uploadImages(newPost.id);

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while submitting the post: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields and add at least one image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_images.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Image.file(
                      _images[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select Image'),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  fillColor: theme.primaryColorLight,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  fillColor: theme.primaryColorLight,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  fillColor: theme.primaryColorLight,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Post Item'),
                  style: ElevatedButton.styleFrom(
                    // primary: theme.primaryColor,
                    // onPrimary: theme.primaryTextTheme.button!.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}