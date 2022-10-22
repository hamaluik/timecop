I'm happy to take bug reports and pull requests if you want to help improve _Time Cop_, but I fundamentally want to keep this app relatively small and simple. If that's not for you, there's [plenty](https://toggl.com/) of [other](https://clockify.me/) [options](https://www.workpuls.com/) [out](https://www.manictime.com/) [there](https://trackabi.com/).

The app is created pretty much entirely in [Dart](https://dart.dev/) using [Flutter](https://flutter.dev/), and I tried to make heavy use of the [Bloc](https://bloclibrary.dev/#/) pattern.

Here are a few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view its [online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

After [installing and setting up Flutter](https://docs.flutter.dev/get-started/install) (ideally its latest version) and downloading the Time Cop code, you can simply [build and run](https://docs.flutter.dev/get-started/test-drive#run-the-app) this Flutter project.

When building for Linux, you will need to install `libsqlite3` development packages first. On Debian-based distros, you can do so with this command:

```sudo apt-get -y install libsqlite3-0 libsqlite3-dev```
