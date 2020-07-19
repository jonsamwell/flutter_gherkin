# language: fr
Fonctionnalité: Counter
  The counter should be incremented when the button is pressed.

  Scénario: Counter increases when the button is pressed
    Etant donné que I pick the colour red
    Et I expect the "counter" to be "0"
    Quand I tap the "increment" button 10 times
    Alors I expect the "counter" to be "10"