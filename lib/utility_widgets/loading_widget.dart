import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingState with ChangeNotifier {

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void loading() {
    _isLoading = true;
    notifyListeners();
  }

  void clear() {
    _isLoading = false;
    notifyListeners();
  }
}

class Loading extends StatelessWidget {
  final Widget? child;

  const Loading({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoadingState>().isLoading) {
      return const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(
              size: 60,
              itemCount: 5,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "loading",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
    return child ?? const SizedBox();
  }
}
