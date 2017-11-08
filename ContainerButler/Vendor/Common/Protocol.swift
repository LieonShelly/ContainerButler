//
//  Protocol.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import Alamofire

protocol EndPointProtocol {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var endpoint: String { get }
    
    func URL() -> String
}

extension EndPointProtocol {
    var path: String {
        return "/keeper"
    }
    
    var baseURL: String {
        return CustomKey.URLKey.baseURL
    }
    
    func URL() -> String {
        return baseURL + path + endpoint
    }
    
}

protocol UserEndPointProtocol: EndPointProtocol { }

protocol ContentEndPointProtocol: EndPointProtocol { }

protocol FileUploadProtocol: EndPointProtocol {}

extension UserEndPointProtocol {

    var method: HTTPMethod {
        return .post
    }
}

extension ContentEndPointProtocol {
    var method: HTTPMethod {
        return .get
    }
}

extension FileUploadProtocol {
    var method: HTTPMethod {
        return .post
    }
}

protocol ViewNameReusable: class { }

extension ViewNameReusable where Self:UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}
