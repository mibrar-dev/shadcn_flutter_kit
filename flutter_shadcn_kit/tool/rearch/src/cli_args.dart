// Minimal dependency-free CLI argument parser for the rearch tooling.
//
// Kept local (instead of package:args) so the scripts stay runnable with a
// clean checkout and do not rely on transitive dependencies.

/// Parsed command line arguments.
class CliArgs {
  CliArgs._(this._options, this.positionals, this.errors);

  /// Raw option values by flag name (without the leading dashes).
  final Map<String, List<String>> _options;

  /// Non-flag arguments, in order.
  final List<String> positionals;

  /// Parse problems such as a value option without a value.
  final List<String> errors;

  /// Parses [args].
  ///
  /// Options listed in [valueOptions] consume one following token as their
  /// value; options in [twoValueOptions] consume two. Everything else is a
  /// boolean flag. `--name=value` always assigns a value.
  factory CliArgs.parse(
    List<String> args, {
    Set<String> valueOptions = const <String>{},
    Set<String> twoValueOptions = const <String>{},
  }) {
    final options = <String, List<String>>{};
    final positionals = <String>[];
    final errors = <String>[];
    var index = 0;
    var onlyPositionals = false;
    while (index < args.length) {
      final arg = args[index];
      if (onlyPositionals || !arg.startsWith('--')) {
        positionals.add(arg);
        index += 1;
        continue;
      }
      if (arg == '--') {
        onlyPositionals = true;
        index += 1;
        continue;
      }
      var name = arg.substring(2);
      String? inlineValue;
      final equals = name.indexOf('=');
      if (equals >= 0) {
        inlineValue = name.substring(equals + 1);
        name = name.substring(0, equals);
      }
      if (twoValueOptions.contains(name)) {
        final values = <String>[];
        if (inlineValue != null) {
          values.add(inlineValue);
        }
        while (values.length < 2 &&
            index + 1 < args.length &&
            !args[index + 1].startsWith('--')) {
          values.add(args[index + 1]);
          index += 1;
        }
        if (values.length < 2) {
          errors.add('Option --$name requires two values');
        } else {
          options[name] = values;
        }
        index += 1;
        continue;
      }
      if (valueOptions.contains(name)) {
        var value = inlineValue;
        if (value == null &&
            index + 1 < args.length &&
            !args[index + 1].startsWith('--')) {
          value = args[index + 1];
          index += 1;
        }
        if (value == null) {
          errors.add('Option --$name requires a value');
        } else {
          (options[name] ??= <String>[]).add(value);
        }
        index += 1;
        continue;
      }
      options.putIfAbsent(name, () => <String>[]);
      if (inlineValue != null) {
        options[name]!.add(inlineValue);
      }
      index += 1;
    }
    return CliArgs._(options, positionals, errors);
  }

  /// Whether [name] appeared on the command line.
  bool flag(String name) => _options.containsKey(name);

  /// The last value passed for [name], or null.
  String? value(String name) {
    final values = _options[name];
    if (values == null || values.isEmpty) {
      return null;
    }
    return values.last;
  }

  /// All values passed for [name], in order.
  List<String> values(String name) => _options[name] ?? const <String>[];

  /// The positional argument at [index], or null.
  String? positional(int index) =>
      index >= 0 && index < positionals.length ? positionals[index] : null;
}
