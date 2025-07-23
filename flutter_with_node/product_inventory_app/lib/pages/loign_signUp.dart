import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
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
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  // login logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logging in...")),
                  );
                }
              },
              child: const Text("Login"),
            )
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
              controller: TextEditingController(),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_signupFormKey.currentState!.validate()) {
                  // signup logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signing up...")),
                  );
                }
              },
              child: const Text("Sign Up"),
            )
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
                "Welcome!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: "Login"),
                  Tab(text: "Sign Up"),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildSignupForm(),
                  ],
                ),
              )
            ],
          ), 
        ),
      ),
    );
  }
}
