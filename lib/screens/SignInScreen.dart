import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/controllers/SignInController.dart';

class SigninScreen extends StatelessWidget {
  final SigninController controller = Get.put(SigninController());

  SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 60),
            Center(child: Image.asset('assets/images/2.png', height: 200)),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'لطفاً، قم بتسجيل الدخول !',
                style: TextStyle(color: Color(0xff169B88), fontSize: 22),
              ),
            ),
            const SizedBox(height: 30),

            // اسم المستخدم
            _inputField(
              hint: 'اسم المستخدم',
              icon: Icons.person,
              controller: controller.usernameController,
            ),
            const SizedBox(height: 20),

            // كلمة المرور
            Obx(
              () => _inputField(
                hint: 'كلمة المرور',
                icon: Icons.lock,
                obscure: controller.obscure.value,
                controller: controller.passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.toggleObscure,
                ),
              ),
            ),

            const SizedBox(height: 80),

            // زر تسجيل الدخول
            // استبدل زر تسجيل الدخول بهذا الجزء:
            Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: Colors.teal,))
                      : ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff169B88),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff169B88)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: const Color(0xff169B88)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
