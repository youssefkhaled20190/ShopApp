// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields, constant_identifier_names, sort_child_properties_last, unused_element

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authDate = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;

  final _paswordController = TextEditingController();
  AnimationController? _Controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _Controller!, curve: Curves.fastOutSlowIn),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(
      CurvedAnimation(parent: _Controller!, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _Controller!.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .Login(_authDate['email']!, _authDate['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authDate['email']!, _authDate['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          ElevatedButton(
            child: const Text('Okay!'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _Controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _Controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Email Invalid';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    _authDate['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _paswordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password Is Too Short';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    _authDate['password'] = val!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.SignUp
                            ? (val) {
                                if (val != _paswordController.text) {
                                  return 'Password do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading) const CircularProgressIndicator(),
                ElevatedButton(
                  child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                  onPressed: _submit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
                TextButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: TextStyle(color: Colors.purple),
                  ),
                  onPressed: _switchAuthMode,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
