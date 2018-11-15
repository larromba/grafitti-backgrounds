# Grafitti Backgrounds

## About
This is a macOS app developed on and off since 02/12/2017 that downloads (and re-downloads every so many hours) a random number of grafitti / street-art backgrounds to your computer. You then use this folder as your desktop backgrounds, and specify in the Settings to change every 5 minutes. This creates a continuously changing computer background of grafitti images from all around the world.

## Installation from Source

### Dependencies
**SwiftGen**
`brew install swiftgen`

**SwiftLint**
`brew install swiftlint`

**Sourcery** *(testing only)*
`brew install sourcery`

### Instructions
This assumes you're farmiliar with Xcode and building macOS apps.

*Please note that you might need to change your app's bundle identifier and certificates to match your own.*

1. open `GrafittiBackgrounds.xcodeproj`
2. click the top menu `Project -> Archive`
3. after archiving, select `Distribute App`. 
4. Select `Developer ID`
5. Select `Export`
6. Select `Automatically manage signing`
7. Select `Export` and choose a file location
8. Once exported, copy `GrafittiBackgrounds.app` to your `Applications` folder
9. Run the app
10. When it finishes downloading photos, open `System Preferences`, and set your background to the folder `~/Pictures/GrafittiBackgrounds`. Set it to change every 5 minutes for maximum effect.

I'd also recommend adding the app to your startup items. Enjoy!

## How it works
The app has access to a number of Google Photos albums that's I've been collecting over the years, containing street-art from a number of places arund the world. The app scrapes the albums from Google Photos, and regexes the information into a usable format. It then downloads a random number of photos to `~/Pictures/GrafittiBackgrounds`. It's a bit hacky but it works.

## Contact
larromba@gmail.com