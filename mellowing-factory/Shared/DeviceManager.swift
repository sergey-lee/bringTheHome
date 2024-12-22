//
//  FetchAlarmsViewModel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/04/26.
//
import SwiftUI
import Amplify

enum deviceStatus {
    case connected, disconnected, noDevice, error, isLoading
}

class DeviceManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var connectedDevice: IotDevice? = nil
    @Published var sleepInductionState: SleepInductionState = SleepInductionState(isOn: true, isSmart: false, isManual: true, strength: 5, mode: 8)
    @Published var alarms: [IdentifiableTimer] = [IdentifiableTimer]()
    @Published var smartAlarmIsOn = true
    @Published var fetching = false
    @Published var loading = false
    @Published var checking = false
    @Published var isEmpty = false
    @Published var currentTimer: IotTimer?
    @Published var timeString = ""
    @Published var isAM = true
    @Published var isOnboarded = Defaults.isOnboarded
    @Published var error = false
    
    @Published var deviceStatus: deviceStatus = .noDevice
    @Published var valid: Int = 0
    @Published var wasStarted = false
    @Published var wasStopped = false
    @Published var needUpdate = false
    
    var username: String = ""
    
    @State var timer: Timer?
    
    init(username: String) {
        super.init()
        self.username = username
//        initialize()
    }
    
    func initialize() {
        fetching = true
        loadIoTDevice { result in
            if self.getTimeAFterOnboarding() < 400 {
                self.checkIfIsUpdated { isUpdated in
                    withAnimation {
                        self.needUpdate = !isUpdated
                    }
                }
            } else {
                print("didn't show updating screen")
            }
            self.fetchData()
            self.fetching = false
        }
    }
    
    private func getTimeAFterOnboarding() -> Int {
        guard let connectedDevice else { return 401 }
        guard let createdDate = connectedDevice.created?.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else { return 401 }
        let diffs = Calendar.current.dateComponents([.hour, .minute, .second], from: createdDate.plusOffset(), to: Date())
        guard let hours = diffs.hour, let minutes = diffs.minute, let seconds = diffs.second else { return 401 }
        let secondsPassedFromOnboarding = (hours * 60 * 60) + (minutes * 60)  + seconds
        print("\(secondsPassedFromOnboarding) seconds passed after onboarding")
        return secondsPassedFromOnboarding
    }
    
    func update() {
        withAnimation {
            self.loading = true
        }
        loadIoTDevice { result in
            withAnimation {
                self.loading = true
            }
            self.fetchData()
        }
    }
    
    func check() {
        withAnimation {
            self.loading = true
        }
        loadIoTDevice { result in
            withAnimation {
                self.checking = true
            }
            self.checkIfIsUpdated { isUpdated in
                withAnimation {
                    self.needUpdate = !isUpdated
                    self.checking = false
                    self.loading = true
                }
                self.fetchData()
            }
        }
    }
    
    private let apiNodeServer: ApiNodeServer = ApiNodeServer()
    
    func startCheckingDeviceConnection(timerInterval: Double) {
        if !wasStarted {
            self.checkDeviceConntection()
//            guard self.timer == nil else { return }
//            self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { timer in
                Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { timer in
                if !self.wasStopped {
                    self.checkDeviceConntection()
                }
            })
            wasStarted = true
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        timer = nil
        wasStopped = true
    }
    
        /// returning (isAnalyzing, showButton)
    func checkAnalyzing(completion: @escaping (Bool, Bool) -> Void) {
        guard let id = connectedDevice?.id else {
            completion(false, false)
            return
        }
        apiNodeServer.checkDevice(deviceId: id, interval: 30) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let sensorData: [SensorData] = data
                    let sum = sensorData.reduce(0, { $0 + $1.valid })
                    print("Count of valid: \(sum)")
                    completion(sum > 10, sum > 30)
                }
            case .failure:
                completion(false, false)
            }
        }
    }
    
    func checkDeviceConntection() {
        if connectedDevice?.created != nil {
            let created = connectedDevice!.created!.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").plusOffset()
            let currentDateMinusFiveMinutes = Date().addingTimeInterval(-90)
            let deviceJustOnboarded = created > currentDateMinusFiveMinutes
            
            if !deviceJustOnboarded {
                apiNodeServer.checkDevice(deviceId: connectedDevice!.id) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            withAnimation {
                                if self.currentTimer == nil {
                                    self.setCurrentTimer()
                                }
                                if data.isEmpty {
                                    print("deviceManager: device is disconnected. Data is Empty")
                                    self.deviceStatus = .disconnected
                                } else {
                                    let sensorData = data.first!
                                    print("deviceManager: device is connected. Valid: \(sensorData.valid)")
                                    self.valid = sensorData.valid
                                    self.deviceStatus = .connected
                                }
                            }
                        }
                    case .failure:
                        print("deviceManager: device is disconnected")
                        DispatchQueue.main.async {
                            withAnimation {
                                self.deviceStatus = .disconnected
                            }
                        }
                    }
                }
            } else {
                withAnimation {
                    print("device just onboarded: \(created > currentDateMinusFiveMinutes), createdDate: \(created)")
                    self.deviceStatus = .connected
                }
            }
        } else {
            withAnimation {
                print("deviceManager: No device")
                self.deviceStatus = .noDevice
            }
        }
    }
    
    func loadIoTDevice(completion: @escaping (ApiResult<IotDevice>) -> Void) {
        self.error = false
        apiNodeServer.getDevice(id: username) { [weak self] result in
            switch result {
            case .success(let device):
                DispatchQueue.main.async {
                    self?.connectedDevice = device
//                    self?.soundRecordingMode = false
                    self?.sleepInductionState = device.sleepInductionState
                    self?.isOnboarded = true
                    completion(.success(device))
                }
            case .failure(let error):
                if error as? ApiError != .notFound {
                    self?.error = true
                } else {
                    DispatchQueue.main.async {
                        self?.connectedDevice = nil
                        self?.isOnboarded = false
                    }
                }
                DispatchQueue.main.async {
                    if Defaults.skipOnboarding {
                        self?.isOnboarded = true
                    }
                    completion(.failure(error))
                }
            }
        }
    }
    
    func checkIfIsUpdated(completion: @escaping (Bool) -> Void) {
//        completion(false)
        if let connectedDevice {
            apiNodeServer.checkIfIsUpdated(d_id: connectedDevice.id) { isUpdated in
                completion(isUpdated)
            }
        } else {
            completion(true)
        }
    }
    
//    func createIotDevice(
//        deviceId: String,
//        mac: String,
//        rev: Int,
//        fv: Int,
//        completion: @escaping (ApiResult<IotDevice>) -> Void) {
//            let createDevice = IotDevice(id: deviceId, rev: rev, fv: fv)
//            apiNodeServer.createDevice(id: username, device: createDevice) { [weak self] result in
//                switch result {
//                case .success(let returnDevice):
//                    DispatchQueue.main.async {
//                        self?.connectedDevice = returnDevice
//                        // MARK: Hardcoded default mode: 1
//                        self?.updateIotDevice(mode: 1) { result in
//                            switch result {
//                            case true:
//                                print("mode updated to 1")
//                            case false:
//                                print("Error while updating device")
//                            }
//                        }
//                        completion(.success(returnDevice))
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
    
    func updateIotDevice(
        isTested: Bool? = nil,
//        mode: Int? = nil,
//        strength: Int? = nil,
        sleepInductionState: SleepInductionState? = nil,
        completion: @escaping (Bool) -> Void) {
            if let connectedDevice = connectedDevice {
                var myDevice = connectedDevice
                if let isTested {
                    myDevice.isTested = isTested
                }
//                if let strength {
//                    myDevice.strength = strength
//                }
                if let sleepInductionState {
                    myDevice.sleepInductionState = sleepInductionState
                }
                apiNodeServer.updateDevice(id: username, device: myDevice) { success in
                    DispatchQueue.main.async {
                        if success {
                            withAnimation {
                                self.connectedDevice = myDevice
                                self.sleepInductionState = myDevice.sleepInductionState
                            }
                        }
                        completion(success)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("no device detected")
                    completion(false)
                }
            }
        }
    
    func updateState(
        isOn: Bool? = nil,
        isSmart: Bool? = nil,
        isManual: Bool? = nil,
        strength: Int? = nil,
        mode: Int? = nil,
//        isPersonalised: Bool? = nil,
        completion: @escaping (Bool) -> Void) {
            
            guard let device = connectedDevice else { return completion(false) }
            var updatedSleepInductionState = device.sleepInductionState
            
            if let isOn {
                updatedSleepInductionState.isOn = !isOn
            }
            if let isSmart {
                updatedSleepInductionState.isSmart = !isSmart
            }
            if let isManual {
                updatedSleepInductionState.isManual = !isManual
            }
            if let strength {
                updatedSleepInductionState.strength = strength
            }
            if let mode {
                updatedSleepInductionState.mode = mode
            }
            
            self.updateIotDevice(sleepInductionState:  updatedSleepInductionState) { success in
                completion(success)
            }
        }
    
    func deleteIotDevice(completion: @escaping (Bool) -> Void) {
        if let connectedDevice {
            apiNodeServer.deleteDevice(deviceId: connectedDevice.id) { [weak self] success in
                
                DispatchQueue.main.async {
                    if success {
                        self?.deviceStatus = .noDevice
                        self?.connectedDevice = nil
                        self?.isOnboarded = false
                        Defaults.isOnboarded = false
                        Defaults.skipOnboarding = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(false)
            }
        }
    }
    
    func switchTimers(completion: @escaping (Bool) -> Void) {
        if let connectedDevice {
            apiNodeServer.switchTimers(deviceId: connectedDevice.id) { result in
                switch result {
                case .success(let listOfTimers):
                    self.alarms = listOfTimers.map { IdentifiableTimer(timer: $0) }
                    print("DeviceManager: Switch success")
                    withAnimation {
                        self.smartAlarmIsOn = self.alarms.filter{ $0.timer.isSuppressed ?? false }.isEmpty
                        completion(true)
                    }
                case .failure:
                    self.alarms = []
                    print("DeviceManager: Switch failed")
                    completion(false)
                }
            }
        }
    }
    
    func runSleepInduction(mode: Int, strength: Int, completion: @escaping (Bool) -> Void) {
        guard let connectedDevice else {
            completion(false)
            return
        }
        apiNodeServer.testVibration(d_id: connectedDevice.id, mode: mode, strength: strength, test: false) { success in
            completion(success)
        }
    }
    
    func testVibration(mode: Int, strength: Int, completion: @escaping (Bool) -> Void) {
        guard let connectedDevice else { completion(false)
            return
        }
        apiNodeServer.testVibration(d_id: connectedDevice.id, mode: mode, strength: strength, test: true) { success in
            completion(success)
        }
    }
    
    func stopVibration(completion: @escaping (Bool) -> Void) {
        apiNodeServer.stopVibration(d_id: connectedDevice?.id ?? "") { success in
            completion(success)
        }
    }
    
    func fetchData() {
        //        let username = Amplify.Auth.getCurrentUser()?.username ?? ""
//        fetching = true
        if let connectedDevice {
            getIotTimer(connectedDevice: connectedDevice) { result in
                switch result {
                case .success(let listOfTimers):
                    self.alarms = listOfTimers.map { IdentifiableTimer(timer: $0) }
                    print("DeviceManager: Fetched List of Alarms")
                    self.setCurrentTimer()
                    self.setupNotification()
                case .failure:
                    self.alarms = []
                    print("DeviceManager: No Alarms")
                }
//                self.fetching = false
                self.isEmpty = self.alarms.isEmpty
            }
        } else {
//            self.fetching = false
            self.isEmpty = self.alarms.isEmpty
        }
    }
    
    func getIotTimer(connectedDevice: IotDevice, completion: @escaping (ApiResult<[IotTimer]>) -> Void) {
        self.apiNodeServer.getTimer(deviceId: connectedDevice.id) { timerResult in
            DispatchQueue.main.async {
                completion(timerResult)
            }
        }
    }
    
    func addAlarm(timer: IotTimer) {
        if let connectedDevice = connectedDevice {
            self.loading = true
            apiNodeServer.createTimer(deviceId: connectedDevice.id, timer: timer) { result in
                switch result {
                case .success(let timer) :
                    DispatchQueue.main.async {
                        self.alarms.append(IdentifiableTimer(timer: timer))
                        self.setupNotification()
                        self.setCurrentTimer()
                    }
                case .failure(let error) : print(error)
                }
                DispatchQueue.main.async {
                    self.loading = false
                    self.isEmpty = self.alarms.isEmpty
                }
            }
        }
    }
    
    func deleteAlarm(timerId: String, completion: @escaping (Bool) -> Void) {
        if let connectedDevice = connectedDevice {
            self.loading = true
            apiNodeServer.deleteTimer(deviceId: connectedDevice.id, timerId: timerId) { result in
                switch result {
                case true :
                    DispatchQueue.main.async {
                        self.alarms.removeAll { $0.timer.t_id == timerId }
                        self.setupNotification()
                        self.setCurrentTimer()
                    }
                case false : print("DeviceManager: Error while deleting an object")
                }
                DispatchQueue.main.async {
                    self.loading = false
                    self.isEmpty = self.alarms.isEmpty
                    completion(true)
                }
            }
        }
    }
    
    func editAlarm(timerId: String, timer: IotTimer, completion: @escaping (Bool) -> Void) {
        loading = true
        if let connectedDevice = connectedDevice {
            apiNodeServer.updateTimer(deviceId: connectedDevice.id, timerId: timerId, timer: timer) { result in
                switch result {
                case .success(let timer) :
                    DispatchQueue.main.async {
                        self.alarms.removeAll { $0.timer.t_id == timerId }
                        self.alarms.append(IdentifiableTimer(timer: timer))
                        self.setCurrentTimer()
                        self.setupNotification()
                        self.loading = false
                        completion(true)
                    }
                case .failure(let error) :
                    print(error)
                    DispatchQueue.main.async {
                        self.loading = false
                        completion(false)
                    }
                }
                DispatchQueue.main.async {
                    self.isEmpty = self.alarms.isEmpty
                }
            }
        } else {
            completion(false)
        }
    }
    
    ///            Setting Current alarm if:
    ///                - there was no actions with alarm for last hour
    ///                - time is active
    ///                - timer set on current day of week
    ///                - current time is earlier than target time on 60 mins
    ///                - current time is not later than target time + 20 mins
    func checkIfAlarmIsSet() -> IotTimer? {
        let currentDate = Date()
        let currentDayOfWeek = currentDate.dayOFWeek() - 1
        let currentHours = currentDate.toStringUTC(dateFormat: "HH")
        let currentMinutes = currentDate.toStringUTC(dateFormat: "mm")
        let formattedCurrentTime = (Int(currentHours) ?? 0) * 60 + (Int(currentMinutes) ?? 0)
        
        if !alarms.isEmpty {
            let minutesAfterAlarm = 20
            let currentTimers = alarms.filter {
                $0.timer.isActive == true
                && $0.timer.isSkipped == false
                && $0.timer.week[currentDayOfWeek] == true
                && moreThanNMinutes(targetTime: $0.timer.targetTime, current: formattedCurrentTime, minutes: minutesAfterAlarm)
                && lessThanOneHour(targetTime: $0.timer.targetTime, current: formattedCurrentTime)
            }
            
            if !currentTimers.isEmpty && isNotSupressed(currentTimers: currentTimers, formattedCurrentTime: formattedCurrentTime) {
                if let targetTime = currentTimers.first?.timer.targetTime {
                    let delayTime = (targetTime - formattedCurrentTime + minutesAfterAlarm) * 60
                    autoSuppress(delayInSeconds: Double(delayTime))
                }
                return currentTimers.first?.timer
            } else {
                print("No alarm for current time: \(currentDate.plusOffset())")
            }
        }
        return nil
    }
    
    /// need it because there could be two variables from different days. ex: 1430 and  20 where 20 should be bigger (23:50 and 00:20)
    func getProperIntFromTimeInt(time: Int) -> Int {
        return time > 720 ? time : time + 1440
    }
    
    func moreThanNMinutes(targetTime: Int, current: Int, minutes: Int) -> Bool {
        if abs(targetTime - current) > 60 {
            return getProperIntFromTimeInt(time: targetTime) + minutes > getProperIntFromTimeInt(time: current)
        } else {
            return targetTime + 1 > current
        }
    }
    
    func lessThanOneHour(targetTime: Int, current: Int) -> Bool {
        if abs(targetTime - current) > 60 {
            return getProperIntFromTimeInt(time: targetTime) - 60 <= getProperIntFromTimeInt(time: current)
        } else {
            return targetTime - 60 <= current
        }
    }
    
    func isNotSupressed(currentTimers: [IdentifiableTimer], formattedCurrentTime: Int) -> Bool {
        guard let timer = currentTimers.first?.timer else { return false }
        guard let lastActioned = self.alarms.first!.timer.lastActioned else { return false }
        guard let lastActionedDate = lastActioned.iso8601withFractionalSeconds else { return false }
        
        let timeMinus5Mins = Date().addingTimeInterval(-300)
        guard formattedCurrentTime > (timer.targetTime - 5) else { return true }
//        print("timeMinus5Mins: \(timeMinus5Mins)")
//        print("lastActionedDate: \(lastActionedDate)")
        
        return timeMinus5Mins > lastActionedDate
    }
    
    func setCurrentTimer() {
        self.currentTimer = self.checkIfAlarmIsSet()
        if let currentTimer = self.currentTimer {
            var alarmTime = currentTimer.targetTime + TIME_OFFSET_MINUTES
            alarmTime = alarmTime > 1440 ? alarmTime - 1440 : alarmTime
            isAM = alarmTime > 720 ? false : true
            alarmTime = alarmTime > 780 ? (alarmTime - 720) : alarmTime
            
            self.timeString = Double(alarmTime).asTimeString(style: .positional)
            print("DeviceManager: Alarm set at \(self.timeString)")
        }
    }
    
    private func autoSuppress(delayInSeconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.turnOff()
        }
    }
    
    func summarizeBoolArrays() -> [Bool] {
        var summ: [Bool] = [false, false, false, false, false, false, false]
        if !self.isEmpty {
            for alarm in alarms {
                for i in 0...6 {
                    summ[i] = summ[i] || alarm.timer.week[i]
                }
            }
        }
        return summ
    }
    
    func setupNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.delegate = self
        print("DeviceManager:  Notifications:", terminator: " ")
        for alarm in self.alarms {
            //MARK: -5 - to send notification 5 minutes before targer time
            let properTime = alarm.timer.targetTime.plusOffset() - 5
            let hours = properTime / 60
            let minutes = properTime % 60
            let weekDays = alarm.timer.week.enumerated().filter { $1 }.map { $0.0 }
            
            if alarm.timer.isActive != false {
                for weekDay in weekDays {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "PUSH.TITLE".localized()
                    content.body = "PUSH.BODY".localized()
                    //                    content.body = Double(properTime + 30).asTimeString(style: .positional)
                    content.sound = UNNotificationSound.default
                    content.categoryIdentifier = "ACTIONS"
                    let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
//                    let turnOff = UNNotificationAction(identifier: "TURNOFF", title: "Turn Off", options: .foreground)
                    //                    let snooze = UNNotificationAction(identifier: "SNOOZE", title: "Snooze", options: .foreground)
                    let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close], intentIdentifiers: [], options: [])
                    center.setNotificationCategories([category])
                    let dateComponents = DateComponents(hour: hours, minute: minutes, weekday: weekDay + 1)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    //                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request)
                    print("\(Double(properTime).asTimeString(style: .positional)) \((weekDay + 1).toDayWeek())", terminator: " ")
                }
            }
        }
        print("")
    }
    
    func skip() {
        self.loading = true
        if let currentTimer {
            var newTimer = currentTimer
            newTimer.isSkipped = true
            self.apiNodeServer.updateTimer(deviceId: currentTimer.d_id ?? "", timerId: currentTimer.t_id ?? "", timer: newTimer) { result in
                self.loading = false
                switch result {
                case .success(let timer):
                    DispatchQueue.main.async {
                        self.currentTimer = nil
                        print(timer)
                        self.alarms.removeAll(where: { $0.timer.t_id == timer.t_id })
                        self.alarms.append(IdentifiableTimer(timer: timer))
                        print("DeviceManager: alarm is skipped")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func turnOff() {
        self.loading = true
        if let currentTimer {
            apiNodeServer.stopVibration(d_id: currentTimer.d_id ?? "") { bool in
                if bool {
                    self.skip()
                }
            }
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "TURNOFF" {
            self.turnOff()
        }
        completionHandler()
    }
    
    func endSleep(completion: @escaping (Bool) -> Void) {
        guard let connectedDevice else { completion(false)
            return
        }
        apiNodeServer.endSleep(d_id: connectedDevice.id) { success in
            completion(success)
        }
    }
}
