import 'dart:async';

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final double aspectRatio;
  final num viewportFraction;
  final num initialPage;
  final num realPage;
  final bool enableInfiniteScroll;
  final bool reverse;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Curve autoPlayCurve;
  final bool enlargeCenterPage;
  final Axis scrollDirection;
  final PageController pageController;

  Carousel({
    Key key,
    @required this.items,
    this.height,
    this.aspectRatio: 16 / 9,
    this.viewportFraction: 0.8,
    this.initialPage: 0,
    int realPage: 1000,
    this.enableInfiniteScroll: true,
    this.reverse = false,
    this.autoPlay: false,
    this.autoPlayInterval: const Duration(seconds: 4),
    this.autoPlayAnimationDuration: const Duration(milliseconds: 800),
    this.autoPlayCurve: Curves.fastOutSlowIn,
    this.enlargeCenterPage = false,
    this.scrollDirection: Axis.horizontal,
  })  : this.realPage =
            enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.pageController = PageController(
            viewportFraction: viewportFraction,
            initialPage:
                enableInfiniteScroll ? realPage + initialPage : initialPage),
        super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with TickerProviderStateMixin {
  Timer timer;

  @override
  void initState() {
    super.initState();
    getTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Timer getTimer() {
    return Timer.periodic(widget.autoPlayInterval, (_) {
      if (widget.autoPlay) {
        widget.pageController.nextPage(
            duration: widget.autoPlayAnimationDuration,
            curve: widget.autoPlayCurve);
      }
    });
  }

  Widget getWrapper(Widget child) {
    if (widget.height != null) {
      return Container(
        height: widget.height,
        child: child,
      );
    } else {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getWrapper(PageView.builder(
      scrollDirection: widget.scrollDirection,
      controller: widget.pageController,
      reverse: widget.reverse,
      itemCount: widget.enableInfiniteScroll ? null : widget.items.length,
      onPageChanged: (int index) {
      },
      itemBuilder: (BuildContext context, int i) {
        final int index = _getRealIndex(i + widget.initialPage, widget.realPage, widget.items.length);

        return AnimatedBuilder(
          animation: widget.pageController,
          child: widget.items[index],
          builder: (BuildContext context, child) {
            if(widget.pageController.position.minScrollExtent == null || widget.pageController.position.maxScrollExtent == null){
              Future.delayed(Duration(microseconds: 1),() {
                setState(() {
                  
                });
              });

              return Container();
            }

            double value = widget.pageController.page - i;
            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

            print('value: $value');

            final double height = widget.height ?? MediaQuery.of(context).size.width * (1 / widget.aspectRatio);

            final double distortionValue =
                widget.enlargeCenterPage ? Curves.easeOut.transform(value) : 1.0;
            print('distortionValue: $distortionValue');

            if(widget.scrollDirection == Axis.horizontal) {
              return Center(child: SizedBox(height: distortionValue * height, child: child,),);
            }
            else {
              return Center(child: SizedBox(width: distortionValue * MediaQuery.of(context).size.width, child: child,),);
            }
          },
        );
      },
    ));
  }

  int _getRealIndex(int position, int base, int length) {
    final int offset = position - base;
    return _remainder(offset, length);
  }

  int _remainder(int input, int source) {
    final int result = input % source;
    return result < 0 ? source + result : result;
  }
}


