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
            final demoToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjJmMTVhZTY0LTM3MjUtNDFmZS05Zjg4LWRhYzY5MjdjMjliYSIsIm1lZXRpbmdJZCI6ImJiYjU4NzljLTU1MjItNDFlNC1hYjU5LTUzN2QwODEzOGE3MSIsInBhcnRpY2lwYW50SWQiOiJhYWFiOTJhMy1mYTZhLTRhZTYtOTE2NS01ZWY2Yjk5ZjBlYzgiLCJwcmVzZXRJZCI6IjM3N2QxYmI4LTIwZDQtNGFkOC04YzRlLWFkNjQyOTU2NjRlMiIsImlhdCI6MTc4Mjg0MTc0MSwiZXhwIjoxNzkxNDgxNzQxfQ.ZCPKL4kGO3tB1CWSWmqwWKnu-C_1aApzCvi1ur8SRSygRwbNOgR_cxxtJ9z3ubD7Bva35EtegpFGEtk1ABlDBMvqwpxb14EBrDW1XjdqrhPDDqJaQ4haE9weJ8WEj0Uh8xr5WkrmgrfmGgnyO_r2EmTMh1WkaFzhZcBkgVdBu-VyBwMupqUJl7Q-VTZu96Omf4wGY8OqowcAGnqpbKvwxjFoNLF07T8A9H-Axr2vQwWBZqZ9ue0ZcjzAqQedQ8tqgXmiLWke_v_OK7BriaMTCkwIXTVvW0m2N-o7xXsWk9Z6tZN1dShcuM6sFv_TZfIGNYS_Zh1-i3mmT-9el-iNpw';
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
