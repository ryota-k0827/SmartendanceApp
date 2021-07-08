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
//    var userDataList: Dictionary<String, String> = [:]
    var resultMsg = String()
    
    func getUserData(userId:String, password:String){
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
//        let url = "http://192.168.11.42/GitHub/Smartendance/login.php"
//        let headers: HTTPHeaders = [
//                    "Contenttype": "application/json"
//                ]
//        let parameters = ["userId": userId, "password": password]
//
//        //Alamofireを使ってhttpリクエストを投げる。
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            
            
        let url = "https://d679ed892352.ngrok.io/GitHub/Smartendance/login.php?userId=\(userId)&password=\(password)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                if json["resultMsg"].string == nil {
//                    self.userDataList.removeValue(forKey: "resultMsg")
//                    self.userDataList["userId"] = json["userId"].string
//                    self.userDataList["name"] = json["name"].string
//                    self.userDataList["userType"] = json["type"].string
//                    self.userDataList["classId"] = json["classId"].string
                    self.resultMsg = "ログイン成功"
                    UserDefaults.standard.set(json["userId"].string, forKey: "userId")
                    UserDefaults.standard.set(json["name"].string, forKey: "name")
                    UserDefaults.standard.set(json["type"].string, forKey: "userType")
                    UserDefaults.standard.set(json["classId"].string, forKey: "classId")
                } else {
//                    self.userDataList["resultMsg"] = json["resultMsg"].string
                    self.resultMsg = json["resultMsg"].string!
                }
                semaphore.signal()
                
//                print(self.userDataList["userId"]!)
//                print(self.userDataList["name"]!)
//                print(self.userDataList["userType"]!)
//                print(self.userDataList["classId"]!)
                
            case .failure(let error):
//                self.userDataList["resultMsg"] = String("AFエラー")
                self.resultMsg = "AFエラー"
                print("AFエラー")
                print(error)
                semaphore.signal()
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
