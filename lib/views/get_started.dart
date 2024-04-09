import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/views/home.dart';

class GetStartedPage extends StatelessWidget {

  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  right: 30,
                  child: Container(
                    width: 31.25,
                    height: 31.25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.19)
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 150,
                  left: 50,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.19)
                    ),
                  ),
                ),
                Positioned(
                  top: screenSize.height * 0.25,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.85,
                        child: Text(
                          'AI Writing Assistant',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontFamily: 'Righteous Regular',
                              color: Colors.white,
                              fontSize: 50
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.45,
              width: screenSize.width,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_onboard.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      //margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1,),
                  Column(
                    children: [
                      Text(
                        'Get started',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Write better, faster, and more with AI Writing Assistant app, powered by Gemini AI.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
