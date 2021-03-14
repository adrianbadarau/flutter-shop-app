import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProduct";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  // focusNode: _priceFocusNode,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter an Url")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image"),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageUrlFocusNode,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
}
