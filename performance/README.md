Firebase Performance Quickstart
==============================

The Firebase Performance Flutter Quickstart app demonstrates measuring the performance of
activities in your application. It does this through a custom trace that is deployed with
a call to `var trace = FirebasePerformance.instance.newTrace('myTag');`. The custom trace
is then recorded by awaiting the start and the stop of the trace. Once this information
has been recorded by performance monitoring, you can check the status of the trace by
visiting the [Firebase console ](https://console.firebase.google.com/project/_/performance/)
and looking under custom traces for your trace.

Introduction
------------

- [Read more about Firebase Performance](https://firebase.google.com/docs/perf-mon/)

Getting Started
---------------

- [Add Firebase to your Flutter Project](https://firebase.google.com/docs/perf-mon/flutter/get-started).
- Run the sample on a simulator, emulator, or real device.
- Click the `Get Random String` button.
- A random string should appear on the screen below the buttons text.
- The generation of the random string has a custom trace placed upon it. We can then go to the
[Firebase console ](https://console.firebase.google.com/project/_/performance/) and find under the
custom traces tab a trace for `updateRandomString`.
- You can modify the `updateRandomString` method in the main.dart file to see and add complexity to the
function to see how it changes over time.

Support
-------

- [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase-performance)
- [Firebase Support](https://firebase.google.com/support/).

License
-------

Copyright 2022 Google, Inc.

Licensed to the Apache Software Foundation (ASF) under one or more contributor
license agreements.  See the NOTICE file distributed with this work for
additional information regarding copyright ownership.  The ASF licenses this
file to you under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy of
the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.