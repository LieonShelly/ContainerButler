//
//  Router.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import Alamofire
import ObjectMapper

enum Router: URLRequestConvertible {
    case endpoint(EndPointProtocol, param: Mappable?)
    case upload(endpoint: EndPointProtocol)
    
    var param: Mappable? {
        switch self {
        case .endpoint(_, let param):
            return param
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .endpoint(let path, param: _):
            return path.method
        case .upload(endpoint: let path):
            return path.method
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .endpoint(let path, param: let param):
            var params: [String: Any] = [:]
            
            if let dic = param?.toJSON(), !dic.isEmpty {
                for (key, value) in dic {
                    params[key] = value
                }
            }
            let result: (path: String, parameters: [String: Any]?) = (path.URL(), params)
            let URL = Foundation.URL(string: result.path)!
            var URLRequest = Foundation.URLRequest(url: URL)
            URLRequest.timeoutInterval = 10
            URLRequest.httpMethod = path.method.rawValue
            if path.method == .post {
                return try JSONEncoding.default.encode(URLRequest, with: result.parameters).urlRequest!
            } else if path.method == .get {
                print("Get Param:\(result.parameters ?? [:])")
                return try URLEncoding.queryString.encode(URLRequest, with: result.parameters)
            } else {/// default is post
                return try JSONEncoding.default.encode(URLRequest, with: result.parameters).urlRequest!
            }
        case .upload(endpoint: let path):
            guard let head = Header().toJSON() as? [String: String] else {
                return Foundation.URLRequest(url: Foundation.URL(string: "")!)
            }
            let URL = Foundation.URL(string: path.URL())!
            var URLRequest = Foundation.URLRequest(url: URL)
            URLRequest.httpMethod = path.method.rawValue
            head.forEach { (key, value) in
                URLRequest.setValue(value, forHTTPHeaderField: key)
            }
            return try JSONEncoding.default.encode(URLRequest, with: nil).urlRequest!
        }
    }
}
