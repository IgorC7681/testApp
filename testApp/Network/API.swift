//
//  API.swift
//  testApp
//
//  Created by Tai on 2020/10/15.
//  Copyright © 2020 Tai. All rights reserved.
//

import Foundation
import Moya


//創建TargetType對象
enum Service {
    case POST(username: String, password: String)
    case GET
}


extension Service: TargetType {
    //請求地址
    var baseURL: URL {
        return URL(string: "http://present810209.twf.node.tw")!
    }
    //請求路徑
    var path: String {
        switch self {
        case .POST:
            return "/api/login.php"
        case .GET:
            return "/api/getstockcode.php"
        }
    }
    //請求方法
    var method: Moya.Method {
        switch self {
        case .POST:
            return .post
        case .GET:
            return .get
        }
    }
    //請求任務URLSessionTask
    var task: Task {
        switch self {
        case let .POST(username, password):
            return .requestParameters(parameters: ["username": username, "password": password],encoding:URLEncoding.queryString)
        case .GET:
            return .requestPlain
        }
    }
    //提供用於測試的數據
    var sampleData: Data {
        switch self {
        case .POST:
            return Data()
        case .GET:
            return Data()
        }
    }
    //請求使用的標頭
    var headers: [String: String]? {
        switch self {
        case .POST:
            return ["Content-type": "application/x-www-form-urlencoded"]
        case .GET:
            return ["charest": "utf-8"]
        }
    }
}
// MARK: - Helpers
private extension String {
    // 由於我們在輸入網址時，有時會有中文在字串中，如果沒有加以轉換，url 會無法使用
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    //編碼設定
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
// VerbosePlugin插件
struct VerbosePlugin: PluginType {
    let verbose: Bool
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        #if DEBUG
        if let body = request.httpBody,
            let _ = String(data: body, encoding: .utf8) {
            //print("request to send: \(str))")
        }
        #endif
        return request
    }
}
