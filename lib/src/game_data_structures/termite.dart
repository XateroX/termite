import 'dart:math';

import 'package:flame/game.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/utils/calculations.dart';

class Termite extends Entity {
  late String name;
  final Random random = Random();

  Termite(super.currentHex) {
    // list of random philosophical names
    final names = [
      'Aristotle',
      'Plato',
      'Socrates',
      'Descartes',
      'Kant',
      'Hume',
      'Locke',
      'Nietzsche',
      'Spinoza',
      'Leibniz',
      'Hegel',
      'Marx',
      'Wittgenstein',
      'Kierkegaard',
      'Heidegger',
      'Sartre',
      'Camus',
      'Foucault',
      'Derrida',
      'Deleuze',
      'Baudrillard',
      'Zizek',
      'Chomsky',
      'Feyerabend',
      'Popper',
      'Quine',
      'Russell',
      'Wittgenstein',
      'Frege',
      'Cantor',
      'Godel',
      'Turing',
      'Church',
      'Carnap',
      'Kripke',
      'Putnam',
      'Rawls',
      'Rorty',
      'Dewey',
      'James',
      'Peirce',
      'Whitehead',
      'Bergson',
      'Rousseau',
      'Hobbes',
      'Spinoza',
      'Kierkegaard',
      'Heidegger',
      'Sartre',
      'Camus',
      'Foucault',
      'Derrida',
      'Deleuze',
      'Baudrillard',
      'Zizek',
      'Chomsky',
      'Feyerabend',
      'Popper',
      'Quine',
      'Russell',
      'Wittgenstein',
      'Frege',
      'Cantor',
      'Godel',
      'Turing',
      'Church',
      'Carnap',
      'Kripke',
      'Putnam',
      'Rawls',
      'Rorty',
      'Dewey',
      'James',
      'Peirce',
      'Whitehead',
      'Bergson',
      'Rousseau',
      'Hobbes',
      'Spinoza',
      'Kierkegaard',
      'Heidegger',
      'Sartre',
      'Camus',
      'Foucault',
      'Derrida',
      'Deleuze',
    ];

    // generate a random name by selecting a random 3 from the list and joining them
    name = names[random.nextInt(names.length)] +
        names[random.nextInt(names.length)] +
        names[random.nextInt(names.length)];
  }

  @override
  String toString() {
    return 'Termite{name: $name}';
  }
}
