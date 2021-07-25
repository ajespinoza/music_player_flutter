import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MusicPlayerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Background(),

          Column(
            children: [
              CustomAppBar(),

              Stack(
                children: [

                  CajaDisco(),

                  Positioned(
                    top: 100,
                    left: 50,
                    child: Container(
                      width: 200,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black45,
                            Colors.blueGrey.shade900
                          ]
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)
                        ]
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      width: 260,
                      height: 37,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.grey.shade900
                          ]
                        )
                      ),
                    ),
                  ),

                  Positioned(
                    top: 56,
                    left: 28,
                    child: Container(
                      width: 240,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.blueGrey.shade800
                          ]
                        )
                      ),
                    ),
                  ),

                  Positioned(
                    top: 77,
                    left: 28,
                    child: Container(
                      width: 240,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.blueGrey.shade900,
                            Colors.grey.shade900
                          ]
                        )
                      ),
                    ),
                  ),

                  ImagenDiscoDuracion(),
                  Transform(
                    transform: Matrix4.rotationZ(0.3 * audioPlayerModel.porcentaje),
                    alignment: Alignment.topLeft,
                    child: AntenaTocadisco()
                  ),
                ],
              ),
              

              TituloPlay(),

              Expanded(
                child: Lyrics(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        ),
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.5,
        children: lyrics.map(
          (linea) => Text(linea, style: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.6)))
        ).toList()
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  const TituloPlay({
    Key? key,
  }) : super(key: key);

  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin{
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimation;

  final assetAudioPlayer = new AssetsAudioPlayer(); 

  @override
  void initState() { 
    playAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open(){
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    assetAudioPlayer.open(Audio('assets/Arrullodeestrellas.mp3'));
    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {

      audioPlayerModel.songDuration = playingAudio != null ? playingAudio.audio.duration : Duration(minutes: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: [

          Column(
            children: [
              Text('Arrullo de Estrellas', style: TextStyle(fontSize: 27, color: Colors.white.withOpacity(0.8)),),
              Text('-Zoé-', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5)),),
            ],
          ),
          Spacer(),

          FloatingActionButton(
            onPressed: (){

              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
              if(this.isPlaying){
                playAnimation.reverse();
                this.isPlaying = false;
                audioPlayerModel.controller.stop();
              }else{
                playAnimation.forward();
                this.isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if(firstTime){
                this.open();
                firstTime = false;
              }else{
                assetAudioPlayer.playOrPause();
              }

            },
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
              size: 30,
            ),
            elevation: 0,
            highlightElevation: 0,
          ),
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 100),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(5,10),
                  color: Colors.black.withOpacity(0.2),
                )
              ],
            ),
            child: ImagenDisco()
          ),
          SizedBox(width: 40,),
          BarraProgreso(),
          SizedBox(width: 20,),
        ],
      )
    );
  }
}

class AntenaTocadisco extends StatelessWidget {
  const AntenaTocadisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 320,
      child: Stack(
        children: [

            Positioned(
              top: 50,
              left: 30,
              child: Transform.rotate(
                angle: -20,
                child: Container(
                  width: 25,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black45,
                        Colors.black87
                      ]
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 5)
                    ]
                  ),
                ),
              ),
            ),
            Positioned(
              top: 54,
              left: 33,
              child: Transform.rotate(
                angle: -20,
                child: Container(
                  width: 18,
                  height: 33,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.1)
                      ]
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 5)
                    ]
                  ),
                ),
              ),
            ),

            Positioned(
              top: 37,
              left: 118,
              child: Transform.rotate(
                angle: -20,
                child: Container(
                  width: 10,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                        Colors.grey.shade600
                      ]
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 5)
                    ]
                  ),
                ),
              ),
            ),
            Positioned(
              right: 92,
              top: 128,
              child: Transform.rotate(
                angle: -20,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.black,
                        Colors.grey.shade800
                      ]
                    )
                  ),
                ),
              ),
            ),

            Positioned(
              right: 84,
              top: 135,
              child: Transform.rotate(
                angle: 50,
                child: Container(
                  width: 12,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topLeft,
                      stops: [0.0, 0.8, 1.0],
                      colors: [
                        Colors.black,
                        Colors.grey.shade800,
                        Colors.grey.shade800.withOpacity(0.6)
                      ]
                    )
                  ),
                ),
              ),
            ),

            Positioned(
              right: 87,
              top: 138,
              child: Transform.rotate(
                angle: 50,
                child: Container(
                  width: 7,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.0)
                      ]
                    )
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CajaDisco extends StatelessWidget {
  const CajaDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: Container(
        width: 280,
        height: 340,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.brown.shade900,
              Colors.brown.shade800
            ]
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)
          ]
        ),
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  const BarraProgreso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    return Container(
      child: Column(
        children: [
          Text('${audioPlayerModel.songTotalDuration}', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
          SizedBox(height: 10,),
          Stack(
            children: [
              Container(
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * porcentaje,
                  color: Colors.yellow.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text('${audioPlayerModel.currentSecond}', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
        ],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {
  const ImagenDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
              SpinPerfect(
                duration: Duration(seconds: 10),
                infinite: true,
                manualTrigger: true,
                animate: false,
                controller: (animationController) => audioPlayerModel.controller = animationController,
                child: Image(
                  image: AssetImage('assets/frontal.jpg'),
                ),
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.black.withOpacity(0.4)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100)
                ),
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.3)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100)
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Color(0xff1C1C25),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ]
        )
      ),
    );
  }
}