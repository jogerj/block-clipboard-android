# Block Read Clipboard Permission in Android
Block clipboard permission to certain apps via ADB in Termux. Requires Android 11 or above.

## Background
Recently it has been found that [apps on Android and iOS are known to access your clipboard (history) covertly](https://www.howtogeek.com/680147/psa-all-apps-can-read-your-iphone-and-android-clipboard/). [Apps like TikTok](https://arstechnica.com/gadgets/2020/06/tiktok-and-53-other-ios-apps-still-snoop-your-sensitive-clipboard-data/) uses these clipboard information to "improve user experience". The implications are **these apps could retrieve private information that you stored in your clipboard or even passwords and then send them to a remote server**. Since iOS 14 and Android 12, your smartphone would alert you when an app accesses your clipboard, however in Android there's no direct way to block access to these applications from reading your clipboard contents.

### How clipboard on Android works
> Unless your app is the default input method editor (IME) or is the app that currently has focus, your app cannot access clipboard data on Android 10 or higher. [Source](https://developer.android.com/about/versions/10/privacy/changes#clipboard-data)

This means that apps no longer can access your clipboard data when running in the background. In Android 12, [a toast message will alert the user](https://developer.android.com/about/versions/12/behavior-changes-all#clipboard-access-notifications) when an app tries to access clipboard data from a different app. However, apps **can still access your clipboard data when you open the app in foreground**.

### What this script does
This script accesses your Android phone via adb (without requiring a computer/USB connection) and removes the `READ_CLIPBOARD` permission from any app you choose. Removing this permission disables pasting text in any text fields within the app. However, you can still paste text from your keyboard if your keyboard supports it (e.g. [Gboard](https://www.ubergizmo.com/how-to/manage-clipboard-android/), [SwiftKey](https://support.swiftkey.com/hc/en-us/articles/212813085-How-does-the-Clipboard-work-with-Microsoft-SwiftKey-Keyboard-for-Android-), etc.), which arguably would be more secure than unwanted/untrusted apps accessing your clipboard. Disabling clipboard permission will not interefere with [Auto-fill](https://developer.android.com/guide/topics/text/autofill) functions used by password managers as they use different API, but you won't be able to manually paste passwords using clipboard (except from keyboard). The entire process is completely reversible, see `enable_clipboard.sh`.

## Requirements
- Android device running Android 11 or above (for wireless ADB)
- Latest version of [Termux](https://f-droid.org/en/packages/com.termux/)

## How to
1. Open Termux and clone this repository (requires git installed, `pkg install git`)
   ```sh
   git clone https://github.com/jogerj/block-clipboard-android
   cd block-clipboard-android
   ```
   or download individual scripts files using curl
   ```sh
   curl https://raw.githubusercontent.com/jogerj/block-clipboard-android/main/disable_clipboard.sh > disable_clipboard.sh
   curl https://raw.githubusercontent.com/jogerj/block-clipboard-android/main/enable_clipboard.sh > enable_clipboard.sh
   chmod +x disable_clipboard.sh enable_clipboard.sh
   ```
2. Run `./disable_clipboard.sh`
3. Enable developer mode/options in settings. For adb to "connect" to your device you need to first [pair it in wireless debugging options](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+) ([video](https://www.youtube.com/watch?v=ElahzmTPCYE)). Pairing is a bit tricky, the "Pair with device" pop-up **needs to remain open as you enter the port and pairing code into Termux**, so you need to open the Settings app in split screen so you have it like this:
   
   <img src="https://user-images.githubusercontent.com/30559735/154190754-69690a4c-9ef8-45a2-9c81-d95d9135a1cc.png" alt="" width="300px" />
   
   Once paired, you can skip the pairing process and directly enter the port to connect as shown in wireless debugging window when you run the script again.
   
   <img src="https://user-images.githubusercontent.com/30559735/154191551-78b19550-7105-46c9-9b85-de097a1f6bea.png" alt="" width="300px" />
   
4. Enter a package name you want to disable. Tip: If you're unsure which package you're looking for, open App Info and click on App details to open the Play Store page. Share the app from the drop down menu, the package name will be shown in the URL (e.g. `https://play.google.com/store/apps/details?id=com.example.packagename`)
5. To remove clipboard permissions for another package, rerun the script again. To re-enable clipboard permissions, run `./enable_clipboard.sh`

