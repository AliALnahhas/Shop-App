import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import '../provider/products.dart';

class EditProductSreen extends StatefulWidget {
  static const routeName = '/EditProductSreen';
  @override
  _EditProductSreenState createState() => _EditProductSreenState();
}

class _EditProductSreenState extends State<EditProductSreen> {
  final FocusNode _pricefocuseNode = FocusNode();
  final FocusNode _descreptionfocuseNode = FocusNode();
  final _imageUrlControllar = TextEditingController();
  final _imageUrlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  @override
  void initState() {
    _imageUrlfocusnode.addListener(_updateImageUrl);
    super.initState();
  }

  bool _isInit = true;
  var initValue = {
    'title': '',
    'descreption': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        initValue = {
          'title': _editedProduct.title,
          'descreption': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlControllar.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlfocusnode.hasFocus) {
      if ((!_imageUrlControllar.text.startsWith('http') &&
              !_imageUrlControllar.text.startsWith('https')) ||
          (!_imageUrlControllar.text.endsWith('.png') &&
              _imageUrlControllar.text.endsWith('.jpg') &&
              _imageUrlControllar.text.endsWith('jpeg'))) return;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlfocusnode.removeListener(_updateImageUrl);
    _pricefocuseNode.dispose();
    _descreptionfocuseNode.dispose();
    _imageUrlControllar.dispose();
    _imageUrlfocusnode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Error !',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            content: Text('something went wrong !'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Okey',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      /*finally {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
        print(_editedProduct.price);
      }*/
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: initValue['title'],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter Title.';
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocuseNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: initValue['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocuseNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descreptionfocuseNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter Price.';
                        if (double.tryParse(value) == null)
                          return 'Please Enter A valid Number';
                        if (double.parse(value) <= 0)
                          return 'Please Enter Number Greater Than zero.';
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Descreption'),
                      initialValue: initValue['descreption'],
                      maxLines: 3,
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter Descreption .';
                        if (value.length < 10)
                          return 'Should be At Least 10 Character.';
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      focusNode: _descreptionfocuseNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlControllar.text.isEmpty
                              ? Text('Enter Image Url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlControllar.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please Enter Image URL';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please Enter a Valid URL.';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg'))
                                return 'Please Enter a Valid Image URL.';
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlControllar,
                            focusNode: _imageUrlfocusnode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
