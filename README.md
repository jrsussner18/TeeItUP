# Tee It Up

Tee It Up is a SwiftUI-based iOS application that allows users to easily find and explore golf courses near their current location. It uses location data, Google Places API, and two golf data APIs to fetch course information, display relevant images, calculate distances, and let users favorite their top picks.

This app was built as a **portfolio project** to showcase practical use of:
- API integration
- Custom SwiftUI components
- Real-time location handling
- Modern iOS app architecture

---

## App Features

- Search and filter nearby golf courses by name or distance
- View course images and basic details (par, holes, distance)
- Favorite a course by long-pressing the star icon
- Distance calculated dynamically based on your location
- “About” page with background on the project

---

## Screenshots


| About View            | Course View      | Account View |
|---------------------|--------------------------|------------------|
| ![](screenshots/about.png) | ![](screenshots/course.png) | ![](screenshots/account.png) |

---

## Technologies Used

- **SwiftUI**
- **Google Places SDK**
- **CoreLocation**
- **Firebase Authentication**
- **.xcconfig Configuration Management**
- **Async/Await Networking**

---

## API Setup Instructions

To run the app, you’ll need API keys for the following services:

### 1. **Google Places API**

1. Go to [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select a project.
3. Enable the **Places API**.
4. Go to **APIs & Services > Credentials**, and create an API Key.
5. Restrict the API Key for iOS if desired.
6. Add your key to a config file (see below).

### 2. **Golf Course Finder (RapidAPI)**

1. Sign up at [RapidAPI](https://rapidapi.com/golfambit-golfambit-default/api/golf-course-finder/).
2. Subscribe to the API (free tier available).
3. Copy your X-RapidAPI-Key and Host.
4. Add these values to your config file.

### 3. **Golf Course API (golfcourseapi.com)**

1. Sign up at [Golf Course API](https://api.golfcourseapi.com/docs/api/#operation/getCoursesBySearch).
2. Generate your token or key.
3. Include the token in your config file for authenticated requests.

---

## Managing API Keys (Important)

API keys should never be pushed to GitHub!

### Using `.xcconfig`

1. Create a file named `Secrets.xcconfig` in your project (do not commit it).
2. Add it to your `.gitignore` file:

    ```
    Secrets.xcconfig
    ```

3. In `Secrets.xcconfig`, define your keys:

    ```xcconfig
    GOOGLE_API_KEY = your-google-api-key
    RAPID_API_KEY = your-rapidapi-key
    GOLF_API_KEY = your-golfcourseapi-key
    ```

4. Reference these in your `Info.plist` or code as needed:

    ```xml
    <key>GOOGLE_API_KEY</key>
    <string>$(GOOGLE_API_KEY)</string>
    ```

5. Provide a `Secrets.sample.xcconfig` in your repo with placeholder values so others can replicate your setup.

---

## 🧪 Local Setup

1. Clone this repo
2. Run:

    ```bash
    cp Secrets.sample.xcconfig Secrets.xcconfig
    ```

3. Add your API keys to `Secrets.xcconfig`
4. Build and run in Xcode 15+
5. Ensure Firebase project and Auth method is enabled if testing auth

---

## API Credits

This app wouldn't be possible without the following APIs:

- [Google Places API](https://developers.google.com/maps/documentation/places/web-service)
- [RapidAPI Golf Course Finder](https://rapidapi.com/golfambit-golfambit-default/api/golf-course-finder/)
- [GolfCourseAPI.com](https://api.golfcourseapi.com/docs/api/)

---

## License

This project is for educational and portfolio purposes only. API keys are not included and should be registered individually by developers following the above steps.

---

## About the Creator

**Jake Sussner**  
Computer Science major, Mathematics minor — University of Tampa  
This is a passion project combining my love of golf and iOS development. I hope you enjoy it!

