//
//  Requests.swift
//  AjarisUploader
//
//  Created by user163559 on 3/27/20.
//  Copyright © 2020 Mistale Software. All rights reserved.
//

import Foundation

class RequestAPI {
    public static let UPCHECK: String = "/upCheck.do"
    public static let UPLOGIN: String = "/upLogin.do"
    public static let SETIMPORTCONFIG: String = "/upSetImportConfig.do"
    
    public static func checkUrl(url: String, finished: @escaping (_ result: Data)->()) {
        let urlRequest = URL(string: url + RequestAPI.UPCHECK)!
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                finished(Data())
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                finished(Data())
                return
            }
            
            finished(data ?? Data())
        }

        task.resume()
    }
    
    public static func login(url: String, login: String, pwd: String, finished: @escaping (_ result: Data)->()) {
        let urlRequest = URL(string: url + RequestAPI.UPCHECK + "?pseudo=" + login + "&password=" + pwd + "&ajaupmo=ajaupmo")!
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                finished(Data())
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                finished(Data())
                return
            }
            
            finished(data ?? Data())
        }

        task.resume()
        
    }
    
}
