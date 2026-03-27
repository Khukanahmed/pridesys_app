// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pridesys_app/core/colors/app_colors.dart';
// import 'package:pridesys_app/presentation/auth/controller/login_controller.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AuthController());
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),

//                 Container(
//                   width: 80,
//                   height: 60,
//                   decoration: BoxDecoration(),
//                   child: Image.asset('assets/logo.jpeg', width: 32, height: 32),
//                 ),

//                 const SizedBox(height: 40),

//                 Text(
//                   'Welcome\nback.',
//                   style: TextStyle(
//                     fontSize: 42,
//                     fontWeight: FontWeight.w800,
//                     color: isDark
//                         ? AppColors.darkTextPrimary
//                         : AppColors.lightTextPrimary,
//                     height: 1.1,
//                     letterSpacing: -1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Sign in to continue your journey',
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: isDark
//                         ? AppColors.darkTextSub
//                         : AppColors.lightTextSub,
//                     letterSpacing: 0.2,
//                   ),
//                 ),

//                 const SizedBox(height: 52),

//                 _FieldLabel('Username', isDark: isDark),
//                 const SizedBox(height: 8),
//                 _GlassField(
//                   controller: controller.usernameController,
//                   validator: controller.validateUsername,
//                   hint: 'Enter your username',
//                   icon: Icons.person_outline_rounded,
//                   textInputAction: TextInputAction.next,
//                   isDark: isDark,
//                 ),

//                 const SizedBox(height: 22),

//                 _FieldLabel('Password', isDark: isDark),
//                 const SizedBox(height: 8),
//                 Obx(
//                   () => _GlassField(
//                     controller: controller.passwordController,
//                     validator: controller.validatePassword,
//                     hint: 'Enter your password',
//                     icon: Icons.lock_outline_rounded,
//                     obscureText: controller.obscurePassword.value,
//                     textInputAction: TextInputAction.done,
//                     onSubmitted: (_) => controller.login(),
//                     isDark: isDark,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         controller.obscurePassword.value
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: isDark
//                             ? const Color(0x66FFFFFF)
//                             : AppColors.lightTextSub,
//                         size: 20,
//                       ),
//                       onPressed: controller.togglePasswordVisibility,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {},
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: const Text(
//                       'Forgot password?',
//                       style: TextStyle(
//                         color: AppColors.accent,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 36),

//                 Obx(
//                   () => _LoginButton(
//                     isLoading: controller.isLoading.value,
//                     onPressed: controller.isLoading.value
//                         ? null
//                         : controller.login,
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         color: isDark
//                             ? AppColors.darkBorder
//                             : AppColors.lightBorder,
//                         thickness: 1,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       child: Text(
//                         'or',
//                         style: TextStyle(
//                           color: isDark
//                               ? AppColors.darkTextSub
//                               : AppColors.lightTextSub,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Divider(
//                         color: isDark
//                             ? AppColors.darkBorder
//                             : AppColors.lightBorder,
//                         thickness: 1,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 28),

//                 Center(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: TextStyle(
//                           color: isDark
//                               ? AppColors.darkTextSub
//                               : AppColors.lightTextSub,
//                           fontSize: 14,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text(
//                           'Sign up',
//                           style: TextStyle(
//                             color: AppColors.accent,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Field Label ───────────────────────────────────────────────────────────────

// class _FieldLabel extends StatelessWidget {
//   final String text;
//   final bool isDark;
//   const _FieldLabel(this.text, {required this.isDark});

//   @override
//   Widget build(BuildContext context) => Text(
//     text,
//     style: TextStyle(
//       color: isDark ? const Color(0x99FFFFFF) : AppColors.lightTextSub,
//       fontSize: 13,
//       fontWeight: FontWeight.w500,
//       letterSpacing: 0.5,
//     ),
//   );
// }

// // ── Glass Text Field ──────────────────────────────────────────────────────────

// class _GlassField extends StatelessWidget {
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//   final String hint;
//   final IconData icon;
//   final bool obscureText;
//   final bool isDark;
//   final TextInputAction? textInputAction;
//   final ValueChanged<String>? onSubmitted;
//   final Widget? suffixIcon;

//   const _GlassField({
//     required this.controller,
//     required this.hint,
//     required this.icon,
//     required this.isDark,
//     this.validator,
//     this.obscureText = false,
//     this.textInputAction,
//     this.onSubmitted,
//     this.suffixIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     OutlineInputBorder mkBorder(Color color, {double width = 1}) =>
//         OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: color, width: width),
//         );

//     final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       obscureText: obscureText,
//       textInputAction: textInputAction,
//       onFieldSubmitted: onSubmitted,
//       style: TextStyle(
//         color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
//         fontSize: 15,
//       ),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(
//           color: isDark ? AppColors.darkHint : AppColors.lightHint,
//           fontSize: 15,
//         ),
//         prefixIcon: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 12),
//           child: Icon(
//             icon,
//             color: isDark ? const Color(0x59FFFFFF) : AppColors.lightTextSub,
//             size: 20,
//           ),
//         ),
//         prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: isDark ? const Color(0x0DFFFFFF) : AppColors.lightSurface,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 18,
//         ),
//         border: mkBorder(borderColor),
//         enabledBorder: mkBorder(borderColor),
//         focusedBorder: mkBorder(AppColors.accent, width: 1.5),
//         errorBorder: mkBorder(AppColors.error),
//         focusedErrorBorder: mkBorder(AppColors.error, width: 1.5),
//         errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
//       ),
//     );
//   }
// }

// // ── Login Button ──────────────────────────────────────────────────────────────

// class _LoginButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback? onPressed;

//   const _LoginButton({required this.isLoading, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onPressed != null;
//     return GestureDetector(
//       onTap: onPressed,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: enabled
//               ? const LinearGradient(
//                   colors: [AppColors.accent, Color(0xFF8B5CF6)],
//                 )
//               : null,
//           color: enabled ? null : const Color(0x0DFFFFFF),
//           boxShadow: enabled
//               ? const [
//                   BoxShadow(
//                     color: Color(0x736C63FF),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Center(
//           child: isLoading
//               ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     valueColor: AlwaysStoppedAnimation(Colors.white),
//                   ),
//                 )
//               : const Text(
//                   'Sign In',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
