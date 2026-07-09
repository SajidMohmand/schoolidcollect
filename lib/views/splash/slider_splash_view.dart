import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../select_school/select_school_view.dart';

class SliderSplashView extends StatefulWidget {
  const SliderSplashView({super.key});

  @override
  State<SliderSplashView> createState() => _SliderSplashViewState();
}

class _SliderSplashViewState extends State<SliderSplashView> {
  final PageController _controller = PageController();



  final List<Map<String, String>> pages = [
    {
      "title": "Create Student ID Card in Minutes",
      "description":
      "Store your student ID securely and access it anytime, anywhere.",
      "icon": "🪪",
    },
    {
      "title": "Quick & Easy Access",
      "description":
      "Show your student ID instantly without carrying a physical card.",
      "icon": "📱",
    },
    {
      "title": "Safe & Secure",
      "description":
      "Your student information is protected.",
      "icon": "🔒",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: Column(
                children: [

                  SizedBox(
                    height: height * 0.22,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: WaveClipperTwo(flip: true),
                          child: Container(
                            height: height * 0.22,
                            width: double.infinity,
                            color: const Color(0xffFFC51A),
                          ),
                        ),

                        ClipPath(
                          clipper: WaveClipperTwo(flip: true),
                          child: Container(
                            height: height * 0.21,
                            width: double.infinity,
                            color: const Color(0xffEF3E3E),
                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),

                    child: Column(
                      children: [

                        SizedBox(height: height * 0.04),


                        CircleAvatar(
                          radius: width * 0.12,
                          backgroundColor: const Color(0xffE8F5E9),
                          backgroundImage:
                          const AssetImage("assets/icon/icon.png"),
                        ),


                        const SizedBox(height: 20),


                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "STUD",
                                style: TextStyle(
                                  fontSize: width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff7C6BCF),
                                ),
                              ),

                              TextSpan(
                                text: "ENT",
                                style: TextStyle(
                                  fontSize: width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff618BD8),
                                ),
                              ),
                            ],
                          ),
                        ),


                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "ID ",
                                style: TextStyle(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2C367B),
                                ),
                              ),

                              TextSpan(
                                text: "CARD",
                                style: TextStyle(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2DA5AB),
                                ),
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: height * 0.04),



                        SizedBox(
                          height: height * 0.16,

                          child: PageView.builder(
                            controller: _controller,
                            itemCount: pages.length,

                            itemBuilder: (context,index){

                              return Center(
                                child: Text(
                                  pages[index]["title"]!,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: width * 0.058,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),



                        const SizedBox(height: 20),


                        SmoothPageIndicator(
                          controller: _controller,
                          count: pages.length,

                          effect: WormEffect(
                            activeDotColor:
                            const Color(0xff2DA5AB),

                            dotColor:
                            Colors.grey.shade300,

                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),



                        const SizedBox(height: 30),



                        SizedBox(
                          width: double.infinity,
                          height: 55,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xff009494),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const SelectSchoolView(),
                                ),
                              );
                            },

                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),



                        const SizedBox(height: 20),



                        ClipPath(
                          clipper: WaveClipperTwo(reverse:true),

                          child: Container(
                            height: height * 0.10,
                            width: double.infinity,
                            color: const Color(0xff009494),
                          ),
                        ),


                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                ],
              ),
            ),


            Positioned(
              top: 12,
              right: 20,

              child: TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const SelectSchoolView(),
                    ),
                  );
                },

                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
