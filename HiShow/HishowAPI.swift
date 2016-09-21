//
//  HishowAPI.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import Foundation
import Alamofire

public enum Reason: CustomStringConvertible {
    case networkError
    case noData
    case other(NSError?)
    
    public var description: String {
        switch self {
        case .networkError:
            return "NetworkError"
        case .noData:
            return "NoData"
        case .other(let error):
            return "Other, Error: \(error?.description)"
        }
    }
}

public typealias FailureHandler = (_ reason: Reason, _ errorMessage: String?) -> Void

public let defaultFailureHandler: FailureHandler = { reason, errorMessage in
    print("\n***************************** YepNetworking Failure *****************************")
    print("Reason: \(reason)")
    if let errorMessage = errorMessage {
        print("errorMessage: >>>\(errorMessage)<<<\n")
    }
}

//https://api.douban.com/v2/group/topic/90364216/comments
//https://api.douban.com/v2/group/topic/90364216

final class HiShowAPI {
    static let sharedInstance = HiShowAPI()
    
    func getTopics(start startIndex: Int, completion: @escaping (TopicModel) -> Void, failureHandler: FailureHandler?) {
        
        let parameters = [
            "start": "\(startIndex)",
            "count": "20"
        ]
        Alamofire.request("https://api.douban.com/v2/group/haixiuzu/topics", method: .get, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                    
                case .success(let resultValue):
                    let json = JSON(resultValue)
                    
                    //                    print(json)
                    let topicModel = TopicModel(fromJson: json)
                    
                    completion(topicModel)
                    
                case .failure:
                    failureHandler?(.networkError, "")
                    
                }
        }
    }
    
    func getUserInfo(uid userId: String, completion: @escaping (UserInfo) -> Void, failureHandler: FailureHandler?) {
        
        Alamofire.request("https://api.douban.com/v2/user/\(userId)", method: .get)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let resultValue):
                    let json = JSON(resultValue)
                    
                    let userInfo = UserInfo(fromJson: json)
                    
                    completion(userInfo)
                    
                case .failure:
                    failureHandler?(.networkError, "")
                }
        }
    }
    
    func getTopics1(_ envelopInfo: String, requestPackageInfo: String, completion: @escaping (TopicModel) -> Void, failureHandler: FailureHandler?) {
        
        let parameters = [
            "serviceid": "",
            "dataExchangePackage": "",
            "token": ""
        ]
        
        Alamofire.request("", method: .post, parameters: parameters)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let resultValue):
                    let json = JSON(resultValue)
                    
                    let topicModel = TopicModel(fromJson: json)
                    
                    completion(topicModel)
                    
                case .failure:
                    failureHandler?(.networkError, "")
                }
        }
    }
}
