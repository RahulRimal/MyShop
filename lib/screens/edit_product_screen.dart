import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _edittedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if(!isValid)
    {
      return ;
    }

    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_edittedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm,),],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty)
                  {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                      title: value,
                      price: _edittedProduct.price,
                      description: _edittedProduct.description,
                      imageUrl: _edittedProduct.imageUrl,
                      id: null);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if(value.isEmpty)
                  {
                    return 'Please provide a value';
                  }
                  else if(double.tryParse(value) == null)
                  {
                    return 'Please Enter the number';
                  }
                  else if(double.parse(value) <= 0)
                  {
                    return 'Please Enter a valid price';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                      title: _edittedProduct.title,
                      price: double.parse(value),
                      description: _edittedProduct.description,
                      imageUrl: _edittedProduct.imageUrl,
                      id: null);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return 'Please give some description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                      title: _edittedProduct.title,
                      price: _edittedProduct.price,
                      description: value,
                      imageUrl: _edittedProduct.imageUrl,
                      id: null);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value)
                      {
                        if(value.isEmpty)
                        {
                          return 'Please give a image link';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            title: _edittedProduct.title,
                            price: _edittedProduct.price,
                            description: _edittedProduct.description,
                            imageUrl: value,
                            id: null);
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

// https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg
