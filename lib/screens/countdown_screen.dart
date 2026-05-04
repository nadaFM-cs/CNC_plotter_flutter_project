import 'dart:async';
import 'package:flutter/material.dart';
import '../constant/color.dart';
import 'choose_screen.dart';

class CountdownScreen extends StatefulWidget {
  final String timeString;

  const CountdownScreen({super.key, required this.timeString});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _parseTime(widget.timeString);
    _remainingSeconds = _totalSeconds;

    _ringController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    )..forward();

    _startTimer();
  }

  int _parseTime(String t) {
    // da 3lshan y handle el counter
    final parts = t.split(':').map(int.parse).toList();
    if (parts.length == 3) {
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    } else if (parts.length == 2) {
      return parts[0] * 60 + parts[1];
    }
    return int.tryParse(t) ?? 0;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _onDone();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _onDone() {
    setState(() {});
  }

  void _stopAndGoBack() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stop plotting?'),
        content: const Text('Are you sure you want to stop and go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Choosescreen()),
                    (_) => false,
              );
            },
            child: const Text('Stop', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer?.cancel();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;

    final th = _totalSeconds ~/ 3600;
    final tm = (_totalSeconds % 3600) ~/ 60;
    final ts = _totalSeconds % 60;

    final progress = _totalSeconds > 0
        ? _remainingSeconds / _totalSeconds
        : 0.0;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: maincolor,
          automaticallyImplyLeading: false,
          title: const Text(
            'CNCr@ft — Plotting',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child:  _remainingSeconds <= 0
                ? _buildDoneState()
                : _buildCountingState(),
          ),
        ),
      ),
    );
  }

  Widget _buildCountingState() {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;


    final th = _totalSeconds ~/ 3600;
    final tm = (_totalSeconds % 3600) ~/ 60;
    final ts = _totalSeconds % 60;


    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Column(
      children: [
        const Text('Estimated time remaining',
            style: TextStyle(fontSize: 13, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 32),

        SizedBox(
          width: 220, height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220, height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: const Color(0xFFE5EDE9),
                  valueColor: const AlwaysStoppedAnimation<Color>(maincolor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${_fmt(h)}:${_fmt(m)}:${_fmt(s)}',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500,
                          color: maincolor, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  const Text('hh : mm : ss',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        Row(children: [
          _buildSegment(_fmt(th), 'hours'),
          const SizedBox(width: 12),
          _buildSegment(_fmt(tm), 'minutes'),
          const SizedBox(width: 12),
          _buildSegment(_fmt(ts), 'seconds'),
        ]),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            _PulsingDot(),
            const SizedBox(width: 10),
            const Text('CNC machine is plotting your design...',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
          ]),
        ),
        const SizedBox(height: 16),


        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _stopAndGoBack,
            icon: const Icon(Icons.stop_rounded, color: Colors.red, size: 18),
            label: const Text('Stop & go back',
                style: TextStyle(color: Colors.red, fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDoneState() {
    final th = _totalSeconds ~/ 3600;
    final tm = (_totalSeconds % 3600) ~/ 60;
    final ts = _totalSeconds % 60;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: maincolor, size: 44),
        ),
        const SizedBox(height: 20),
        const Text('Plotting complete!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: maincolor)),
        const SizedBox(height: 8),
        const Text('Your design has been successfully\nplotted by the CNC machine.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 32),

        Row(children: [
          _buildSegment(_fmt(th), 'hours'),
          const SizedBox(width: 12),
          _buildSegment(_fmt(tm), 'minutes'),
          const SizedBox(width: 12),
          _buildSegment(_fmt(ts), 'seconds'),
        ]),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.check_circle, color: maincolor, size: 16),
            const SizedBox(width: 10),
            const Text('Done! Your plot is ready.',
                style: TextStyle(fontSize: 13, color: maincolor)),
          ]),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Choosescreen()),
                  (_) => false,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Back to home',
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildSegment(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: maincolor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween(begin: 1.0, end: 0.2).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: maincolor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}