//
//    The MIT License (MIT)
//
//    Copyright (c) 2016 Oktawian Chojnacki
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
@testable import Stamp

final class DeviceMock : UIDevice {

    var mock_batteryState: UIDeviceBatteryState = .Unknown

    override var batteryState: UIDeviceBatteryState {
        get { return mock_batteryState }
        set {}
    }
}

final class InsomniaTests: XCTestCase {

    let device = DeviceMock()
    var insomnia: Insomnia!

    override func setUp() {
        super.setUp()

        insomnia = Insomnia(mode: .WhenCharging, device: device)
    }

    func testNotifiedAboutBatteryStateChangeCharging() {

        device.mock_batteryState = .Charging

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertTrue(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeFull() {

        device.mock_batteryState = .Full

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertTrue(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeUnknown() {

        device.mock_batteryState = .Unknown

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertFalse(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeUnplugged() {

        device.mock_batteryState = .Unplugged

        insomnia.batteryStateHandler = { isPlugged in
            XCTAssertFalse(isPlugged)
        }
    }

    func testNotifiedAboutBatteryStateChangeAfterNotification() {

        device.mock_batteryState = .Charging

        var batteryIsPlugged = true

        insomnia.batteryStateHandler = { isPlugged in
            batteryIsPlugged = isPlugged
        }

        device.mock_batteryState = .Unplugged

        let notification = NSNotification(name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

        XCTAssertFalse(batteryIsPlugged)
    }

    func testDidSetInsomniaModeToDisabledAfterNotificationAboutUnplugged() {

        device.mock_batteryState = .Unplugged

        let notification = NSNotification(name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

        XCTAssertFalse(UIApplication.sharedApplication().idleTimerDisabled)
    }

    func testDidSetInsomniaModeToEnabledAfterNotificationAboutCharging() {

        device.mock_batteryState = .Charging

        let notification = NSNotification(name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

        XCTAssertTrue(UIApplication.sharedApplication().idleTimerDisabled)
    }

    func testDidSetInsomniaModeToEnabledInAlwaysModeAfterNotificationAboutUnplugged() {

        insomnia.mode = .Always

        device.mock_batteryState = .Unplugged

        let notification = NSNotification(name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

        XCTAssertTrue(UIApplication.sharedApplication().idleTimerDisabled)
    }

    func testDidSetInsomniaModeToDisabledInDisabledModeAfterNotificationAboutCharging() {

        insomnia.mode = .Disabled

        device.mock_batteryState = .Charging

        let notification = NSNotification(name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

        XCTAssertFalse(UIApplication.sharedApplication().idleTimerDisabled)
    }
}
