import 'package:flutter/material.dart';

class TossOnboarding extends StatefulWidget {
  const TossOnboarding({Key? key, required this.width}) : super(key: key);

  final double width;

  @override
  _TossOnboardingState createState() => _TossOnboardingState();
}

class _TossOnboardingState extends State<TossOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;
  double progressWidth = 0; // 초기값은 0으로 설정
  List<String> text = [
    "[토스] 실행 → [전체] 탭 클릭\n[송금] 탭에서  [내 토스 아이디] 선택",
    "아이디가 없을시,\n[3초 만에 만들기] 버튼 클릭",
    "아이디 입력 후 [만들기] 버튼 클릭",
    "[내 아이디 공유] 버튼 클릭",
    "[링크 복사] 버튼 클릭"
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    progressWidth = widget.width;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('토스 페이 연결'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff015AFE),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return buildPage(index);
              },
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      color: const Color(0xff353535).withOpacity(0.35),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Center(
                          child: Text(
                            text[_currentPage],
                            textAlign: TextAlign.center,
                            style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 4,
                      width: progressWidth,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Color(0xff015AFE),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: progressWidth,
                  top: 0,
                  child: const CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xff015AFE),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPage(int index) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(45, 45, 45, 0.00),
                      Color(0xFF2D2D2D),
                      Color(0xFF2D2D2D),
                      Color.fromRGBO(45, 45, 45, 0.00),
                    ],
                    stops: [0.0136, 0.1828, 0.835, 0.9932],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index > 0)
                        GestureDetector(
                          onTap: () {
                            _previousPage();
                          },
                          child: Image.asset(
                            "./assets/icons/leftArrow2.png",
                            scale: 2,
                          ),
                        )
                      else
                        const SizedBox(),
                      if (index < 4)
                        GestureDetector(
                          onTap: () {
                            _nextPage();
                          },
                          child: Image.asset(
                            "./assets/icons/rightArrow2.png",
                            scale: 2,
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (index == 4)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFF2D2D2D),
                          Color.fromRGBO(120, 120, 120, 0.00),
                        ],
                        stops: [0, 1],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xff015AFE),
                        child: Text(
                          "DONE",
                          style: TextStyle(
                              fontSize: 12, fontFamily: "PretendardSemiBold", color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "./assets/images/toss_onboarding${index + 1}.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
    setState(() {
      progressWidth += MediaQuery.of(context).size.width * 0.2;
    });
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
    setState(() {
      progressWidth -= MediaQuery.of(context).size.width * 0.2;
    });
  }
}