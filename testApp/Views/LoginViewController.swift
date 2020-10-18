//
//  LoginViewController.swift
//  testApp
//
//  Created by Tai on 2020/10/15.
//  Copyright © 2020 Tai. All rights reserved.
//

import UIKit
import Moya

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userAccount: UITextField!
    @IBOutlet weak var userPassword: UITextField!
        
    var testStatusCode:String = ""
    var testStatusMsg:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(sender: UIButton) {
        let provider = MoyaProvider<Service>()
        provider.request(.POST(username: userAccount.text!, password: userPassword.text!)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    //取得json資料，轉型
                    let json = try filteredResponse.mapJSON() as! Dictionary<String,Any>
                    //取的json裡面的 sysMsg & sysCode 資料，轉型
                    let msg = json["sysMsg"] as! String
                    let code = json["sysCode"] as AnyObject
                    //各自儲存成String，判別條件
                    self.testStatusMsg = msg
                    self.testStatusCode = code as! String
                    ///登入分析，暫時先設定 203 也可以登入，資料正確後需改回 200
                    if self.testStatusCode == "\(203)" {
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "test")
                        self.present(viewController, animated: true, completion: nil)
                    } else {
                        ///message後面的( + "success")資料正確後需刪除
                        let controller = UIAlertController(title: "輸入錯囉！", message: self.testStatusMsg + "success", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        controller.addAction(okAction)
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                catch _ {
                }
            case .failure(_): break
            }
        }
    }
}
