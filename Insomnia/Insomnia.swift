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

import UIKit

/**

 Insomnia modes:
 
 - `disabled`: Nothing will change (disabled functionality).
 - `always`: Your iOS device will never timeout and lock.
 - `whenCharging`: Device will stay active as long as it's connected to charger.

 */
public enum InsomniaMode {
    /** 
    Nothing will change (disabled functionality).
     */
    case disabled
    /**
    Your iOS device will never timeout and lock.
     */
    case always
    /**
    Device will stay active as long as it's connected to charger.
     */
    case whenCharging
}

/**
 This protocol describes ability to set `batteryStateHandler` and be notified about battery state changes.
 */
public protocol BatteryStateReporting: class {
    /**
     You can set this closure to be notified when your device is being plugged/unplugged from charger.
     */
    var batteryStateHandler: ((_ isPlugged: Bool) -> Void)? { get set }
}

public protocol InsomniaModeHaving {
    /**
     This mode will change the behavior:

     - `disabled`: Nothing will change (disabled functionality).
     - `always`: Your iOS device will never timeout and lock.
     - `whenCharging`: Device will stay active as long as it's connected to charger.

     */
    var mode: InsomniaMode { get set }
}

/**

    Sometimes you want your iPhone to stay active a little bit longer is it an import or just game interface.

    This simple class aims to simplify the code and give you a well tested solution.

 */
public final class Insomnia: BatteryStateReporting, InsomniaModeHaving {

    /**
         This mode will change the behavior:
         
         - `disabled`: Nothing will change (disabled functionality).
         - `always`: Your iOS device will never timeout and lock.
         - `whenCharging`: Device will stay active as long as it's connected to charger.

     */
    public var mode: InsomniaMode {
        didSet {
            updateInsomniaMode()
        }
    }

    /**
    You can set this closure to be notified when your device is being plugged/unplugged from charger.
     */
    public var batteryStateHandler: ((_ isPlugged: Bool) -> Void)? {
        didSet {
            notifyAboutCurrentBatteryState()
        }
    }

    private unowned let device: UIDevice
    private unowned let notificationCenter: NotificationCenter
    private unowned let application: UIApplication

    /**

         Initializes a new Insomnia instance.

         - parameters:
             - mode: Mode determines behaviour (see InsomniaMode enum).
             - device: UIDevice
             - notificationCenter: NotificationCenter
             - application: UIApplication

     */
    public init(mode: InsomniaMode,
                device: UIDevice = UIDevice.current,
                notificationCenter: NotificationCenter = NotificationCenter.default,
                application: UIApplication = UIApplication.shared) {
        self.device = device
        self.mode = mode
        self.notificationCenter = notificationCenter
        self.application = application
        updateInsomniaMode()
    }

    private func startMonitoring() {
        device.isBatteryMonitoringEnabled = true
        notificationCenter.addObserver(self,
                                       selector: #selector(batteryStateDidChange),
                                       name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }

    private func stopMonitoring() {
        notificationCenter.removeObserver(self)
        device.isBatteryMonitoringEnabled = false
    }

    @objc private func batteryStateDidChange(notification: NSNotification){
        updateInsomniaMode()
    }

    private func updateInsomniaMode() {
        switch mode {
        case .whenCharging:
            startMonitoring()
            notifyAboutCurrentBatteryState()
            application.isIdleTimerDisabled = isPlugged
        case .always:
            stopMonitoring()
            application.isIdleTimerDisabled = true
        case .disabled:
            stopMonitoring()
            application.isIdleTimerDisabled = false
        }
    }

    private func notifyAboutCurrentBatteryState() {
        batteryStateHandler?(isPlugged)
    }

    private var isPlugged: Bool {
        switch device.batteryState {
        case .unknown, .unplugged:
            return false
        default:
            return true
        }
    }

    deinit {
        stopMonitoring()
        application.isIdleTimerDisabled = false
    }
}
