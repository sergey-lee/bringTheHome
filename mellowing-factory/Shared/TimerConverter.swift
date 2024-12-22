//
//  TimerConverter.swift
//  mellowing-factory
//
//  Created by Florian Topf on 04.02.22.
//

import Foundation

let TIME_OFFSET = Defaults.presentationMode ? 32400 : TimeZone.current.secondsFromGMT()
let TIME_OFFSET_D: Double = Double(TIME_OFFSET)
let TIME_OFFSET_MINUTES = TIME_OFFSET / 60

struct TimerConverter {
    private static let DAY_IN_MINUTES = 1440
    
    func convertDateToTimer(date: Date, mode: Int, strength: Int, week: [Bool] = [true, true, true, true, true, true, true]) -> IotTimer {
        /// timezone offset in seconds
        let timezoneOffset: Int = TimeZone.current.secondsFromGMT(for: date)
        /// Substract the timezone offset from our target time in minutes to get utc time
        let targetTime: Int = (Calendar.current.component(.hour, from: date) * 60) +
            Calendar.current.component(.minute, from: date) - (timezoneOffset / 60)
        
        var newTargetTime: Int = TimerConverter.DAY_IN_MINUTES + targetTime;
        if (newTargetTime >= TimerConverter.DAY_IN_MINUTES) {
            newTargetTime = newTargetTime - TimerConverter.DAY_IN_MINUTES
        }
        return IotTimer(targetTime: newTargetTime, week: week, timezone_offset: timezoneOffset, mode: mode, strength: strength, isActive: true, isSnoozed: false, isSkipped: false, isSuppressed: false)
    }
    
    func convertTimerToDate(timer: IotTimer) -> Date {
        let hours: Int = timer.targetTime / 60
        let minutes: Int = timer.targetTime - (hours * 60)
        var localHours: Int = hours + (timer.timezone_offset / 3600)
        if localHours >= 24 {
            localHours = localHours - 24
        }
        let date = Date()

        return Calendar.current.date(
            bySettingHour: localHours,
            minute: minutes,
            second: 0,
            of: date
        ) ?? date
    }
}
