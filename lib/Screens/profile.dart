import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              width: context.width,
              height: context.height * 0.25,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(18),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Kailash Bajaj',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Basis Grotesque Pro',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: -0.30,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: context.width * 0.8,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: context.width,
              height: context.height * 0.28,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  Container(
                    width: context.width * 0.95,
                    height: context.height * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 18,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w700,
                                  height: 0.08,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              Spacer(),
                              // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Personal details',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Complaint history',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Privacy & security',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  // height: 0.12,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: context.width,
              height: context.height * 0.26,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  Container(
                    width: context.width * 0.95,
                    height: context.height * 0.26,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Support',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 18,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w700,
                                  height: 0.08,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              Spacer(),
                              // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Support',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Care',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "FAQ's",
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                  fontFamily: 'Basis Grotesque Pro',
                                  fontWeight: FontWeight.w400,
                                  // height: 0.12,
                                  letterSpacing: -0.39,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: context.width * 0.95,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFF3F3F3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
