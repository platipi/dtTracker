import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
  const CustomButton({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.33,
              child: const Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Text(
                  'Unit',
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Text(name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
