import 'package:flame/components.dart';
import 'package:termite/src/game_data_structures/termite.dart';

class TermiteComponent extends PositionComponent {
  Termite termite; 
  TermiteComponent(this.termite) {
    // this is the constructor
  }

  TermiteComponent fromTermiteEntity(Termite entity){
    return TermiteComponent()
  }
}
