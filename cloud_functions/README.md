# Cloud Functions Quickstart

This quickstart aims to show you how to get up and running with firebase cloud functions quickly and easily. This assumes that you want to call cloud functions using the callable trigger rather than the HTTPS trigger. In this directory, you will see a folder called `firebase_functions` which contains the function code to test against.

## Before running the code

You will want to call `flutterfire configure` before running this code so your project is associated with a Firebase project. The [setup info](https://firebase.google.com/docs/flutter/setup) can be found here.

## firebase_functions

In testing firebase_functions, we encourage you to try using the [emulators](https://firebase.google.com/docs/emulator-suite) before deploying to production. We have written a V2 function and a V1 function for comparison. If you are interested in handling multiple requests concurrently and the power of [eventarc](https://cloud.google.com/eventarc/docs) + [cloudrun](https://cloud.google.com/run) function enviornments, we encourage you to look into [V2 functions](https://firebase.google.com/docs/functions/beta).

To start running the functions locally in this folder, change into the `firebase_functions/functions` folder and run `npm run serve`. This will automatically start the emulator suite to test the functions locally.

We have optionally added the code to manage auth state and appcheck state in the functions but have left those commented out. AppCheck will allow you to verify that function requests are coming from authorized applications while auth ensures that users are authorized users of your application.

## Dart code

The dart code invokes the function via:

```dart
FirebaseFunctions.instance
    .httpsCallable(
        'callablevtwo',
    )
    .call();
```

You can optionally supply a [`Map`](https://api.flutter.dev/flutter/dart-core/Map-class.html) object to the call method which will be passed as arguments to the cloud function. In this quickstart, `word` is the parameter that we are passing to the cloud function.