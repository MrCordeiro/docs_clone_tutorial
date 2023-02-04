# docs_clone_tutorial

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

- Google Authentication
- State Persistence
- Creating new Documents
- Viewing List of Documents
- Updating title of Document
- Link sharing
- Auto saving
- Collaborative Editing in Rich Text Editor
- Sign Out

### Google Authentication

To create a Google Authentication, you need to create a new project in the [Google Developer Console](https://console.developers.google.com/). Then, you need to create a new OAuth Consent Screen and add the following scopes:

- `./auth/userinfo.email`
- `./auth/userinfo.profile`

Then, you need to create a new OAuth Client ID. You will create 3 OAuth Client IDs: Web, Android and iOS. To complete the integration, follow the instructions in the [Google Sign In Flutter Plugin](https://pub.dev/packages/google_sign_in).
