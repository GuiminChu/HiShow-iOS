//
//  HishowAPI.swift
//  HishowZone
//
//  Created by Chu Guimin on 16/9/6.
//  Copyright © 2016年 Chu Guimin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum Reason: CustomStringConvertible {
    case NetworkError
    case NoData
    case Other(NSError?)
    
    public var description: String {
        switch self {
        case .NetworkError:
            return "NetworkError"
        case .NoData:
            return "NoData"
        case .Other(let error):
            return "Other, Error: \(error?.description)"
        }
    }
}

public typealias FailureHandler = (reason: Reason, errorMessage: String?) -> Void

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
    
    func getTopics(start startIndex: Int, completion: TopicModel -> Void, failureHandler: FailureHandler?) {
        
        let parameters = [
            "start": "\(startIndex)",
            "count": "20"
        ]
        
        Alamofire.request(.GET, "https://api.douban.com/v2/group/haixiuzu/topics", parameters: parameters)
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let resultValue):
                    let json = JSON(resultValue)
                    
//                    print(json)
                    let topicModel = TopicModel(fromJson: json)
                    
                    completion(topicModel)
                    
                case .Failure:
                    failureHandler?(reason: .NetworkError, errorMessage: "")
                }
        }
    }
    
    func getUserInfo(uid userId: String, completion: UserInfo -> Void, failureHandler: FailureHandler?) {
        
        Alamofire.request(.GET, "https://api.douban.com/v2/user/\(userId)")
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let resultValue):
                    let json = JSON(resultValue)
                    
                    let userInfo = UserInfo(fromJson: json)
                    
                    completion(userInfo)
                    
                case .Failure:
                    failureHandler?(reason: .NetworkError, errorMessage: "")
                }
        }
    }
    
    func getTopics1(envelopInfo: String, requestPackageInfo: String, completion: TopicModel -> Void, failureHandler: FailureHandler?) {
        
        let parameters = [
            "serviceid": "",
            "dataExchangePackage": "",
            "token": ""
        ]
        
        Alamofire.request(.POST, "", parameters: parameters)
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let resultValue):
                    let json = JSON(resultValue)
                    
                    let topicModel = TopicModel(fromJson: json)
                    
                    completion(topicModel)
                    
                case .Failure:
                    failureHandler?(reason: .NetworkError, errorMessage: "")
                }
        }
    }
}
