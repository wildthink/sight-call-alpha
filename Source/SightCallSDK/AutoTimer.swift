//
//  AutoTimer.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 3/18/21.
//

import Foundation

public class AutoTimer {
    
    public typealias Stepper = (AutoTimer) -> Void
    
    var timer: Timer?
    public private(set) var started: Date?
    
    var endAt: Date? {
        Date(timeInterval: timeout, since: started!)
    }
    
//    var current: TimeInterval {
//        guard let started = started else { return 0 }
//        return Date().timeIntervalSince(started)
//    }
    
    var timeout: TimeInterval = 20
    var interval: TimeInterval
    var step: Stepper?
    
    public var elapsed: TimeInterval {
        guard let started = started else { return timeout }
        return Date().timeIntervalSince(started)
    }

    public var isFinished: Bool {
        (timer == nil) || elapsed >= timeout
    }
    
    public init (timeout: TimeInterval, every secs: TimeInterval, step: Stepper? = nil) {
        self.timeout = timeout
        interval = secs
        self.step = step
    }
    
    public func start() -> Self {
        started = Date()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        timer?.tolerance = interval * 0.1
        return self
    }
    
    public func stop() {
        timer?.invalidate()
        self.timer = nil
    }

    @objc func tick(_ timer: Timer) {
//        current += 1
        step?(self)
        if isFinished {
            stop()
        }
    }
}
