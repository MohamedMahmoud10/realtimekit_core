import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/widgets/rtk_text_field.dart';
import 'package:example/network/rtk_meeting_notifier.dart';

class AuthTokenWidget extends ConsumerWidget {
  const AuthTokenWidget({super.key, required this.authTokenController});

  final TextEditingController authTokenController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtkMeetingNotifier = ref.watch(rtkMeetingProvider.notifier);
    return Column(
      children: [
        RtkTextField(controller: authTokenController, hintText: 'Auth Token'),
        ElevatedButton(
          key: const Key('join-meeting-button'),
          onPressed: () {
            final authToken = authTokenController.text.trim();
            if (authToken.isEmpty) return;
            rtkMeetingNotifier.initWithAuthToken(authToken);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFF17F1F)),
          ),
          child: const Text(
            'Join Meeting',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final demoToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjJmMTVhZTY0LTM3MjUtNDFmZS05Zjg4LWRhYzY5MjdjMjliYSIsIm1lZXRpbmdJZCI6ImJiYjljN2QyLTM3MTAtNDgxOC1iMDZhLTU4ODhhNTNlNjNhOSIsInBhcnRpY2lwYW50SWQiOiJhYWExY2FmZC1iMTVjLTQyOTctOTQ3OC00MzlmNzQyMmNjYzMiLCJwcmVzZXRJZCI6ImRiZWFiMTZiLWMyMDUtNDllMy04ZDI5LWY3NzAxYTg5ZTZkMCIsImlhdCI6MTc1ODkwMTQ4NiwiZXhwIjoxNzY3NTQxNDg2fQ.c2B_GKU1sngr9L2fYbXGLSMNtzisSXyD9JawUr1waYNRuR2E7lI5P4wGOE7-FqmfSB2GJtLdxucKwHCSzq4NIdoIjLILi_pskXBFM1oBLQMgtj-DEgUp0HJ7WNlzn0KWJnViDElHevOKKF6wtOJeHbo-Hqb5YONAH70v7BAqrevPibeWeWQQW9Iy-pw4VAHR44RbeNVf-iwi_1QAZUzs84xbfoV-JHQAwm52R0XWGIvdw_T6fhs7ZCwgPaQEPaYXMtpBZlJxQWaRUhEKxPSZ9B7AhFKQSLeOARuXe9K2CTLwhSndx7wKGxOkm8339V0RvExPQ5LsCrPlx2SLLNQ__w';
            if (demoToken.isEmpty) return;
            rtkMeetingNotifier.initWithAuthToken(demoToken);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFF17F1F)),
          ),
          child: const Text(
            'Join with Hardcoded Token',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
