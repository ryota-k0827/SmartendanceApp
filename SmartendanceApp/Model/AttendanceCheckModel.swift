//
//  AttendanceCheckModel.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/13.
//

import Foundation
import Alamofire
import SwiftyJSON

class AttendanceCheck{
    
    //出席情報を格納
    var attendanceDataList: Dictionary<String, String> = [:];
    var resultMsg = ""
    
    func attendanceProcess(classRoom:String){
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
            
            
        let url = "https://06392f6d0b82.ngrok.io/GitHub/Smartendance/attendance_confirmation.php?class_room=\(classRoom)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                if json["result"].string == nil {
                    self.resultMsg = ""
                    self.attendanceDataList["classRoomNumber"] = json["classRoomNumber"].string
                    self.attendanceDataList["classSymbol"] = json["classSymbol"].string
                    self.attendanceDataList["subject"] = json["subject"].string
                    self.attendanceDataList["number_of_attendees"] = json["number_of_attendees"].string
                    self.attendanceDataList["class_size"] = json["class_size"].string
                    self.attendanceDataList["absenteeNumber"] = json["absenteeNumber"].string
                    self.attendanceDataList["absenteeName"] = json["absenteeName"].string
                } else {
                    self.resultMsg = json["result"].string!
                }
                semaphore.signal()
                
//                print(self.userDataList["userId"]!)
//                print(self.userDataList["name"]!)
//                print(self.userDataList["userType"]!)
//                print(self.userDataList["classId"]!)
                
            case .failure(let error):
                self.resultMsg = "AFエラー"
                print("AFエラー")
                print(error)
                semaphore.signal()
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
