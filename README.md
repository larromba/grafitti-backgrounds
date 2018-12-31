# Graffiti Backgrounds [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![Open Source Love png1](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

| master  | dev |
| ------------- | ------------- |
| [![Build Status](https://travis-ci.com/larromba/graffiti-backgrounds.svg?branch=master)](https://travis-ci.com/larromba/graffiti-backgrounds) | [![Build Status](https://travis-ci.com/larromba/graffiti-backgrounds.svg?branch=dev)](https://travis-ci.com/larromba/graffiti-backgrounds) |

## About
A macOS app that downloads (and re-downloads every so many hours) a random number of graffiti / street-art backgrounds to a folder on your computer. You then use this folder as your desktop backgrounds, and specify in your System Preferences to change every 5 minutes. This creates a continuously changing computer background of graffiti images from all around the world.

## Installation from Source

### Dependencies
**SwiftGen**

`brew install swiftgen`

**SwiftLint**

`brew install swiftlint`

**Sourcery** *(testing only)*

`brew install sourcery`

**Carthage**

`brew install carthage`

### Build Instructions
This assumes you're farmiliar with Xcode and building macOS apps.

*Please note that you might need to change your app's bundle identifier and certificates to match your own.*

1. `carthage update`
2. open `GraffitiBackgrounds.xcodeproj`
3. click the top menu `Project -> Archive`
4. after archiving, select `Distribute App`. 
5. Select `Developer ID`
6. Select `Export`
7. Select `Automatically manage signing`
8. Select `Export` and choose a file location
9. Once exported, copy `GraffitiBackgrounds.app` to your `Applications` folder

### Setting Up
1. Run the app
2. When it finishes downloading photos, open `System Preferences`, and set your desktop background to the folder `~/Pictures/GraffitiBackgrounds`. Set your background to change every 5 minutes for maximum effect
3. Add the app to your startup items

Enjoy!

## How it works
This app has access to a number of Google Photos albums containing street-art from around the world. It scrapes the albums from Google Photos, and regexes the information into a usable format. It then downloads a random number of photos to `~/Pictures/GraffitiBackgrounds`. It's a bit hacky but it works.

## Licence
[![licensebuttons by-nc-sa](https://licensebuttons.net/l/by-nc-sa/3.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0) 

## Contact
larromba@gmail.com
