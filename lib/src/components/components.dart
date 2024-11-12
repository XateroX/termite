import 'package:flame/components.dart';
import 'package:termite/src/components/termite.dart';
import 'package:termite/src/game_data_structures/termite.dart';

export 'play_area.dart';

// mapping for each datatype class to their component
Map<Type, ComponentBuilder> classComponents = {
  Termite: (Termite entity) => TermiteComponent.fromTermiteEntity(entity),
};
