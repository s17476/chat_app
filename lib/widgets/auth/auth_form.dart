import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String userName,
    String password,
    File? userImage,
    bool isLogin,
    BuildContext context,
  ) submitAuthForm;
  final bool isLoading;

  const AuthForm(
      {Key? key, required this.submitAuthForm, required this.isLoading})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLoginMode = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void _pickImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (_userImageFile == null && !_isLoginMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add avatar'),
          ),
        );
        return;
      }

      if (isValid) {
        _formKey.currentState!.save();

        widget.submitAuthForm(
          _userEmail.trim(),
          _userName.trim(),
          _userPassword.trim(),
          _userImageFile,
          _isLoginMode,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoginMode)
                    UserImagePicker(
                      imagePickFn: _pickImage,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('Email address'),
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: const ValueKey('user'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Username'),
                      ),
                      // initialValue: 'User',
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must bre at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: widget.isLoading
                        ? const SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            height: 20,
                            width: 20,
                          )
                        : Text(_isLoginMode ? 'Login' : 'Signup'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                      });
                    },
                    child: Text(_isLoginMode
                        ? 'Create new account'
                        : 'I aleready have an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
