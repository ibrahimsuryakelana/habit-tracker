import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final err = await auth.login(_userCtl.text, _passCtl.text);
    setState(() { _loading = false; });
    if (err != null) {
      setState(() { _error = err; });
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Text('Habit Tracker', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Aplikasi pelacakan kebiasaan', style: theme.textTheme.titleMedium),
              SizedBox(height: 40),
              TextField(
                controller: _userCtl,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passCtl,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
                style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                child: Text('Belum punya akun? Daftar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
