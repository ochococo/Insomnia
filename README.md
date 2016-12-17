🌃 Insomnia
===========

![Insomnia Logo](Insomnia.jpg)

![Swift2.2](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)
![Coverage 100%](https://img.shields.io/badge/coverage-100%25-green.svg)
[![Version](https://img.shields.io/cocoapods/v/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![License](https://img.shields.io/cocoapods/l/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![Platform](https://img.shields.io/cocoapods/p/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)

Micro library to answer to questions like:

- How to prevent screen lock on my application?
- How can I prevent the display on an iOS device from dimming and turning off?
- How do I prevent the iPhone screen from dimming or turning off while certain ViewController is presented?

Well... Sometimes you want your iPhone to stay active a little bit longer is it an import or just game interface.

This project aims to simplify the code and give you a well tested solution.

⚙ Modes:
========

- `.disabled` - Nothing will change (disabled functionality).
- `.always` - Your iOS device will never timeout and go to sleep.
- `.whenCharging` - Device will stay active as long as it's connected to charger.

**Important:** If Insomnia instance is deallocated, it's functionality is automatically disabled and device will behave nominally (timeout, disable screen and lock).


👨‍💻 Usage:
=========

## 1. Don't go to sleep, ever:

```swift
final class AppDelegate: UIApplicationDelegate {
	private let insomnia = Insomnia(mode: .always)
}

```

## 2. Same but only when charging:

```swift
final class AppDelegate: UIApplicationDelegate {
	private let insomnia = Insomnia(mode: .whenCharging)
}
```

## 3. Don't go to sleep if certain View Controller is alive:

```swift
final class SomeViewController: UIViewController {
	private let insomnia = Insomnia(mode: .always)
}
```

## 4. Change mode:

```swift
insomnia.mode = .always
```

🤔 Rationale:
=============

The too simple answer is:

```swift
UIApplication.shared.isIdleTimerDisabled = true
```

The problem with this solution is that you have to remember to change this global variable to `false` when it's no longer needed. 
What if you want to activate it only when your device is on charger? 

👏 Credits:
===========


Logo design by [Artur Martynowski](https://dribbble.com/artur-martynowski) - check his dribble profile, he's really great!
