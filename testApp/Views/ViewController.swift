//
//  ViewController.swift
//  testApp
//
//  Created by Tai on 2020/10/14.
//  Copyright © 2020 Tai. All rights reserved.
//


import Foundation
import UIKit
import Moya

//JSON數據格式化
private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var codeArray = [String]()
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
    }
    
    
    func callApi() {
        let provider = MoyaProvider<Service>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))])
        provider.request(.GET) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    //取得json資料，轉型
                    let jsonData = try filteredResponse.mapJSON() as! Dictionary<String,Any>
                    //取的json裡面的data資料，轉型
                    let dataArray = jsonData["data"] as! [Any]
                    //迴圈stockcode & stockname 各自儲存成String的Array
                    for (_, element) in dataArray.enumerated() {
                        let e = element as! Dictionary<String, String>
                        self.codeArray.append(e["stockcode"]!)
                        self.nameArray.append(e["stockname"]!)
                    }
                    self.tableView.reloadData()
                }
                catch _ {
                }
            case .failure(_): break
            }
        }
    }
}

// MARK: - UITableView Delegate & Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataTableViewCell
        //儲存成列表顯示
        let codeList = codeArray[indexPath.row]
        let nameList = nameArray[indexPath.row]
        cell.stockCodeLabel.text = codeList
        cell.stockNameLabel.text = nameList
        return cell
    }
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
