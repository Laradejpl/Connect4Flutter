# Client Flutter Puissance 4

Une application mobile de Puissance 4 multijoueur développée avec Flutter et Socket.IO.

## Prérequis

- Flutter (dernière version stable)
- Dart SDK
- Un éditeur de code (VS Code, Android Studio, ou IntelliJ IDEA)
- Le serveur Socket.IO Puissance 4 en cours d'exécution

## Installation

1. Créez un nouveau projet Flutter :
```bash
flutter create puissance4_client
cd puissance4_client
```

2. Remplacez le contenu du fichier `pubspec.yaml` par :
```yaml
name: puissance4_client
description: Jeu de Puissance 4 multijoueur

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  socket_io_client: ^2.0.0
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```

3. Installez les dépendances :
```bash
flutter pub get
```

4. Copiez le code du fichier `main.dart` dans `lib/main.dart`

## Configuration

### Configuration du serveur

Dans le fichier `lib/main.dart`, modifiez l'URL du serveur Socket.IO selon votre configuration :

```dart
socket = IO.io('http://localhost:3000', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false,
});
```

Remplacez `localhost` par l'adresse IP de votre serveur si nécessaire.

## Fonctionnalités

- Interface utilisateur intuitive avec une grille 6x7
- Jetons rouges et jaunes pour distinguer les joueurs
- Indicateur de tour de jeu
- Détection automatique des victoires
- Possibilité de recommencer une partie
- Design moderne avec thème bleu dodger
- Animations fluides
- Support multijoueur en temps réel

## Structure du projet

```
lib/
  ├── main.dart          # Point d'entrée de l'application et logique principale
  └── [futurs fichiers]  # Pour les extensions futures
```

## Utilisation

1. Lancez le serveur Socket.IO
2. Démarrez l'application sur deux appareils/émulateurs :
```bash
flutter run
```
3. Le premier joueur verra "En attente d'un autre joueur..."
4. Une fois le deuxième joueur connecté, la partie commence
5. Les joueurs jouent à tour de rôle en tapant sur une colonne

## Personnalisation

### Couleurs
Les principales couleurs sont définies dans la classe `GameScreenState` :
```dart
final Color dodgerBlue = const Color(0xFF1E90FF);
```

### Styles
Les styles des jetons et de la grille peuvent être modifiés dans la méthode `build()`.

## Débogage

### Logs Socket.IO
Les connexions et événements Socket.IO sont loggés dans la console :
```dart
socket.on('connect', (_) {
  print('Connected to server');
});
```

### Problèmes courants

1. Erreur de connexion au serveur :
   - Vérifiez que le serveur est en cours d'exécution
   - Vérifiez l'URL du serveur
   - Assurez-vous que l'appareil a accès au réseau

2. Interface non responsive :
   - Vérifiez les logs dans la console
   - Vérifiez la connexion Socket.IO
   - Redémarrez l'application

## Tests

Pour exécuter les tests (à implémenter) :
```bash
flutter test
```

## Performance

L'application est optimisée pour :
- Une faible latence réseau
- Une utilisation minimale de la mémoire
- Des animations fluides
- Une réactivité maximale

## Contribution

Pour contribuer :
1. Forkez le dépôt
2. Créez une branche pour votre fonctionnalité
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## Roadmap

Fonctionnalités futures prévues :
- [ ] Mode hors-ligne contre l'IA
- [ ] Statistiques de jeu
- [ ] Animations améliorées
- [ ] Support mode sombre
- [ ] Localisation

## License

MT

## Contact

Larade jp