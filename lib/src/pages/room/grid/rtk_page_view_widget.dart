import 'package:realtimekit_ui/src/pages/room/grid/rtk_tab_viewer_widget.dart';
import 'package:realtimekit_ui/src/widgets/molecules/page_indicator.dart';
import 'package:flutter/material.dart';

import 'active_particpants_widget.dart';

class RtkPageViewWidget extends StatefulWidget {
  const RtkPageViewWidget({super.key});

  @override
  State<RtkPageViewWidget> createState() => _RtkPageViewWidgetState();
}

class _RtkPageViewWidgetState extends State<RtkPageViewWidget> {
  final pageController = PageController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          children: const [
            RtkTabViewerWidget(),
            ActiveParticipantsWidget(),
          ],
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: PageIndicator(
              currentPage: _currentPage,
              pageCount: 2,
            ),
          ),
        )
      ],
    );
  }
}
