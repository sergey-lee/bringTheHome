//
//  ESPAsyncWebServer.swift
//  mellowing-factory
//
//  Created by 준녕 on 2022/04/05.
//

import Foundation

final class ESPAsyncWebServer: ObservableObject {
    let url = URL(string: "http://111.31.10.111/get_local_networks")!
    private weak var task: URLSessionTask?
    
    func getLocalWifiNetworks(completion: @escaping (ApiResult<[String]>) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading \(self.url) with error \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(ApiError.httpError))
                }
                return
            }
            
            if let result: String = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion(.success(result.components(separatedBy: ",")))
                }
            }
        }
        
        task.resume()
        self.task = task
    }
    
    func cancelRequest() {
        task?.cancel()
        print("request canceled")
    }
}
