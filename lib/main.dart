import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_color/random_color.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue[300],
      systemNavigationBarColor: Colors.brown));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Just for fun'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool started = false;
  double x = 0;
  double birdY = 0;
  double t = 0;
  double v = 2.8;
  double jump = 0;
  double initialPos = 0;
  double fx;
  double sx;
  double tx;
  double fox;
  int score = 0;
  int best = 0;
  bool pipeIsMoving = false;
  bool cloudIsMoving = false;

  RandomColor _randomColor = RandomColor();
  Color c1;
  Color c2;
  Color c3;
  Color c4;
  Color c5;
  Color c6;

  bool first = false;
  bool second = false;
  bool thired = false;
  bool canceled = false;

  double birdX = 0;
  bool collided = false;

  GlobalKey keyf1 = GlobalKey();
  GlobalKey keyf2 = GlobalKey();
  GlobalKey keys1 = GlobalKey();
  GlobalKey keys2 = GlobalKey();
  GlobalKey keyt1 = GlobalKey();
  GlobalKey keyt2 = GlobalKey();
  GlobalKey keyb = GlobalKey();

  RenderBox bird;
  Offset birdPos;
  double birdDy;
  double birdDx;

  RenderBox box1;
  Offset box1Pos;
  double box1Dy;
  double box1Dx;

  RenderBox box2;
  Offset box2Pos;
  double box2Dy;
  double box2Dx;

  RenderBox box3;
  Offset box3Pos;
  double box3Dy;
  double box3Dx;

  RenderBox box4;
  Offset box4Pos;
  double box4Dy;
  double box4Dx;

  RenderBox box5;
  Offset box5Pos;
  double box5Dy;
  double box5Dx;

  RenderBox box6;
  Offset box6Pos;
  double box6Dy;
  double box6Dx;

  double h1 = 50;
  double h2 = 205;
  double h3 = 75;
  double h4 = 200;
  double h5 = 145;
  double h6 = 130;

  double cx1 = 20;
  double cx2 = 40;
  double cx3 = 220;
  double cx4 = 100;
  double cx5 = 300;
  double cx6 = 350;

  int n;
  double n2;

  Random random = Random();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioCache cache = AudioCache();

  var txt = "some text";

  void callDialog(double w) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              // backgroundColor: Colors.indigo[900],
              insetAnimationDuration: Duration(
                milliseconds: 600,
              ),
              insetAnimationCurve: Curves.bounceInOut,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color.fromRGBO(90, 66, 245, 1),
                  // gradient: LinearGradient(colors: [Colors.green, Colors.blue[500]])
                ),
                height: 200,
                width: w,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            'Would yo like\nto try again ?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                color: Color.fromRGBO(245, 66, 108, 1),
                                textColor: Colors.white,
                                onPressed: () {
                                  audioPlayer.stop();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    birdY = 1.8;
                                    canceled = true;
                                  });
                                },
                                child: Text('CANCEL'),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                color: Color.fromRGBO(182, 245, 66, 1),
                                textColor: Colors.black,
                                onPressed: () {
                                  audioPlayer.stop();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    canceled = false;
                                    birdY = 0;
                                  });
                                },
                                child: Text('OK'),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ));
  }

  void pipeMove(bool ss) {
    Timer.periodic(Duration(milliseconds: 6), (timer) {
      fx -= 1;
      sx -= 1;
      tx -= 1;

      bird = keyb.currentContext.findRenderObject();
      birdPos = bird.localToGlobal(Offset.zero);
      birdDy = birdPos.dy;
      birdDx = birdPos.dx;

      box1 = keyf1.currentContext.findRenderObject();
      box1Pos = box1.localToGlobal(Offset.zero);
      box1Dy = box1Pos.dy;
      box1Dx = box1Pos.dx;

      box2 = keyf2.currentContext.findRenderObject();
      box2Pos = box2.localToGlobal(Offset.zero);
      box2Dy = box2Pos.dy;
      box2Dx = box2Pos.dx;

      box3 = keys1.currentContext.findRenderObject();
      box3Pos = box3.localToGlobal(Offset.zero);
      box3Dy = box3Pos.dy;
      box3Dx = box3Pos.dx;

      box4 = keys2.currentContext.findRenderObject();
      box4Pos = box4.localToGlobal(Offset.zero);
      box4Dy = box4Pos.dy;
      box4Dx = box4Pos.dx;

      box5 = keyt1.currentContext.findRenderObject();
      box5Pos = box5.localToGlobal(Offset.zero);
      box5Dy = box5Pos.dy;
      box5Dx = box5Pos.dx;

      box6 = keyt2.currentContext.findRenderObject();
      box6Pos = box6.localToGlobal(Offset.zero);
      box6Dy = box6Pos.dy;
      box6Dx = box6Pos.dx;

      // print('box: ');
      // print(box2Dy);
      // print('bird: ');
      // print(birdDy + box1.size.height);

      if (birdDy + 60 >= box1Dy &&
          birdDx + 60 >= box1Dx &&
          birdDx <= box1.size.width + box1Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (birdDy - box2.size.height <= box2Dy &&
          birdDx + 60 >= box2Dx &&
          birdDx <= box2.size.width + box2Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (birdDy + 60 >= box3Dy &&
          birdDx + 60 >= box3Dx &&
          birdDx <= box3.size.width + box3Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (birdDy - box4.size.height <= box4Dy &&
          birdDx + 60 >= box4Dx &&
          birdDx <= box4.size.width + box4Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (birdDy + 60 >= box5Dy &&
          birdDx + 60 >= box5Dx &&
          birdDx <= box5.size.width + box5Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (birdDy - box6.size.height <= box6Dy &&
          birdDx + 60 >= box6Dx &&
          birdDx <= box6.size.width + box6Dx) {
        setState(() {
          collided = true;
          pipeIsMoving = false;
        });
      }

      if (fx < MediaQuery.of(context).size.width / 2 - 75 && !first) {
        setState(() {
          first = true;
          score += 1;
        });
      }

      if (sx < MediaQuery.of(context).size.width / 2 - 75 && !second) {
        setState(() {
          second = true;
          score += 1;
        });
      }

      if (tx < MediaQuery.of(context).size.width / 2 - 75 && !thired) {
        setState(() {
          thired = true;
          score += 1;
        });
      }

      if (fx < -75 &&
          tx < MediaQuery.of(context).size.width / 2 - 75 &&
          sx < -75) {
        setState(() {
          first = false;
          n = random.nextInt(338) + 12;
          double nu = n.toDouble();
          n2 = 345.0 - nu;
          h1 = nu;
          h2 = n2;
          fx = MediaQuery.of(context).size.width;
          c1 = c2 = _randomColor.randomMaterialColor();
        });
      }
      if (sx < -75 &&
          fx < MediaQuery.of(context).size.width / 2 - 75 &&
          tx < -75) {
        setState(() {
          second = false;
          n = random.nextInt(338) + 12;
          double nu = n.toDouble();
          n2 = 345.0 - nu;
          h3 = nu;
          h4 = n2;
          sx = MediaQuery.of(context).size.width;
          c3 = c4 = _randomColor.randomMaterialColor();
        });
      }
      if (tx < -75 &&
          sx < MediaQuery.of(context).size.width / 2 - 75 &&
          fx < -75) {
        setState(() {
          thired = false;
          n = random.nextInt(338) + 12;

          double nu = n.toDouble();
          n2 = 345.0 - nu;
          h5 = nu;
          h6 = n2;
          tx = MediaQuery.of(context).size.width;
          c5 = c6 = _randomColor.randomMaterialColor();
        });
      }
      if (!pipeIsMoving) {
        timer.cancel();
        fx = MediaQuery.of(context).size.width;
        sx = MediaQuery.of(context).size.width * 2;
        tx = MediaQuery.of(context).size.width * 3;
      }
    });
  }

  void timerCallback() {
    Timer.periodic(Duration(milliseconds: 40), (timer) {
      t += .04;
      jump = -.5 * 9.81 * t * t + v * t;
      setState(() {
        birdY = initialPos - jump;
      });

      if (birdY > 1.1 || birdY < -1.1 || collided) {
        timer.cancel();
        if (birdY > 1) {
          birdY = 1;
        } else {
          birdY = -1;
        }

        if (!canceled) {
          playGameOver();
        }

        callDialog(MediaQuery.of(context).size.width);

        if (score > best) {
          best = score;
        }
        setState(() {
          pipeIsMoving = false;
          cloudIsMoving = false;
          score = 0;
          best = best;
          first = false;
          second = false;
          thired = false;
          started = false;
        });
      }
    });
  }

  void cloudMove() {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      cx1 -= .1;
      cx2 -= .051;
      cx3 -= .062;
      cx4 -= .082;
      cx5 -= .077;
      cx6 -= .02;

      if (cx1 < -100) {
        cx1 = MediaQuery.of(context).size.width;
      }

      if (cx2 < -100) {
        cx2 = MediaQuery.of(context).size.width;
      }

      if (cx3 < -100) {
        cx3 = MediaQuery.of(context).size.width;
      }

      if (cx4 < -100) {
        cx4 = MediaQuery.of(context).size.width;
      }

      if (cx5 < -100) {
        cx5 = MediaQuery.of(context).size.width;
      }

      if (cx6 < -100) {
        cx6 = MediaQuery.of(context).size.width;
      }

      if (!cloudIsMoving) {
        timer.cancel();
      }
    });
  }

  void playGameOver() async {
    audioPlayer =
        await cache.play('sounds/over.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void playJump() async {
    if (!canceled) {
      await cache.play('sounds/jump.mp3', mode: PlayerMode.LOW_LATENCY);
    }
  }

  void jumpCallback() {
    setState(() {
      if (!started) {
        setState(() {
          started = true;
          cloudIsMoving = true;
          pipeIsMoving = true;
          collided = false;
        });
        cloudMove();
        timerCallback();
        pipeMove(true);
      }
      playJump();
      t = 0;
      initialPos = birdY;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fx = MediaQuery.of(context).size.width;
    sx = MediaQuery.of(context).size.width * 2;
    tx = MediaQuery.of(context).size.width * 3;
    c2 = c1 = _randomColor.randomMaterialColor();
    
    c4 = c3 = _randomColor.randomMaterialColor();
    
    c6 = c5 = _randomColor.randomMaterialColor();
   
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          jumpCallback();
        },
        onLongPress: () {},
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.blue[300],
                      child: Padding(
                        padding: const EdgeInsets.only(top: 102.0),
                        child: Center(
                            child: started
                                ? Text('')
                                : RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                      text: 'Tap ',
                                      children: [
                                        TextSpan(text: 'to ', style: TextStyle(fontSize: 24)),
                                        TextSpan(text: 'start', style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  )),
                      ),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 50,
                      left: cx1,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 150,
                      left: cx2,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 30,
                      left: cx3,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 200,
                      left: cx4,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 225,
                      left: cx5,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedPositioned(
                      height: 50,
                      width: 100,
                      top: 120,
                      left: cx6,
                      child: Image.asset('assets/images/cloud.png'),
                      duration: Duration(milliseconds: 10),
                    ),
                    AnimatedContainer(
                        alignment: Alignment(birdX, birdY),
                        duration: Duration(milliseconds: 50),
                        child: SizedBox(
                          key: keyb,
                          child: Image.asset('assets/images/flappy.png'),
                          height: 60,
                          width: 60,
                        )),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 1),
                      bottom: -5,
                      left: fx,
                      height: h1,
                      width: 75,
                      child: Container(
                        key: keyf1,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 5),
                            color: c1,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        // height: 100,
                        // width: 75,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 1),
                      height: h2,
                      width: 75,
                      top: -5,
                      left: fx,
                      child: Container(
                        key: keyf2,
                        decoration: BoxDecoration(
                            color: c2,
                            border: Border.all(color: Colors.black38, width: 5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                      ),
                    ),
                    AnimatedPositioned(
                      height: h3,
                      width: 75,
                      duration: Duration(milliseconds: 1),
                      bottom: -5,
                      left: sx,
                      child: Container(
                        key: keys1,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 5),
                            color: c3,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                      ),
                    ),
                    AnimatedPositioned(
                      height: h4,
                      width: 75,
                      duration: Duration(milliseconds: 1),
                      top: -5,
                      left: sx,
                      child: Container(
                        key: keys2,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 5),
                            color: c4,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 1),
                      height: h5,
                      width: 75,
                      bottom: -5,
                      left: tx,
                      child: Container(
                        key: keyt1,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 5),
                            color: c5,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                      ),
                    ),
                    AnimatedPositioned(
                      height: h6,
                      width: 75,
                      duration: Duration(milliseconds: 1),
                      top: -5,
                      left: tx,
                      child: Container(
                        key: keyt2,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 5),
                            color: c5,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        height: 10,
                        width: 75,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 15,
                color: Colors.green,
              ),
              Expanded(
                child: Container(
                  width: _width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'SCORE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            score.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'BEST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            best.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  color: Colors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
