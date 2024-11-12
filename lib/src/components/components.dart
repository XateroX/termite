import 'package:flame/components.dart';
import 'package:termite/src/components/queen.dart';
import 'package:termite/src/components/termite.dart';
import 'package:termite/src/game_data_structures/queen.dart';
import 'package:termite/src/game_data_structures/termite.dart';

export 'play_area.dart';

class EntityComponentMappings{
  static TermiteComponent getTermiteComponent(Termite termite){
    return TermiteComponent.fromTermiteEntity(termite);
  }
  static QueenComponent getQueenComponent(Queen queen){
    return QueenComponent.fromTermiteEntity(queen);
  }
}
