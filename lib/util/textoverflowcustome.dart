import 'package:flutter/rendering.dart';
import 'dart:ui' as ui show Gradient, Shader, TextBox;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OverflowText extends LeafRenderObjectWidget {
  final TextSpan textSpan;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final TextOverflowBuilder overflowBuilder;

  OverflowText(
      {this.textSpan,
        this.textAlign: TextAlign.start,
        this.textDirection,
        this.softWrap: true,
        this.overflow: TextOverflow.clip,
        this.maxLines,
        this.overflowBuilder,
        this.textScaleFactor: 1.0});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return new OverflowTextRenderObject(this.textSpan,
        textAlign: textAlign,
        textDirection: textDirection ?? Directionality.of(context),
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        overflowBuilder: overflowBuilder);
  }

  @override
  void updateRenderObject(
      BuildContext context, OverflowTextRenderObject renderObject) {
    renderObject
      ..text = textSpan
      ..textAlign = textAlign
      ..textDirection = textDirection ?? Directionality.of(context)
      ..softWrap = softWrap
      ..overflow = overflow
      ..textScaleFactor = textScaleFactor
      ..overflowBuilder = overflowBuilder
      ..maxLines = maxLines;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(new StringProperty('textSpan', textSpan.toPlainText()));
  }
}

typedef TextSpan TextOverflowBuilder(Size size);

const String _kEllipsis = '[...]';//'\u2026';

/// A render object that displays a paragraph of text
class OverflowTextRenderObject extends RenderBox {
  /// Creates a paragraph render object.
  ///
  /// The [text], [textAlign], [textDirection], [overflow], [softWrap], and
  /// [textScaleFactor] arguments must not be null.
  ///
  /// The [maxLines] property may be null (and indeed defaults to null), but if
  /// it is not null, it must be greater than zero.
  OverflowTextRenderObject(
      TextSpan text, {
        TextAlign textAlign: TextAlign.start,
        @required TextDirection textDirection,
        bool softWrap: true,
        TextOverflow overflow: TextOverflow.clip,
        double textScaleFactor: 1.0,
        int maxLines,
        this.overflowBuilder,
      })  : assert(text != null),
        assert(text.debugAssertIsValid()),
        assert(textAlign != null),
        assert(textDirection != null),
        assert(softWrap != null),
        assert(overflow != null),
        assert(textScaleFactor != null),
        assert(maxLines == null || maxLines > 0),
        _softWrap = softWrap,
        _overflow = overflow,
        _textPainter = new TextPainter(
          text: text,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          ellipsis: overflow == TextOverflow.ellipsis ? _kEllipsis : null,
        );

  TextOverflowBuilder overflowBuilder;

  final TextPainter _textPainter;

  /// The text to display
  TextSpan get text => _textPainter.text;
  set text(TextSpan value) {
    assert(value != null);
    switch (_textPainter.text.compareTo(value)) {
      case RenderComparison.identical:
      case RenderComparison.metadata:
        return;
      case RenderComparison.paint:
        _textPainter.text = value;
        markNeedsPaint();
        break;
      case RenderComparison.layout:
        _textPainter.text = value;
        _overflowShader = null;
        markNeedsLayout();
        break;
    }
  }

  /// How the text should be aligned horizontally.
  TextAlign get textAlign => _textPainter.textAlign;
  set textAlign(TextAlign value) {
    assert(value != null);
    if (_textPainter.textAlign == value) return;
    _textPainter.textAlign = value;
    markNeedsPaint();
  }

  /// The directionality of the text.
  ///
  /// This decides how the [TextAlign.start], [TextAlign.end], and
  /// [TextAlign.justify] values of [textAlign] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [text] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// This must not be null.
  TextDirection get textDirection => _textPainter.textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textPainter.textDirection == value) return;
    _textPainter.textDirection = value;
    markNeedsLayout();
  }

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  ///
  /// If [softWrap] is false, [overflow] and [textAlign] may have unexpected
  /// effects.
  bool get softWrap => _softWrap;
  bool _softWrap;
  set softWrap(bool value) {
    assert(value != null);
    if (_softWrap == value) return;
    _softWrap = value;
    markNeedsLayout();
  }

  /// How visual overflow should be handled.
  TextOverflow get overflow => _overflow;
  TextOverflow _overflow;
  set overflow(TextOverflow value) {
    assert(value != null);
    if (_overflow == value) return;
    _overflow = value;
    _textPainter.ellipsis = value == TextOverflow.ellipsis ? _kEllipsis : null;
    markNeedsLayout();
  }

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  double get textScaleFactor => _textPainter.textScaleFactor;
  set textScaleFactor(double value) {
    assert(value != null);
    if (_textPainter.textScaleFactor == value) return;
    _textPainter.textScaleFactor = value;
    _overflowShader = null;
    markNeedsLayout();
  }

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow] and [softWrap].
  int get maxLines => _textPainter.maxLines;

  /// The value may be null. If it is not null, then it must be greater than zero.
  set maxLines(int value) {
    assert(value == null || value > 0);
    if (_textPainter.maxLines == value) return;
    _textPainter.maxLines = value;
    _overflowShader = null;
    markNeedsLayout();
  }

  void _layoutText({double minWidth: 0.0, double maxWidth: double.infinity}) {
    final bool widthMatters = softWrap || overflow == TextOverflow.ellipsis;
    _textPainter.layout(
        minWidth: minWidth,
        maxWidth: widthMatters ? maxWidth : double.infinity);
  }

  void _layoutTextWithConstraints(BoxConstraints constraints) {
    _layoutText(minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    _layoutText();
    return _textPainter.minIntrinsicWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    _layoutText();
    return _textPainter.maxIntrinsicWidth;
  }

  double _computeIntrinsicHeight(double width) {
    _layoutText(minWidth: width, maxWidth: width);
    return _textPainter.height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    assert(constraints != null);
    assert(constraints.debugAssertIsValid());
    _layoutTextWithConstraints(constraints);
    return _textPainter.computeDistanceToActualBaseline(baseline);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is! PointerDownEvent) return;
    _layoutTextWithConstraints(constraints);
    final Offset offset = entry.localPosition;
    final TextPosition position = _textPainter.getPositionForOffset(offset);
    final TextSpan span = _textPainter.text.getSpanForPosition(position);
    span?.recognizer?.addPointer(event);
  }

  bool _hasVisualOverflow = false;
  ui.Shader _overflowShader;

  @visibleForTesting
  bool get debugHasOverflowShader => _overflowShader != null;

  void _performLayout() {
    _layoutTextWithConstraints(constraints);

    final Size textSize = _textPainter.size;
    final bool didOverflowHeight = _textPainter.didExceedMaxLines;
    size = constraints.constrain(textSize);

    final bool didOverflowWidth = size.width < textSize.width;

    _hasVisualOverflow = didOverflowWidth || didOverflowHeight;
    if (_hasVisualOverflow) {
      switch (_overflow) {

        case TextOverflow.clip:
        case TextOverflow.ellipsis:
          _overflowShader = null;
          break;
        case TextOverflow.fade:
          assert(textDirection != null);
          final TextPainter fadeSizePainter = new TextPainter(
            text: new TextSpan(style: _textPainter.text.style, text: '\u2026'),
            textDirection: textDirection,
            textScaleFactor: textScaleFactor,
          )..layout();
          if (didOverflowWidth) {
            double fadeEnd, fadeStart;
            switch (textDirection) {
              case TextDirection.rtl:
                fadeEnd = 0.0;
                fadeStart = fadeSizePainter.width;
                break;
              case TextDirection.ltr:
                fadeEnd = size.width;
                fadeStart = fadeEnd - fadeSizePainter.width;
                break;
            }
            _overflowShader = new ui.Gradient.linear(
              new Offset(fadeStart, 0.0),
              new Offset(fadeEnd, 0.0),
              <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
            );
          } else {
            final double fadeEnd = size.height;
            final double fadeStart = fadeEnd - fadeSizePainter.height / 2.0;
            _overflowShader = new ui.Gradient.linear(
              new Offset(0.0, fadeStart),
              new Offset(0.0, fadeEnd),
              <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
            );
          }
          break;
        case TextOverflow.visible:
          // TODO: Handle this case.
          break;
      }
    } else {
      _overflowShader = null;
    }
  }

  @override
  performLayout() {
    _performLayout();
    if (this._hasVisualOverflow && overflowBuilder != null) {
      final replacement = overflowBuilder(size);
      _textPainter.text = replacement;
      _performLayout();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {

    _layoutTextWithConstraints(constraints);
    final Canvas canvas = context.canvas;

    assert(() {
      if (debugRepaintTextRainbowEnabled) {
        final Paint paint = new Paint()
          ..color = debugCurrentRepaintColor.toColor();
        canvas.drawRect(offset & size, paint);
      }
      return true;
    }());

    if (_hasVisualOverflow) {
      final Rect bounds = offset & size;
      if (_overflowShader != null) {

        canvas.saveLayer(bounds, new Paint());
      } else {
        canvas.save();
      }
      canvas.clipRect(bounds);
    }
    _textPainter.paint(canvas, offset);
    if (_hasVisualOverflow) {
      if (_overflowShader != null) {
        canvas.translate(offset.dx, offset.dy);
        final Paint paint = new Paint()
          ..blendMode = BlendMode.modulate
          ..shader = _overflowShader;
        canvas.drawRect(Offset.zero & size, paint);
      }
      canvas.restore();
    }
  }

  Offset getOffsetForCaret(TextPosition position, Rect caretPrototype) {
    assert(!debugNeedsLayout);
    _layoutTextWithConstraints(constraints);
    return _textPainter.getOffsetForCaret(position, caretPrototype);
  }


  List<ui.TextBox> getBoxesForSelection(TextSelection selection) {
    assert(!debugNeedsLayout);
    _layoutTextWithConstraints(constraints);
    return _textPainter.getBoxesForSelection(selection);
  }

  TextPosition getPositionForOffset(Offset offset) {
    assert(!debugNeedsLayout);
    _layoutTextWithConstraints(constraints);
    return _textPainter.getPositionForOffset(offset);
  }


  TextRange getWordBoundary(TextPosition position) {
    assert(!debugNeedsLayout);
    _layoutTextWithConstraints(constraints);
    return _textPainter.getWordBoundary(position);
  }


  Size get textSize {
    assert(!debugNeedsLayout);
    return _textPainter.size;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..label = text.toPlainText()
      ..textDirection = textDirection;
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return <DiagnosticsNode>[
      text.toDiagnosticsNode(
          name: 'text', style: DiagnosticsTreeStyle.transition)
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(new EnumProperty<TextAlign>('textAlign', textAlign));
    properties
        .add(new EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(new FlagProperty('softWrap',
        value: softWrap,
        ifTrue: 'wrapping at box width',
        ifFalse: 'no wrapping except at line break characters',
        showName: true));
    properties.add(new EnumProperty<TextOverflow>('overflow', overflow));
    properties.add(new DoubleProperty('textScaleFactor', textScaleFactor,
        defaultValue: 1.0));
    properties.add(new IntProperty('maxLines', maxLines, ifNull: 'unlimited'));
  }
}


class MyText extends StatelessWidget {
  const MyText(this.data,
      {Key key,
        this.style,
        this.textAlign,
        this.textDirection,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.overflowBuilder})
      : assert(data != null),
        textSpan = null,
        super(key: key);

  const MyText.rich(this.textSpan,
      {Key key,
        this.style,
        this.textAlign,
        this.textDirection,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.overflowBuilder})
      : assert(textSpan != null),
        data = null,
        super(key: key);

  final String data;
  final TextSpan textSpan;

  final TextStyle style;

  final TextAlign textAlign;


  final TextDirection textDirection;
  final bool softWrap;

  final TextOverflow overflow;

  final double textScaleFactor;

  final TextOverflowBuilder overflowBuilder;

  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = style;
    if (style == null || style.inherit)
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    return new OverflowText(
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection:
      textDirection, // RichText uses Directionality.of to obtain a default if this is null.
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow: overflow ?? defaultTextStyle.overflow,
      overflowBuilder: overflowBuilder,
      textScaleFactor: textScaleFactor ??
          MediaQuery.of(context, nullOk: true)?.textScaleFactor ??
          1.0,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      textSpan: new TextSpan(
        style: effectiveTextStyle,
        text: data,
        children: textSpan != null ? <TextSpan>[textSpan] : null,
      ),
    );
  }

}