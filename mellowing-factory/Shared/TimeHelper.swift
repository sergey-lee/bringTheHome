//
//  TimeHelper.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/17.
//

import SwiftUI
class TimeHelper {
    var meridian: String
    var time: String
    var days: [String]

    init(alarm: IotTimer) {
        let date = TimerConverter().convertTimerToDate(timer: alarm)
        let dateFormatter = DateFormatter()
        
        meridian = {
            dateFormatter.dateFormat = "a"
            let appLanguage = languageList[UserDefaults.standard.integer(forKey: "appLanguage")].loc
            dateFormatter.locale = Locale(identifier: appLanguage)
            return dateFormatter.string(from: date)
        }()
        
        time = {
            dateFormatter.dateFormat = "h:mm"
            return dateFormatter.string(from: date)
        }()

        days = {
            var result: [String] = []
            
            if alarm.week.allSatisfy({$0}) {
                return ["Sun - Sat"]
            }
            
            if alarm.week == [false, true, true, true, true, true, false] {
                return ["WEEKDAYS"]
            }
            
            if alarm.week == [true, false, false, false, false, false, true] {
                return ["WEEKENDS"]
            }
            
            for i in 0...6 {
                if alarm.week[i] {
                    result.append(weekDays[i])
                }
            }
//            let substring = result.dropLast(2)
            return result
        }()
    }
    
    func fullString() -> String {
        return time + " " + meridian.lowercased()
    }
}

struct AlarmViewDelete_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            AlarmView(t_id: .constant("sd"), alarm:
                                
//                                IotTimer(targetTime: 1, week: [true,true,true,true,true,true,false], timezone_offset: 1))
                
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray50)
        
    }
}
