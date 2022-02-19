# Block Read Clipboard Permission in Android
Block clipboard permission to certain apps via ADB in Termux. Requires Android 10 or above.

## Background
Recently it has been found that [apps on Android and iOS are known to access your clipboard (history) covertly](https://www.howtogeek.com/680147/psa-all-apps-can-read-your-iphone-and-android-clipboard/). [Apps like TikTok](https://arstechnica.com/gadgets/2020/06/tiktok-and-53-other-ios-apps-still-snoop-your-sensitive-clipboard-data/) uses these clipboard information to "improve user experience". The implications are **these apps could retrieve private information that you stored in your clipboard or even passwords and then send them to a remote server**. Since iOS 14 and Android 12, your smartphone would alert you when an app accesses your clipboard, however in Android there's no direct way to block access to these applications from reading your clipboard contents.

### How clipboard on Android works
> Unless your app is the default input method editor (IME) or is the app that currently has focus, your app cannot access clipboard data on Android 10 or higher. [Source](https://developer.android.com/about/versions/10/privacy/changes#clipboard-data)

This means that apps no longer can access your clipboard data when running in the background. In Android 12, [a toast message will alert the user](https://developer.android.com/about/versions/12/behavior-changes-all#clipboard-access-notifications) when an app tries to access clipboard data from a different app (**the clipboard is still accessed**). However, apps **can still access your clipboard data when you open the app in foreground**.

### What this script does
This script accesses your Android phone via adb (without requiring a separate computer/USB connection) and removes the `READ_CLIPBOARD` permission from any app you choose. Removing this permission disables pasting text in any text fields within the app. However, you can still paste text from your keyboard if your keyboard supports it (e.g. [Gboard](https://www.ubergizmo.com/how-to/manage-clipboard-android/), [SwiftKey](https://support.swiftkey.com/hc/en-us/articles/212813085-How-does-the-Clipboard-work-with-Microsoft-SwiftKey-Keyboard-for-Android-), etc.), which arguably would be more secure than unwanted/untrusted apps accessing your clipboard. Disabling clipboard permission will not interefere with [Auto-fill](https://developer.android.com/guide/topics/text/autofill) functions used by password managers as they use different API, but you won't be able to manually paste passwords using clipboard (except from keyboard). The entire process is completely reversible, see `enable_clipboard.sh`. If running on a different computer, make sure to enter the device hostname/IP address when prompted.

## Requirements
- Android device running Android 10 or above
- Latest version of [Termux](https://f-droid.org/en/packages/com.termux/) (to run without separate computer)
  - Without Termux, you can also use a <a href="#" title="macOS, Linux, others UNIX based, etc.">`computer with (bash) shell`</a> and `adb` installed on the **same network** as your device.

## How to
1. Open Termux and clone this repository (requires git installed, `pkg install git`)
   ```sh
   git clone https://github.com/jogerj/block-clipboard-android
   cd block-clipboard-android
   ```
   or download individual scripts files using curl
   ```sh
   curl -o disable_clipboard.sh https://raw.githubusercontent.com/jogerj/block-clipboard-android/main/disable_clipboard.sh && curl -o enable_clipboard.sh https://raw.githubusercontent.com/jogerj/block-clipboard-android/main/enable_clipboard.sh && chmod +x disable_clipboard.sh enable_clipboard.sh
   ```
   
2. [Enable developer mode/options](https://github.com/jogerj/block-clipboard-android/#enable-developer-mode) in settings. Enable Wireless ADB Debugging, then enable USB Debugging.
3. Run `bash disable_clipboard.sh` 
4. Enter a package name you want to disable. Tip: If you're unsure which package you're looking for, open App Info and click on App details to open the Play Store page. Share the app from the drop down menu, the package name will be shown in the URL (e.g. `https://play.google.com/store/apps/details?id=com.example.packagename`)
5. To remove clipboard permissions for another package, rerun the script again. To re-enable clipboard permissions, run `bash enable_clipboard.sh`

## Further Reading
- [Android Clipboard Privacy (xda-developers)](https://www.xda-developers.com/stop-apps-reading-android-clipboard/)
- [Android 13 DP1 introduces a Gboard-like clipboard auto clear feature (xda-developers)](https://www.xda-developers.com/android-13-clipboard-auto-clear/)
- [Apps known to have accessed clipboard data in iOS](https://www.techradar.com/news/its-not-just-tiktok-another-53-ios-apps-will-snatch-your-clipboard-data) (Note: "It is unclear whether the same selection of apps also scrape the clipboard data of Android users")
- Fahl, Sascha et al. “Hey, You, Get Off of My Clipboard - On How Usability Trumps Security in Android Password Managers.” Financial Cryptography (2013). [Link](https://www.semanticscholar.org/paper/Hey%2C-You%2C-Get-Off-of-My-Clipboard-On-How-Usability-Fahl-Harbach/07df3ec37c891a257ed03f4c9c123039e752d58b)


### Enabling developer mode
| Device                      | Setting                                                                                                                                       |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Google Pixel                | Settings > About phone > Build number                                                                                                         |
| Samsung Galaxy S8 and later | Settings > About phone > Software information > Build number                                                                                  |
| LG G6 and later             | Settings > About phone > Software info > Build number                                                                                         |
| HTC U11 and later           | Settings > About > Software information > More > Build number or Settings > System > About phone > Software information > More > Build number |
| OnePlus 5T and later        | Settings > About phone > Build number                                                                                                         |

([source](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+))
