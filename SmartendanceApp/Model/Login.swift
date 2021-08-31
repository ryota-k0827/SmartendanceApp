//
//  Login.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

class Login{
    //ログイン情報を格納
    var resultMsg = String()
    
    func getUserData(userId:String, password:String){
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
            
            
        /**
         API URL
         login.php
         */
        let url = "http://ryotakaneko.php.xdomain.jp/Smartendance/login.php?userId=\(userId)&password=\(password)"

        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                
                if json["resultMsg"].string == nil {
                    self.resultMsg = "ログイン成功"
                    UserDefaults.standard.set(json["userId"].string, forKey: "userId")
                    UserDefaults.standard.set(json["name"].string, forKey: "name")
                    UserDefaults.standard.set(json["type"].string, forKey: "userType")
                    UserDefaults.standard.set(json["classId"].string, forKey: "classId")
                } else {
                    self.resultMsg = json["resultMsg"].string!
                }
                semaphore.signal()
                
            case .failure(_):
                self.resultMsg = "サーバーが応答していません。"
                semaphore.signal()
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
