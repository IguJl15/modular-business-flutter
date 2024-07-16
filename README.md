# Modules visualization app

> 🚧 This is a Work In Progress App 🚧

This app is a demonstration of how to work with business modules in a Flutter application.

Many companies have a lot of modules, and each module has a different set of features annd functionalities. In this app, I thought it would be interesting to learn how to handle this kind of scenario.

## The Scenario

Imagine you have a company which offers a service, a software as a service (SaaS). Your product is separated into different modules, each one with its own set of features and functionalities (e.g. module 1: CRM, module 2: Sales, module 3: Marketing, etc.).

To offer a more personalized customer experience, you allow them to choose which module they want to purchase and perhaps even give them a personalized discount for each one.

## 🚀 How to run the app

> Make sure you [installed](https://docs.flutter.dev/get-started/install) Flutter and Dart in your machine

1. Clone or fork the repository

```shell
git clone https://github.com/IguJl15/modular-business-flutter.git
```

2. Install the packages required

```shell
flutter pub get
```

3. Run the build command ([`build_runner`](https://pub.dev/packages/build_runner))

```shell
flutter packages pub run build_runner build  
```

4. Update [`.vscode/launch.json`](.vscode/launch.json) `args` with your Supabase project URL (`SUPABASE_URL`) and Key (`SUPABASE_ANON_KEY`):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": [
        "--dart-define=SUPABASE_URL=Url",
        "--dart-define=SUPABASE_ANON_KEY=Key"
      ]
    }
  ]
}
```

**5. Run the app 🚀**

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue to discuss any ideas you have.
