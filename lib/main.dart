import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R.E.D.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 138, 18, 18),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const WelcomePage(),
        '/modes': (ctx) => const ModeSelectionPage(),
        '/modeA': (ctx) => const DrivingPage(),
        '/modeB': (ctx) => const TrackingRoomPage(),
        '/modeC': (ctx) => const DrawingPage(),
      },
    );
  }
}

/* ---------------- WelcomePage (stateful for animations) ---------------- */
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Steuerung der Auto-Einfahrt
  bool animateCar = false;

  @override
  void initState() {
    super.initState();
    // Auto nach kurzem Delay von rechts herein fahren lassen
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          animateCar = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Farben aus Theme nutzen, so passt alles zusammen
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape =
            orientation == Orientation.landscape || constraints.maxWidth > 800;

        // Bildgrößen adaptiv
        final double imageHeight =
            isLandscape ? (constraints.maxHeight * 0.5) : 160;
        final double imageMaxWidth =
            isLandscape ? constraints.maxWidth * 0.35 : constraints.maxWidth * 0.45;

        return Container(
          decoration: BoxDecoration(
            // linearer Verlauf von oben nach unten (top -> bottom)
            gradient: LinearGradient(
              colors: [
                const Color(0xFFB71C1C), // oben (rot)
                const Color.fromARGB(255, 57, 57, 57), // unten (dunkelgrau)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: isLandscape
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Linke Spalte: Text + Button
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome to R.E.D.',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Choose your mode to start',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/modes'),
                                  child: const Text('modes'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Rechte Spalte: Flagge + Auto (Stack, Auto fährt VON RECHTS)
                          Expanded(
                            flex: 6,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final imageMaxWidth = constraints.maxWidth * 0.45;
                                final imageHeight = constraints.maxHeight * 0.8;

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // FLAGGE: positioniert etwas links hinter dem Auto
                                    Positioned(
                                      left: imageMaxWidth * 0.06,
                                      top: imageHeight * -0.08,
                                      child: Image.asset(
                                        'assets/images/Checkerflag.png',
                                        width: imageMaxWidth * 0.5,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    // AUTO: fährt von rechts herein
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.easeOutCubic,
                                      right: animateCar ? 0 : -constraints.maxWidth * 0.75,
                                      bottom: 0,
                                      child: SizedBox(
                                        width: imageMaxWidth,
                                        height: imageHeight,
                                        child: Image.asset(
                                          'assets/images/ferrari.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome to R.E.D.',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Choose your next mode to start',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 18),
                          // Responsive Bilder: nebeneinander auf breiten Portrait-Geräten
                          LayoutBuilder(builder: (context, inner) {
                            final wide = inner.maxWidth > 600;
                            if (wide) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: inner.maxWidth * 0.4),
                                    child: Image.asset(
                                      'assets/images/Checkerflag.png',
                                      fit: BoxFit.contain,
                                      height: 160,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: inner.maxWidth * 0.4),
                                    child: Image.asset(
                                      'assets/images/ferrari.png',
                                      fit: BoxFit.contain,
                                      height: 160,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Image.asset(
                                    'assets/images/Checkerflag.png',
                                    fit: BoxFit.contain,
                                    height: 140,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeOutCubic,
                                    margin: EdgeInsets.only(left: animateCar ? 0 : -inner.maxWidth * 0.7),
                                    child: Image.asset(
                                      'assets/images/ferrari.png',
                                      fit: BoxFit.contain,
                                      height: 140,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/modes'),
                            child: const Text('Choose your mode'),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/* ---------------- ModeSelectionPage ---------------- */
class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose mode')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('Driving'),
            subtitle: const Text('Drive with easy controls'),
            onTap: () => Navigator.pushNamed(context, '/modeA'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Tracking room'),
            subtitle: const Text('Track the room to drive inside without crashing'),
            onTap: () => Navigator.pushNamed(context, '/modeB'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brush),
            title: const Text('Drawing the route'),
            subtitle: const Text('Draw the route the car should follow'),
            onTap: () => Navigator.pushNamed(context, '/modeC'),
          ),
        ],
      ),
    );
  }
}

/* ---------------- ModePage (generic) ---------------- */
class ModePage extends StatelessWidget {
  final String title;
  const ModePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title - Hier kommt der Inhalt für diesen Modus.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/* ---------------- DrivingPage (Buttons, Reverse on long brake) ---------------- */
class DrivingPage extends StatefulWidget {
  const DrivingPage({super.key});

  @override
  State<DrivingPage> createState() => _DrivingPageState();
}

class _DrivingPageState extends State<DrivingPage> {
  Timer? _timer;
  Timer? _reverseTimer;
  double speed = 0.0; // positive = forward, negative = reverse (km/h)
  double throttle = 0.0; // -1..1 (driven by button / reverse)
  double brake = 0.0; // 0..1
  double steering = 0.0; // -1..1

  // Button state flags
  bool accelerating = false;
  bool braking = false;
  bool steerLeft = false;
  bool steerRight = false;
  bool reversing = false; // enabled after long brake

  @override
  void initState() {
    super.initState();
    // Physik-Loop (~20 FPS)
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) => _updatePhysics());
  }

  void _updatePhysics() {
    const double dt = 0.05; // Sekunden pro Tick

    // Wenn reversing aktiv, throttle = -1 (Rückwärts), sonst 0..1 vorne
    if (reversing) {
      throttle = -1.0;
      brake = 0.0;
    } else {
      throttle = accelerating ? 1.0 : 0.0;
      brake = braking ? 1.0 : 0.0;
    }

    // Lenken: solange gedrückt, lenke mit Rate; wenn losgelassen, zurück zur Mitte (Dämpfung)
    const double steerRate = 1.5; // pro Sekunde
    const double steerReturnRate = 2.5;
    if (steerLeft && !steerRight) {
      steering -= steerRate * dt;
    } else if (steerRight && !steerLeft) {
      steering += steerRate * dt;
    } else {
      if (steering > 0) {
        steering -= steerReturnRate * dt;
        if (steering < 0) steering = 0;
      } else if (steering < 0) {
        steering += steerReturnRate * dt;
        if (steering > 0) steering = 0;
      }
    }
    steering = steering.clamp(-1.0, 1.0);

    // einfache Beschleunigung: positive throttle beschleunigt vorwärts, negative rückwärts
    final double accel = throttle * 6.0 - brake * 10.0 - speed.sign * (speed.abs() * 0.04);
    speed += accel * dt * 3.6; // skaliere zu km/h

    // Begrenzungen: Rückwärts langsamer (−80..320)
    if (speed > 320) speed = 320;
    if (speed < -80) speed = -80;

    // kleine Deadzone: wenn nahe 0 und kein throttle/brake, setze exakt 0
    if (!accelerating && !braking && !reversing && speed.abs() < 0.5) {
      speed = 0.0;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _reverseTimer?.cancel();
    super.dispose();
  }

  String _speedText() => '${speed.abs().toInt()} km/h';
  String _rpmText() => '${(speed.abs() * 30).toInt()} rpm';

  // Helfer für gedrückt/losgelassen Verhalten
  void _pressAccelerate(bool down) {
    setState(() {
      accelerating = down;
      if (down) reversing = false; // weg vom Rückwärtsgang bei Gas
    });
  }

  void _pressBrake(bool down) {
    if (down) {
      // Start Long-Press-Timer -> wenn gehalten und Auto steht fast, aktiviere Rückwärtsgang
      setState(() => braking = true);
      _reverseTimer?.cancel();
      _reverseTimer = Timer(const Duration(milliseconds: 700), () {
        // nur einschalten, wenn weitergehalten wird und Geschwindigkeit nahe 0
        if (braking && speed.abs() < 1.0) {
          setState(() {
            reversing = true;
            // ensure immediate reverse motion next physics tick
          });
        }
      });
    } else {
      _reverseTimer?.cancel();
      setState(() {
        braking = false;
        // wenn Bremse losgelassen, beende Rückwärtsmodus (falls aktiv)
        reversing = false;
      });
    }
  }

  void _pressSteerLeft(bool down) => setState(() => steerLeft = down);
  void _pressSteerRight(bool down) => setState(() => steerRight = down);

  Widget _controlButton({
    required Widget child,
    required void Function(bool) onHold,
    double width = 120,
    double height = 56,
    Color? color,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onHold(true),
      onTapUp: (_) => onHold(false),
      onTapCancel: () => onHold(false),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color ?? Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rot-Grau Verlauf
    final gradientTop = Colors.red.shade700;
    final gradientBottom = Colors.grey.shade900;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Driving'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientTop, gradientBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Hauptinhalt: HUD oben + Track in der Mitte
              Column(
                children: [
                  // HUD: Speed / RPM + Gear Anzeige
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_speedText(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(_rpmText(), style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Gear: ${reversing || speed < 0 ? 'R' : 'D'}', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('Mode: Arcade', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Platzhalter für Rennstrecke / Auto-View
                  Expanded(
                    child: Center(
                      child: Transform.rotate(
                        angle: steering * 0.6 * (reversing ? -1 : 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.28,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Center(
                            child: Icon(Icons.directions_car_filled, size: 80, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Platz für die overlaid Buttons am unteren Rand
                ],
              ),

              // Linke Seite: Lenkung (vertikal zentriert)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controlButton(
                        onHold: _pressSteerLeft,
                        width: 110,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.chevron_left, color: Colors.white), SizedBox(width: 6), Text('Left', style: TextStyle(color: Colors.white))],
                        ),
                        color: Colors.white12,
                      ),
                      _controlButton(
                        onHold: _pressSteerRight,
                        width: 110,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.chevron_right, color: Colors.white), SizedBox(width: 6), Text('Right', style: TextStyle(color: Colors.white))],
                        ),
                        color: Colors.white12,
                      ),
                    ],
                  ),
                ),
              ),

              // Rechte Seite: Gas / Bremse (vertikal zentriert)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controlButton(
                        onHold: _pressAccelerate,
                        width: 130,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.arrow_upward, color: Colors.white), SizedBox(width: 8), Text('Accelerate', style: TextStyle(color: Colors.white))],
                        ),
                        color: Colors.red.shade700.withOpacity(0.16),
                      ),
                      _controlButton(
                        onHold: _pressBrake,
                        width: 130,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(reversing ? 'Reverse' : 'Brake', style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        color: reversing ? Colors.orange.withOpacity(0.22) : Colors.black.withOpacity(0.18),
                      ),
                    ],
                  ),
                ),
              ),

              // Fußzeile: Utility-Buttons (unten zentriert)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            throttle = 0;
                            brake = 0;
                            speed = 0;
                            accelerating = braking = steerLeft = steerRight = reversing = false;
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            accelerating = true;
                            braking = false;
                            reversing = false;
                          });
                          Future.delayed(const Duration(milliseconds: 300), () {
                            setState(() => accelerating = false);
                          });
                        },
                        icon: const Icon(Icons.rocket_launch),
                        label: const Text('Burst'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- TrackingRoomPage (Beispiel-Modus B) ---------------- */
class TrackingRoomPage extends StatefulWidget {
  const TrackingRoomPage({super.key});

  @override
  State<TrackingRoomPage> createState() => _TrackingRoomPageState();
}

class _TrackingRoomPageState extends State<TrackingRoomPage> {
  bool tracking = false;
  double obstacleX = 0.0; // Beispiel: zufälliges Hindernis
  @override
  void initState() {
    super.initState();
    obstacleX = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Room')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enable Tracking'),
                value: tracking,
                onChanged: (v) => setState(() => tracking = v),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Stack(
                        children: [
                          // fake "camera" background -> correct asset path
                          Positioned.fill(
                              child: Image.asset(
                            'assets/images/Checkerflag.png',
                            fit: BoxFit.cover,
                            color: Colors.white24,
                            colorBlendMode: BlendMode.modulate,
                          )),
                          // Beispiel-Hindernis
                          Positioned(
                            left: (MediaQuery.of(context).size.width - 24) * obstacleX,
                            top: 60,
                            child: Icon(Icons.warning_amber_rounded, color: tracking ? Colors.orangeAccent : Colors.white24, size: 48),
                          ),
                          if (!tracking)
                            const Center(child: Text('Tracking disabled', style: TextStyle(color: Colors.white70))),
                          if (tracking)
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: ElevatedButton(
                                onPressed: () => setState(() => obstacleX = (obstacleX + 0.15) % 0.8),
                                child: const Text('Simulate Obstacle Move'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- DrawingPage (Beispiel-Modus C) ---------------- */
class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draw Route')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Draw a path on the screen. Use Clear to reset.', style: TextStyle(color: Colors.white70)),
              ),
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final box = context.findRenderObject() as RenderBox;
                      _points.add(box.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (_) => _points.add(Offset.zero),
                  child: CustomPaint(
                    painter: _RoutePainter(_points),
                    child: Container(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _points.clear()),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Beispiel: export points length
                        final count = _points.where((p) => p != Offset.zero).length;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Points: $count')));
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
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

class _RoutePainter extends CustomPainter {
  final List<Offset> points;
  _RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()..color = Colors.yellowAccent..strokeWidth = 4.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final paintDot = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final path = Path();
    bool started = false;
    for (final p in points) {
      if (p == Offset.zero) {
        started = false;
        continue;
      }
      if (!started) {
        path.moveTo(p.dx, p.dy);
        started = true;
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paintLine);
    for (final p in points) {
      if (p == Offset.zero) continue;
      canvas.drawCircle(p, 2.5, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => true;
}
