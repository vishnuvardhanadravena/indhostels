import 'dart:async';

enum CircuitState {
  closed,
  open,
  halfOpen
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration resetTimeout;

  int _failureCount = 0;
  CircuitState _state = CircuitState.closed;
  DateTime? _lastFailureTime;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(seconds: 30),
  });

  bool get canExecute {
    if (_state == CircuitState.closed) return true;

    if (_state == CircuitState.open) {
      if (DateTime.now().difference(_lastFailureTime!) > resetTimeout) {
        _state = CircuitState.halfOpen;
        return true;
      }
      return false;
    }

    return true;
  }

  void onSuccess() {
    _failureCount = 0;
    _state = CircuitState.closed;
  }

  void onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_failureCount >= failureThreshold) {
      _state = CircuitState.open;
    }
  }
}
class Debouncer {
  final Duration delay;
  Timer ? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<T>();

    _timer?.cancel();

    _timer = Timer(delay, () async {
      try {
        final result = await action();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }
}