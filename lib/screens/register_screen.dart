import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _userCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() { _loading = true; _error = null; _success = null; });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final err = await auth.register(_userCtl.text, _passCtl.text);
    setState(() { _loading = false; });
    if (err != null) {
      setState(() { _error = err; });
    } else {
      setState(() { _success = 'Registrasi berhasil. Silakan kembali ke login.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _userCtl, decoration: InputDecoration(labelText: 'Username')),
            SizedBox(height: 12),
            TextField(controller: _passCtl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 16),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            if (_success != null) Text(_success!, style: TextStyle(color: Colors.green)),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
            )
          ],
        ),
      ),
    );
  }
}
