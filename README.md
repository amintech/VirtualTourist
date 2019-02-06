# VirtualTourist
Udacity Nano Degree graduation Project

## About Project 

This app allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data.

The app will have two view controller scenes.

__Travel Locations Map View:__ Allows the user to drop pins around the world, when the app first starts it will open to the map view, users will be able to zoom and scroll around the map using standard pinch and drag gestures, tapping and holding the map drops a new pin. Users can place any number of pins on the map, when a pin is tapped, the app will navigate to the Photo Album view associated with the pin.

![screen shot 1440-06-01 at 11 03 30 pm](https://user-images.githubusercontent.com/11136648/52370912-3887d400-2a65-11e9-889e-39c76c428382.png)

__Photo Album View:__ Allows the users to download and edit an album for a location, if you tap a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin, once the images have all been downloaded, the app enable the New Collection button at the bottom of the page, tapping this button will empty the photo album and fetch a new set of images, note that in locations that have a fairly static set of Flickr images, “new” images might overlap with previous collections of images, user able to remove photos from an album by tapping them, pictures will flow up to fill the space vacated by the removed photo.

![screen shot 1440-06-01 at 11 04 54 pm](https://user-images.githubusercontent.com/11136648/52371052-8c92b880-2a65-11e9-9cde-e82c79da6233.png)

## Requirements to build and run your app

1 - ios 10 and above
2 - Xcode 10.1
3 - Swift 4.2

## How to run the project?

1 - Open file *VirtualTourist.xcodeproj*
2 - Press `cmd` & `R` or from __Product__ Menu hit __Run__


## license

__MIT__

Free Software, Yeah!

created By *Amin Saleh

