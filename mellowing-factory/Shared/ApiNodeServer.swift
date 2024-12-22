//
//  ApiNodeServer.swift
//  mellowing-factory
//
//  Created by Florian Topf on 01.01.22.
//

import Foundation
import Amplify
import AWSAPIPlugin
import AWSCognitoIdentityProvider
import UserNotifications

final class ApiNodeServer {
    private static let API_NAME = "DeviceApi"
    private let statisticsCache = Cache<StatisticsTimeFrame, StatisticsResponse>()
    private let journalCache = Cache<Date, JournalResponse>()
    
    func getUser(id: String, completion: @escaping (ApiResult<ApiNodeUser>) -> Void) {
        let queryParameters = ["id": id]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/user/get",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get user success \(str)")
                if let response: GetApiNodeUserResponse = decodeJson(data: data) {
                    completion(.success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("Get user failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    
    func createUser(user: ApiNodeUser, completion: @escaping (Bool) -> Void) {
        let getUserRequest = CreateApiNodeUserRequest(item: user)
        
        if let requestBody = encodeJson(data: getUserRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/user/create",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Create user success \(str)")
                    completion(true)
                } catch let apiError {
                    print("Create user failed \(apiError)")
                    completion(false)
                }
            }
        }
    }
    
    func updateUser(id: String, user: ApiNodeUser, completion: @escaping (ApiNodeUser?) -> Void) {
        let getUserRequest = UpdateApiNodeUserRequest(id: id, item: user)
        
        if let requestBody = encodeJson(data: getUserRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/user/update",
                                      body: requestBody)
            
            print("Update Body \(String(decoding: requestBody, as: UTF8.self))")
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Update user success:: \(str)")
                    if let response: GetApiNodeUserResponse = decodeJson(data: data) {
                        completion(response.data)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Update user failure \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    func deleteUser(id: String, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let queryParameters = ["id": id]
                let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                          path: "/user/delete",
                                          queryParameters: queryParameters)
                
                _ = try await Amplify.API.delete(request: request)
                print("Delete user from DB success")
                try await Amplify.Auth.deleteUser()
                print("Cognito User delete successfully.")
                completion(true)
            } catch let error as AuthError {
                print("Delete user failed with error \(error)")
                completion(false)
            } catch {
                print("Unexpected error: \(error)")
                completion(false)
            }
        }
    }
    
    func createDevice(id: String, device: IotDevice, completion: @escaping (ApiResult<IotDevice>) -> Void) {
        let createDeviceRequest = CreateIotDeviceRequest(u_id: id, item: device)
        
        if let requestBody = encodeJson(data: createDeviceRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/register",
                                      body: requestBody)
            
            print("Body \(String(decoding: requestBody, as: UTF8.self))")
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Create device success \(str)")
                    completion(.success(device))
                } catch {
                    print("Create device failure \(error)")
                    completion(.failure(ApiError.httpError))
                }
            }
        }
    }
    
    func createBTHDevice(id: String, device: Device, completion: @escaping (ApiResult<Device>) -> Void) {
        let createDeviceRequest = CreateDeviceRequest(u_id: id, item: device)
        
        if let requestBody = encodeJson(data: createDeviceRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/register",
                                      body: requestBody)
            
            print("Body \(String(decoding: requestBody, as: UTF8.self))")
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Create device success \(str)")
                    completion(.success(device))
                } catch {
                    print("Create device failure \(error)")
                    completion(.failure(ApiError.httpError))
                }
            }
        }
    }
    
    func updateDevice(id: String, device: IotDevice, completion: @escaping (Bool) -> Void) {
        let getDeviceRequest = UpdateIotDeviceRequest(d_id: device.id,
                                                      item: UpdateBody(name: id,
                                                                       rev: device.rev,
                                                                       fv: device.fv,
                                                                       isTested: device.isTested,
                                                                       sleepInductionState: device.sleepInductionState
                                                                      ))
        if let requestBody = encodeJson(data: getDeviceRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/update",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Update device success \(str)")
                    completion(true)
                } catch {
                    print("Update device failure \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func testVibration(d_id: String, mode: Int, strength: Int, test: Bool, completion: @escaping (Bool) -> Void) {
        let testDeviceRequest = TestDeviceRequest(d_id: d_id, mode: mode, interval: 1000, strength: strength, test: test)
        if let requestBody = encodeJson(data: testDeviceRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/invokeVibration",
                                      body: requestBody)
            Task {
                do {
                    _ = try await Amplify.API.post(request: request)
                    print("Test Vibration success mode:\(mode), strength:\(String(describing: strength))")
                    completion(true)
                } catch {
                    print("Test Vibration failure \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func stopVibration(d_id: String, completion: @escaping (Bool) -> Void) {
        let request = stopVibrationRequest(d_id: d_id)
        
        if let requestBody = encodeJson(data: request) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/stopVibration",
                                      body: requestBody)
            
            Task {
                do {
                    _ = try await Amplify.API.post(request: request)
                    print("Successfully stopped vibration")
                    completion(true)
                } catch {
                    print("stop vibration failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func getDevice(id: String, completion: @escaping (ApiResult<IotDevice>) -> Void) {
        let queryParameters = ["u_id": id]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/device/query",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("ApiNodeServer: Get device success \(str)")
                if let response: GetIotDeviceResponse = decodeJson(data: data) {
                    // todo(florian) for now we only return the first device in list
                    completion(response.data.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response.data.first!))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch {
                print("Get device failure \(error)")
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func checkIfIsUpdated(d_id: String, completion: @escaping (Bool) -> Void) {
        let queryParameters = ["d_id": d_id]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/device/get",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("ApiNodeServer: Checking if device is updated: \(str)")
                DispatchQueue.main.async {
                    if let response: GetIotDeviceAndFlagResponse = decodeJson(data: data) {
//                        completion(true)
                        completion(response.isUpdated)
                    } else {
                        completion(true)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Get device failure \(error)")
                    completion(true)
                }
            }
        }
    }
    
    func deleteDevice(deviceId: String, completion: @escaping (Bool) -> Void) {
        let queryParameters = ["d_id": deviceId]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/device/unregister",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.delete(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Delete device success \(str)")
                // MARK: removing all realm files if user delete device
                deleteFiles(urlsToDelete: getRealmDocs())
                // MARK: removing all notifications if user delete device
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                completion(true)
            } catch {
                print("Delete device failure \(error)")
                completion(false)
            }
        }
    }
    
    func getTimer(deviceId: String,
                  completion: @escaping (ApiResult<[IotTimer]>) -> Void) {
        let queryParameters = ["d_id": deviceId]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/timer/query",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get timer success \(str)")
                if let response: GetIotTimerResponse = decodeJson(data: data) {
                    completion(response.data.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("Get timer failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func createTimer(deviceId: String,
                     timer: IotTimer,
                     completion: @escaping (ApiResult<IotTimer>) -> Void) {
        let createTimerRequest = CreateIotTimerRequest(d_id: deviceId, item: timer)
        
        if let requestBody = encodeJson(data: createTimerRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/timer/create",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Create timer success \(str)")
                    if let response: CreateIotTimerResponse = decodeJson(data: data) {
                        completion(.success(response.data))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch {
                    print("Create timer failure \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateTimer(deviceId: String,
                     timerId: String,
                     timer: IotTimer,
                     completion: @escaping (ApiResult<IotTimer>) -> Void) {
        let updateTimerRequest = UpdateIotTimerRequest(
            d_id: deviceId,
            t_id: timerId,
            item: timer
        )
        
        if let requestBody = encodeJson(data: updateTimerRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/timer/update",
                                      body: requestBody)
            
            //print("Body \(String(decoding: requestBody, as: UTF8.self))")
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Update timer success \(str)")
                    if let response: CreateIotTimerResponse = decodeJson(data: data) {
                        completion(.success(response.data))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch {
                    print("Update timer failure \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func switchTimers(deviceId: String,
                      completion: @escaping (ApiResult<[IotTimer]>) -> Void) {
        let switchBody = SwitchTimersResponse(
            d_id: deviceId
        )
        if let requestBody = encodeJson(data: switchBody) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/timer/switch",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Switch timers success \(str)")
                    if let response: [IotTimer] = decodeJson(data: data) {
                        completion(response.isEmpty ?
                            .failure(ApiError.notFound) :
                                .success(response))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch let error as APIError {
                    print("Switch timers failure \(error)")
                    switch error {
                    case .httpStatusError(let statusCode, _):
                        if statusCode == 404 {
                            completion(.failure(ApiError.notFound))
                            return
                        }
                    default:
                        print("No response from server")
                    }
                    completion(.failure(ApiError.httpError))
                }
            }
        }
    }
    
    func deleteTimer(deviceId: String, timerId: String, completion: @escaping (Bool) -> Void) {
        let queryParameters = ["d_id": deviceId, "t_id": timerId]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/timer/delete",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.delete(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Delete timer success \(str)")
                completion(true)
            } catch let error as APIError {
                print("Delete timer failure \(error)")
                completion(false)
            }
        }
    }
    
    func queryJournalData(journalDate: Date, completion: @escaping (ApiResult<JournalResponse>) -> Void) {
        print("Journal date \(journalDate)")
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "YY-MM-dd"
        //        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        let journalDateString = dateFormatter.string(from: journalDate)
        let isoDateFormatter = ISO8601DateFormatter()
        let timeZoneOffset = TimeZone.current.secondsFromGMT() / 60
        let datePlusNine = Calendar.current.date(byAdding: .hour, value: timeZoneOffset / 60, to: journalDate)!
        let journalDateString = isoDateFormatter.string(from: datePlusNine)
        
        let timeZoneOffsetString = String(format: "%d", timeZoneOffset)
        print("Journal date string: \(journalDateString), offset: \(timeZoneOffset)")
        
        //        if let cachedResponse: JournalResponse = journalCache[journalDate] {
        //            completion(.success(cachedResponse))
        //            return
        //        }
        
        let queryParameters = ["journalDate": journalDateString, "timeZoneOffset": timeZoneOffsetString]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/statistics/journal/query",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get journal view data success \(str)")
                if let response: QueryJournalDataResponse = decodeJson(data: data) {
                    self.journalCache[journalDate] = response.data
                    completion(.success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("Get journal view data failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    
    func queryStatistics(journalDate: Date? = nil, timeFrame: StatisticsTimeFrame, username: String? = nil, completion: @escaping (ApiResult<StatisticsResponse>) -> Void) {
        Task {
            //        let dateFormatter = DateFormatter()
            //        dateFormatter.dateFormat = "YY-MM-dd"
            //        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            //        let journalDateString = dateFormatter.string(from: journalDate)
            let timeZoneOffset = TimeZone.current.secondsFromGMT() / 60
            
            let timeZoneOffsetString = String(format: "%d", timeZoneOffset)

            // TODO: this caching needs to be fixed, as now you can choose the timeFrame and the reference time (i.e. you can choose June 2020 for example)
            //        if let cachedResponse: StatisticsResponse = statisticsCache[timeFrame] {
            //            completion(.success(cachedResponse))
            //            return
            //        }

            var queryParameters = ["timeZoneOffset": timeZoneOffsetString, "timeFrame": "/\(timeFrame)"]
            if let journalDate {
                let isoDateFormatter = ISO8601DateFormatter()
                let datePlusOffset = Calendar.current.date(byAdding: .hour, value: timeZoneOffset / 60, to: journalDate)!
                let journalDateString = isoDateFormatter.string(from: datePlusOffset)
                queryParameters["date"] = journalDateString
            }
            
            if let username {
                queryParameters["userName"] = username
            }
            
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/statistics/\(timeFrame)",
                                      queryParameters: queryParameters)
            
            
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get statistics view data success: \(str)")
                if let response: QueryStatisticsDataResponse = decodeJson(data: data) {
                    self.statisticsCache[timeFrame] = response.data
                    completion(.success(response.data))
                } else {
                    guard str.count > 50 else {
                        if let journalDate {
                            let convertedDate = journalDate.plusOffset()
                            print("No Statistic for this date: \(convertedDate)")
                            completion(.success(createYearlyEmptyStat(date: convertedDate)))
                        }
                        return
                    }
                    
                    print("FAILED TO DECODE JSON")
                    completion(.failure(ApiError.invalidJSON))
                    
                }
            } catch let error as APIError {
                print("Get statistics view data failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func checkDevice(deviceId: String, interval: Int = 1, completion: @escaping (ApiResult<[SensorData]>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let today = Date()
        let date = Calendar.current.date(byAdding: .second, value: -TIME_OFFSET, to: today)!
        let dateString = formatter.string(from: date)
        let dateMinusMinuteString = formatter.string(from: Calendar.current.date(byAdding: .minute, value: -interval, to: date)!)
        let queryParameters = ["d_id": deviceId, "sTimestamp": dateMinusMinuteString, "eTimestamp": dateString]
        
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/sensor/query",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                //                let str = String(decoding: data, as: UTF8.self)
                //                print("check Device success.")
                if let response: GetSensorDataResponse = decodeJson(data: data) {
                    completion(response.data.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("check Device failure \(error)")
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func testBio(deviceId: String, interval: Int = 60, completion: @escaping (ApiResult<[SensorData]>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let today = Date()
        let date = Calendar.current.date(byAdding: .second, value: -TIME_OFFSET, to: today)!
        let dateString = formatter.string(from: date)
        //        let dateMinusMinuteString = formatter.string(from: Calendar.current.date(byAdding: .minute, value: -interval, to: date)!)
        let dateMinusMinuteString = formatter.string(from: Calendar.current.date(byAdding: .second, value: -interval, to: date)!)
        let queryParameters = ["d_id": deviceId, "sTimestamp": dateMinusMinuteString, "eTimestamp": dateString]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/sensor/query",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                //                let str = String(decoding: data, as: UTF8.self)
                //                print("check Device success.")
                if let response: GetSensorDataResponse = decodeJson(data: data) {
                    completion(response.data.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("check Device failure \(error)")
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func getGroup(u_id: String,
                  completion: @escaping (ApiResult<[GroupResponse]>) -> Void) {
        let queryParameters = ["u_id": u_id]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/groups/query/user",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get groups success \(str)")
                if let response: GetGroupResponse = decodeJson(data: data) {
                    completion(response.data.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response.data))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("Get groups failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func createGroup(name: String,
                     completion: @escaping (ApiResult<GroupResponse>) -> Void) {
        let createGroupRequest = CreateGroupRequest(groupName: name)
        
        if let requestBody = encodeJson(data: createGroupRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/groups/create",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Get group list success \(str)")
                    if let response: GroupResponse = decodeJson(data: data) {
                        completion(.success(response))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch let error as APIError {
                    print("Create group failed \(error)")
                    completion(.failure(ApiError.generalError))
                }
            }
        }
    }
    
    func deleteGroupOrUser(g_id: String, userName: String? = nil, completion: @escaping (Bool) -> Void) {
        var queryParameters: [String:String] = [:]
        if let userName {
            queryParameters["userName"] = userName
        }
        
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/groups/delete/\(g_id)",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.delete(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Delete group success \(str)")
                //                    // MARK: removing all groups from realm
                //                    ListOfMembers().deleteGroups()
                completion(true)
            } catch let error as APIError {
                print("Delete group failure \(error)")
                completion(false)
            }
        }
    }
    
    func addUserToGroup(g_id: String, u_id: String,
                        completion: @escaping (ApiResult<GroupResponse>) -> Void) {
        
        let addUserToGroupRequest = AddUserToGroupRequest(g_id: g_id, u_id: u_id)
        
        if let requestBody = encodeJson(data: addUserToGroupRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/groups/add",
                                      body: requestBody)
            
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Add \(u_id) to group \(g_id) success \(str)")
                    if let response: GroupResponse = decodeJson(data: data) {
                        completion(.success(response))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch let error as APIError {
                    print("Add \(u_id) to group \(g_id) failure \(error)")
                    completion(.failure(ApiError.generalError))
                }
            }
        }
    }
    
    func getGroupList(group_name: String,
                      completion: @escaping (ApiResult<[ApiNodeUser]>) -> Void) {
        let queryParameters = ["group": group_name]
        let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                  path: "/groups/query/group",
                                  queryParameters: queryParameters)
        
        Task {
            do {
                let data = try await Amplify.API.get(request: request)
                let str = String(decoding: data, as: UTF8.self)
                print("Get group list success \(str)")
                if let response: [ApiNodeUser] = decodeJson(data: data) {
                    completion(response.isEmpty ?
                        .failure(ApiError.notFound) :
                            .success(response))
                } else {
                    completion(.failure(ApiError.invalidJSON))
                }
            } catch let error as APIError {
                print("Get groups list failure \(error)")
                switch error {
                case .httpStatusError(let statusCode, _):
                    if statusCode == 404 {
                        completion(.failure(ApiError.notFound))
                        return
                    }
                default:
                    print("No response from server")
                }
                completion(.failure(ApiError.httpError))
            }
        }
    }
    
    func sendTestData(data: TestData,
                      completion: @escaping (ApiResult<TestData>) -> Void) {
        
        if let requestBody = encodeJson(data: data) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device_test/upload",
                                      body: requestBody)
            
            print("Test Device Body: \(String(decoding: requestBody, as: UTF8.self))")
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("Sending test data success \(str)")
                    if let response: TestDataResponse = decodeJson(data: data) {
                        completion(.success(response.item))
                    } else {
                        completion(.failure(ApiError.invalidJSON))
                    }
                } catch let error as APIError {
                    print("Send Test Data failure \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func endSleep(d_id: String, completion: @escaping (Bool) -> Void) {
        let endSleepRequest = CreateEndSleepRequest(d_id: d_id)
        
        if let requestBody = encodeJson(data: endSleepRequest) {
            let request = RESTRequest(apiName: ApiNodeServer.API_NAME,
                                      path: "/device/endSleep",
                                      body: requestBody)
            
            print("Body \(String(decoding: requestBody, as: UTF8.self))")
            Task {
                do {
                    let data = try await Amplify.API.post(request: request)
                    let str = String(decoding: data, as: UTF8.self)
                    print("End Sleep success: \(str)")
                    completion(true)
                } catch let error as APIError {
                    print("End Sleep failure \(error)")
                    completion(false)
                }
            }
        }
    }
}
