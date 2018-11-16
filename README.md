# Graffiti Backgrounds

## About
This is a macOS app developed on and off since 02/12/2017 that downloads (and re-downloads every so many hours) a random number of graffiti / street-art backgrounds to your computer. You then use this folder as your desktop backgrounds, and specify in the Settings to change every 5 minutes. This creates a continuously changing computer background of graffiti images from all around the world.

## Installation from Source

### Dependencies
**SwiftGen**

`brew install swiftgen`

**SwiftLint**

`brew install swiftlint`

**Sourcery** *(testing only)*

`brew install sourcery`

### Build Instructions
This assumes you're farmiliar with Xcode and building macOS apps.

*Please note that you might need to change your app's bundle identifier and certificates to match your own.*

1. open `GraffitiBackgrounds.xcodeproj`
2. click the top menu `Project -> Archive`
3. after archiving, select `Distribute App`. 
4. Select `Developer ID`
5. Select `Export`
6. Select `Automatically manage signing`
7. Select `Export` and choose a file location
8. Once exported, copy `GraffitiBackgrounds.app` to your `Applications` folder

### Setting Up
1. Run the app
2. When it finishes downloading photos, open `System Preferences`, and set your desktop background to the folder `~/Pictures/GraffitiBackgrounds`. Set your background to change every 5 minutes for maximum effect
3. Add the app to your startup items

Enjoy!

## How it works
This app has access to a number of Google Photos albums containing street-art from around the world. It scrapes the albums from Google Photos, and regexes the information into a usable format. It then downloads a random number of photos to `~/Pictures/GraffitiBackgrounds`. It's a bit hacky but it works.

## Contact
larromba@gmail.com
