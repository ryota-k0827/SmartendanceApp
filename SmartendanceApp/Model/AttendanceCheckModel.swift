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
    var absenceNumber: [String] = []
    var absenceName: [String] = []
    var resultMsg = ""
    
    func attendanceProcess(classRoom:String){
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
            
            
        let url = "http://ryotakaneko.php.xdomain.jp/Smartendance/attendance_confirmation.php?class_room=\(classRoom)"
        
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
                    
                    for (key, value) in json["absenteeNumber"] {
                        self.absenceNumber.append("\(value)")
                        let name = json["absenteeName"][Int(key)!]
                        self.absenceName.append("\(name)")
                    }
                    
                    
                } else {
                    self.resultMsg = json["result"].string!
                }
                semaphore.signal()
                
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
