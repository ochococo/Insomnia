//
//    The MIT License (MIT)
//
//    Copyright (c) 2016-2019 Oktawian Chojnacki
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import Foundation

import XCTest
@testable import Tests

final class DeviceMock : UIDevice {

    var mock_batteryState: UIDevice.BatteryState = .unknown

    override var batteryState: UIDevice.BatteryState {
        get { return mock_batteryState }
        set {}
    }
}

final class InsomniaTests: XCTestCase {

    let device = DeviceMock()
    var insomnia: Insomnia!

    override func setUp() {
        super.setUp()

        insomnia = Insomnia(mode: .whenCharging, device: device)
    }

    func testNotifiedAboutBatteryStateChangeCharging() {

        device.mock_batteryState = .charging

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertTrue(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeFull() {

        device.mock_batteryState = .full

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertTrue(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeUnknown() {

        device.mock_batteryState = .unknown

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertFalse(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeUnplugged() {

        device.mock_batteryState = .unplugged

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertFalse(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeAfterNotification() {

        device.mock_batteryState = .charging

        var batteryIsPlugged = true

        insomnia.batteryStateHandler = { isPlugged in
            batteryIsPlugged = isPlugged
        }

        device.mock_batteryState = .unplugged

        let notification = Notification(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.post(notification)

        XCTAssertFalse(batteryIsPlugged)
    }

    func testDidSetInsomniaModeToDisabledAfterNotificationAboutUnplugged() {

        device.mock_batteryState = .unplugged

        let notification = Notification(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.post(notification)

        XCTAssertFalse(UIApplication.shared.isIdleTimerDisabled)
    }

    func testDidSetInsomniaModeToEnabledAfterNotificationAboutCharging() {

        device.mock_batteryState = .charging

        let notification = Notification(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.post(notification)

        XCTAssertTrue(UIApplication.shared.isIdleTimerDisabled)
    }

    func testDidSetInsomniaModeToEnabledInAlwaysModeAfterNotificationAboutUnplugged() {

        insomnia.mode = .always

        device.mock_batteryState = .unplugged

        let notification = Notification(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.post(notification)

        XCTAssertTrue(UIApplication.shared.isIdleTimerDisabled)
    }

    func testDidSetInsomniaModeToDisabledInDisabledModeAfterNotificationAboutCharging() {

        insomnia.mode = .disabled

        device.mock_batteryState = .charging

        let notification = Notification(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.post(notification)

        XCTAssertFalse(UIApplication.shared.isIdleTimerDisabled)
    }

    func testDidInsomniaClearedTheTimerPropertyAfterDeinitialization() {

        insomnia.mode = .always

        insomnia = nil

        XCTAssertFalse(UIApplication.shared.isIdleTimerDisabled)
    }
}
