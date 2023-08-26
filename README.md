
This is a sample iOS app that displays information about the English Premier League. The app includes a Fixtures List screen that retrieves match data from a JSON endpoint and displays it in a sectioned list. The app is built using UIKit and Swift, and the network requests are handled using either Moya or Alamofire.

Features
The app includes the following features:

Fixtures List:

Displays a list of matches retrieved from a JSON endpoint.
Each item in the list shows the teams' names and either the game result or the time of the game in hh:mm format (if it hasn't been played yet).
The list is sectioned by day.
The first visible section of the list is the current day, or the next day if the current day has no fixtures.

Control Toggle:

Provides a toggle control to switch between different views of the fixtures list:
Show the entire list.
Mark a fixture as "favorite".
Show a subset of the list containing only the favorite fixtures.
The list of favorite fixtures persists across app launches.
Prerequisites
Before you start working on the app, you need to complete the following steps:

Generate an API key:

Obtain an API key from the provider of the JSON endpoint.
Follow the documentation provided by the provider for more information on generating the API key.
Install dependencies:

Make sure you have CocoaPods installed on your machine.

Open a terminal, navigate to the project directory, and run the following command to install the dependencies:

Copy
pod install
Technical Stack
The app is built using the following technical stack:

UIKit: The primary framework for building the user interface and handling user interactions on iOS.
Swift: The programming language used for iOS app development.
Moya or Alamofire: Networking libraries for handling API requests and responses. Choose either Moya or Alamofire based on your preference and familiarity.
Getting Started
To get started with the app, follow these steps:

Clone the repository:

Copy
git clone <repository-url>
```

Open the project in Xcode:

Copy
cd <project-directory>
open LeagueApp.xcworkspace
Add your API key:

Locate the file where the API key is required (e.g., NetworkManager.swift).
Replace the placeholder value with your actual API key.
Build and run the app:

Select a simulator or a connected device from the scheme selection dropdown in Xcode.
Press the "Play" button or use the Command + R shortcut to build and run the app.
Notes
Make sure you have a stable internet connection to retrieve the match data from the JSON endpoint.
The app uses sectioned lists to display matches by day. Ensure that the JSON response provides the necessary data for sectioning the list correctly.
The app stores the list of favorite fixtures locally on the device. Consider implementing data persistence using Core Data, Realm, or other storage frameworks if required.

Acknowledgements
The English Premier League for providing the match data and API endpoint.
The creators and contributors of UIKit, Swift and Alamofire for their excellent frameworks and libraries.
