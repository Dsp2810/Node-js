import '../services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/product_page.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({Key? key}) : super(key: key);

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool obscure,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPasswordField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordField ? !_isPasswordVisible : false,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon),
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard({required Widget child}) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _buildLoginForm() {
    return _buildAuthCard(
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              label: "Email",
              icon: Icons.email,
              obscure: false,
              controller: _emailController,
              validator: _validateEmail,
            ),
            _buildTextField(
              label: "Password",
              icon: Icons.lock,
              obscure: true,
              isPasswordField: true,
              controller: _passwordController,
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  final result = await AuthServices.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (result['success']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['data'] is String
                              ? result['data']
                              : (result['data']['msg'] ?? 'Login failed'),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = false;
                });
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return _buildAuthCard(
      child: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              label: "Name",
              icon: Icons.person,
              obscure: false,
              controller: _nameController,
              validator: (value) =>
                  value == null || value.isEmpty ? "Name required" : null,
            ),
            _buildTextField(
              label: "Email",
              icon: Icons.email,
              obscure: false,
              controller: _emailController,
              validator: _validateEmail,
            ),
            _buildTextField(
              label: "Password",
              icon: Icons.lock,
              obscure: true,
              isPasswordField: true,
              controller: _passwordController,
              validator: _validatePassword,
            ),
            _buildTextField(
              label: "Confirm Password",
              icon: Icons.lock_outline,
              obscure: true,
              isPasswordField: true,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_signupFormKey.currentState!.validate()) {
                  final result = await AuthServices.signup(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (result['success']) {
                    final token = result['data']['token'];
                    if (token != null) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('token', token);
                      print("Saved token: $token");
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign Up successful, logged in!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['data'] is String
                              ? result['data']
                              : (result['data']['msg'] ?? 'Signup failed'),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = true;
                });
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFFB388EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: Column(
            children: [
              Text(
                _isLogin ? "Welcome Back!" : "Create an Account",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: _isLogin ? _buildLoginForm() : _buildSignupForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
