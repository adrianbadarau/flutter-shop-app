import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProduct";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = false;
  var _editedProduct = Product(
      id: null,
      title: "",
      description: "",
      price: 0.0,
      imageUrl: "",
      isFavorite: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveFrom)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _editedProduct.title,
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    initialValue: _editedProduct.price.toString(),
                    decoration: InputDecoration(labelText: "Price"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field can't be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid nr.";
                      }
                      if (double.parse(value) <= 0.0) {
                        return "Price has to be > 0";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    }),
                TextFormField(
                    initialValue: _editedProduct.description,
                    decoration: InputDecoration(labelText: "Description"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field can't be empty";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    }),
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
                        onFieldSubmitted: (value) {
                          _saveFrom();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value,
                              isFavorite: _editedProduct.isFavorite);
                        }),
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

  void _saveFrom() {
    if (!_form.currentState.validate()) {
      return;
    }
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    _form.currentState.save();
    if (_editedProduct.id == null) {
      productsProvider.addProduct(_editedProduct);
    } else {
      productsProvider.updateProduct(_editedProduct);
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
  void didChangeDependencies() {
    if (!_isInit) {
      final String prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(prodId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
}
