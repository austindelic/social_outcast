import 'package:flutter/material.dart';
import '../../lib/lib/visual_novel/models.dart';

class VisualNovelReader extends StatefulWidget {
  final VisualNovel novel;
  final void Function(String)? onInput;

  const VisualNovelReader({super.key, required this.novel, this.onInput});

  @override
  State<VisualNovelReader> createState() => _VisualNovelReaderState();
}

class _VisualNovelReaderState extends State<VisualNovelReader> {
  final TextEditingController _controller = TextEditingController();
  late String _novelText;

  @override
  void initState() {
    super.initState();
    _novelText = widget.novel.introText;
  }

  void _onSubmit(String value) {
    setState(() {
      _novelText =
          "Hello, $value! Your journey in '${widget.novel.title}' begins...";
      _controller.clear();
    });
    if (widget.onInput != null) widget.onInput!(value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(widget.novel.background, fit: BoxFit.cover),
        ),
        // Sprite
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 180),
            child: Image.asset(widget.novel.sprite, height: 300),
          ),
        ),
        // Textbox and input
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black.withValues(alpha: 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _novelText,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your answer...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
