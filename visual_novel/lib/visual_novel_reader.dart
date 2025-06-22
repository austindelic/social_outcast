import 'package:flutter/material.dart';
import 'visual_novel_step.dart';

// Now you just need the step & the handler for what happens next.
class VisualNovelReader extends StatelessWidget {
  final VisualNovelStep step;
  final void Function(String input)? onInput;
  final void Function(String choice)? onChoice;

  const VisualNovelReader({
    super.key,
    required this.step,
    this.onInput,
    this.onChoice,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        if (step.backgroundAsset != null)
          Positioned.fill(
            child: Image.asset(step.backgroundAsset!, fit: BoxFit.cover),
          ),
        // Character
        if (step.characterAsset != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 180),
              child: Image.asset(step.characterAsset!, height: 300),
            ),
          ),
        // Text & input/choices
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black.withValues(
              alpha: 0.1,
            ), // Optional: faint overlay,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  step.text,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                if (step.customWidget != null) ...[
                  const SizedBox(height: 10),
                  step.customWidget!,
                ] else if (step.expectsInput) ...[
                  const SizedBox(height: 10),
                  _InputField(onInput: onInput),
                ] else if (step.choices != null &&
                    step.choices!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  for (final choice in step.choices!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ElevatedButton(
                        onPressed: () => onChoice?.call(choice),
                        child: Text(choice),
                      ),
                    )
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatefulWidget {
  final void Function(String)? onInput;
  const _InputField({this.onInput});

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter your answer...",
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black.withValues(
          alpha: 0.1,
        ), // Optional: faint overlay,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (value) {
        widget.onInput?.call(value);
        _controller.clear();
      },
    );
  }
}
