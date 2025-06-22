import 'package:flutter/material.dart';
import 'dart:async';
import 'visual_novel.dart';

class SpriteSwap extends StatelessWidget {
  final String currentAsset;
  final List<String> allAssets;
  final double height;

  const SpriteSwap({
    required this.currentAsset,
    required this.allAssets,
    this.height = 600,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: allAssets.map((asset) {
        return AnimatedOpacity(
          opacity: asset == currentAsset ? 1.0 : 0.0,
          duration: Duration.zero,
          child: Image.asset(
            asset,
            height: height,
            gaplessPlayback: true,
          ),
        );
      }).toList(),
    );
  }
}

class VisualNovelReader extends StatefulWidget {
  final Character character;
  final VisualNovelStep step;
  final bool isThinkingAnimated;
  final void Function(String input)? onInput;
  final void Function(String choice)? onChoice;

  const VisualNovelReader({
    super.key,
    required this.character,
    required this.step,
    required this.isThinkingAnimated,
    this.onInput,
    this.onChoice,
  });

  @override
  State<VisualNovelReader> createState() => _VisualNovelReaderState();
}

class _VisualNovelReaderState extends State<VisualNovelReader>
    with SingleTickerProviderStateMixin {
  Timer? _frameTimer;
  int _frame = 0;
  static const int frameCount = 3;
  static const Duration frameDuration = Duration(milliseconds: 125);

  // Bobbing animation for default sprite
  late AnimationController _bobController;
  late Animation<double> _bobAnim;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _bobAnim = Tween<double>(begin: 0, end: -20)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_bobController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheSprites(context); // Pre-cache here!
    });

    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant VisualNovelReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    precacheSprites(context); // Pre-cache if sprites changed!
    _updateAnimation();
    if (_shouldAnimate()) {
      _bobController.stop();
    } else {
      _bobController.repeat(reverse: true);
    }
  }

  void precacheSprites(BuildContext context) {
    final allAssets = <String>{
      ...widget.character.states.values.expand((state) =>
          [if (state.asset.isNotEmpty) state.asset, ...state.assetFrames])
    };
    for (final path in allAssets) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _updateAnimation() {
    _frameTimer?.cancel();
    _frame = 0;
    if (_shouldAnimate()) {
      _frameTimer = Timer.periodic(frameDuration, (timer) {
        setState(() {
          _frame = (_frame + 1) % frameCount;
        });
      });
    }
  }

  bool _shouldAnimate() => widget.isThinkingAnimated;

  @override
  void dispose() {
    _bobController.dispose();
    _frameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String spriteAsset;
    if (_shouldAnimate()) {
      spriteAsset = widget.character.getState('thinking').assetFrames[_frame];
    } else {
      final state = widget.character.getState(widget.step.stateTag);
      if (state.asset.isNotEmpty) {
        spriteAsset = state.asset;
      } else if (state.assetFrames.isNotEmpty) {
        spriteAsset = state.assetFrames[0];
      } else {
        spriteAsset = 'assets/images/sprites/otter/otter_default.png';
      }
    }

    // Get all unique sprite asset paths
    final allSpriteAssets = <String>{
      ...widget.character.states.values.expand((state) =>
          [if (state.asset.isNotEmpty) state.asset, ...state.assetFrames])
    }.toList();

    Widget spriteWidget = SpriteSwap(
      currentAsset: spriteAsset,
      allAssets: allSpriteAssets,
      height: 600,
    );

    // Bob/stretch when default and NOT animating
    if (!_shouldAnimate() && widget.step.stateTag == "default") {
      spriteWidget = AnimatedBuilder(
        animation: _bobAnim,
        builder: (context, child) {
          // Bobbing progress: 0 (top) to 1 (bottom)
          final progress = 1 - ((_bobAnim.value + 20) / 20);
          // Tiny squash/stretch
          final scaleY = 1.0 +
              0.03 *
                  (progress < 0.5 ? -(progress * 2 - 1) : (progress * 2 - 1));
          return Transform.translate(
            offset: Offset(0, _bobAnim.value),
            child: Transform.scale(
              scaleY: scaleY,
              scaleX: 1 / scaleY,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: child,
              ),
            ),
          );
        },
        child: spriteWidget,
      );
    } else {
      // Always pad the bottom
      spriteWidget = Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: spriteWidget,
      );
    }

    // ...rest of your widget tree (as before)...
    return Stack(
      children: [
        if (widget.step.backgroundAsset != null)
          Positioned.fill(
            child: Image.asset(widget.step.backgroundAsset!, fit: BoxFit.cover),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: spriteWidget,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black.withAlpha(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.step.text,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                if (widget.step.customWidget != null) ...[
                  const SizedBox(height: 10),
                  widget.step.customWidget!,
                ] else if (widget.step.expectsInput) ...[
                  const SizedBox(height: 10),
                  _InputField(onInput: widget.onInput),
                ] else if (widget.step.choices != null &&
                    widget.step.choices!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  for (final choice in widget.step.choices!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ElevatedButton(
                        onPressed: () => widget.onChoice?.call(choice),
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
        fillColor: Colors.black.withAlpha(40),
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
