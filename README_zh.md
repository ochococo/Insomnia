#🌃 Insomnia
===========

![Insomnia Logo](Insomnia.jpg)

![Swift4.1](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)
![Coverage 100%](https://img.shields.io/badge/coverage-100%25-green.svg)
[![Version](https://img.shields.io/cocoapods/v/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![License](https://img.shields.io/cocoapods/l/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![Platform](https://img.shields.io/cocoapods/p/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/Insomnia.svg?style=flat)](http://cocoadocs.org/docsets/Insomnia)

❤️ 如果可以的话请[支持一下](https://github.com/sponsors/ochococo),谢谢🙏

-如何防止屏幕在我的应用运行时锁定?
-如何防止设备在应用运行过程中屏幕变暗或关闭？
-在显示某些ViewController时如何防止iPhone屏幕变暗或关闭?

好吧......有时您想让iPhone保持活动状态更长一点,无论是导入还是游戏界面.
而`Insomnia`是一个解决这些问题的绝佳方法!

该项目旨在简化代码,并为您提供经过完整测试的可靠解决方案.

⚙ 运行模式:
========

- `.disabled` - 一切都不会改变(禁用功能).
- `.always` - 设备将永远不会进入睡眠状态.
- `.whenCharging` - 只要连接到充电器,设备就不会进入睡眠状态.

**警告:** 如果解除了Insomnia实例,则会自动禁用其功能,并且设备将正常运行(超时后将锁定屏幕).


👨‍💻 使用方法:
=========

## 1. 禁用自动锁定:

```swift
final class AppDelegate: UIApplicationDelegate {
	private let insomnia = Insomnia(mode: .always)
}

```

## 2. 仅在连接到电源时禁用自动锁定:

```swift
final class AppDelegate: UIApplicationDelegate {
	private let insomnia = Insomnia(mode: .whenCharging)
}
```

## 3. 仅在View Controller启用时禁用自动锁定:

```swift
final class SomeViewController: UIViewController {
	private let insomnia = Insomnia(mode: .always)
}
```

## 4. 更改运行方式:

```swift
insomnia.mode = .always
```

🤔 原理:
=============

简单来说,我们可以这么做:

```swift
UIApplication.shared.isIdleTimerDisabled = true
```

但是问题就在于,您必须在不再需要该全局变量时将其更改为` false`.
所以,不妨来思考一下,如果仅在设备处于充电器状态时才想要激活它,该怎么办呢?

👏 致谢:
===========

Logo由[Artur Martynowski](https://dribbble.com/artur-martynowski)设计.
