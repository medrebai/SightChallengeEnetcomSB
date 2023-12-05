import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants/routes.dart';
import '../../../widgets/primary_button/primary_button.dart';
import '../../../widgets/top_titles/top_titles.dart';
import '../login/login.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPassword = true;
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.arrow_back),
            const TopTitles(
                subtitle: "Welcome Back to AquaSPARK", title: "Create an Account"),
            const SizedBox(
              height: 60.0,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: "Name",
                prefixIcon: Icon(Icons.person_2_outlined),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: password,
              obscureText: isShowPassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                        // ignore: avoid_print
                        print(isShowPassword);
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.visibility, color: Colors.grey)),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          PrimaryButton(
  title: "Create an Account",
  onPressed: () async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Routes.instance.push(widget: const Login(), context: context);
      // User successfully signed up. Navigate to another screen here.
    } on FirebaseAuthException catch (e) {
      String message = '';  // Provide an initial value
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print(e);
    }
  },
),         
            const SizedBox(
              height: 12.0,
            ),
            const Center(child: Text("I have already an account.")),
            const SizedBox(
              height: 12.0,
            ),
            CupertinoButton(
                onPressed: () {
                  Routes.instance.push(widget: const Login(), context: context);
                },
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.green),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
