# PodioKit

PodioKit is the Objective-C client library for the Podio API used in the Podio iOS app. It provides an easy interface for interacting with the Podio API and is responsible for request management and data mapping. If can be used as is or in combination with a storage layer like Core Data.

PodioKit uses ARC and requires a deployment target of >= iOS 5.0.

## Running the Demo app

1. In the `DemoApp-Configuration.plist` file, define your API key's client ID and secret.
2. Run the DemoApp scheme to launch the app.

## Using PodioKit

To add PodioKit to your project, follow these steps:

1. Clone the PodioKit repository from `https://github.com/podio/podio-ios`
2. Drag PodioKit.xcodeproj into the project navigator
3. Go to "Build Phases" for your project. Add the PodioKit target from the PodioKit project to under "Target Dependencies", and add libPodioKit.a under "Link Binary with Libraries"
4. In build settings for the target, set "User Header Search Paths" to point to the location of PodioKit. Also check the recursive box for this path
5. In build settings, also set the "Always Search User Paths" flag to YES
6. In build settings, under "Other Linker Flags" add `-ObjC` and `-all_load`. This will make sure categories in PodioKit are properly loaded
7. In your `<AppName>-Prefix.pch` file, add the following line:

		#import <PodioKit/PodioKit.h>

8. Add the following frameworks to your project:

		libz.dylib
		CGNetwork.framework
		SystemConfiguration.framework
		MobileCoreServices.framework

## Dependencies

PodioKit uses the following open source libraries:

* [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for general networking. We are aware that this library has been deprecated and we investigating alternatives.
* [JSONKit](https://github.com/johnezang/JSONKit) for parsing JSON data.
* [Reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html) for monitoring network availability.

These libraries can be found in the _Vendor_ subfolder.