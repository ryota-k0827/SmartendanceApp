import UIKit
import CoreLocation

class BeaconSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    //ビーコン用の変数定義
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!
    
    var attendanceModel = Attendance()
    
    var roomNumberText = String()

    //受信したいビーコンのUUIDを下記に記載（最大20個？）
    var beaconUUID = String()
        // この数値はUUIDに応じて変更ください。
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var roadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    //情報の登録をするためのPHPのURL
    let URL_SAVE_DATA = "https://yourserver/MyWebService/api/recordbeacon.php"

    //日時の記録(日本時間)
    func datejapan(){
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))
    }


    //以下、ビーコン側の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButtonOutlet.layer.cornerRadius = 10.0
        
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        roomNumberLabel.text = roomNumberText
        roadIndicator.startAnimating()
        
        myLocationManager = CLLocationManager()
        // バックグランドモードで使用する場合YESにする必要あり？(追加)
        //myLocationManager.allowsBackgroundLocationUpdates = true;
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 1
        let status = CLLocationManager.authorizationStatus()
        print("CLAuthorizedStatus: \(status.rawValue)");
        if(status == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0, execute: {
            let dialog = UIAlertController(title: "タイムアウト", message: "ビーコンが検出されませんでした。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                //ビーコン探索停止処理
                self.myLocationManager = CLLocationManager()
                self.myLocationManager.stopMonitoring(for: self.myBeaconRegion)
                //画面遷移
                self.performSegue(withIdentifier: "backMyPage", sender: nil)
            }))
            self.present(dialog, animated: true, completion: nil)
        })
    }
    
    @IBAction func stopButton(_ sender: Any) {
        //ビーコン探索停止処理
        myLocationManager = CLLocationManager()
        myLocationManager.stopMonitoring(for: myBeaconRegion)
        //画面遷移
        performSegue(withIdentifier: "backMyPage", sender: nil)
    }
    

    private func startMyMonitoring() {
        let uuid: NSUUID! = NSUUID(uuidString: "\(beaconUUID.lowercased())")
        let identifierStr: String = "abcde\(1)"
        myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
        myBeaconRegion.notifyEntryStateOnDisplay = false
        myBeaconRegion.notifyOnEntry = true
        myBeaconRegion.notifyOnExit = true
        myLocationManager.startMonitoring(for: myBeaconRegion)
        print("UUID：" + beaconUUID)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        switch (status) {
        case .notDetermined:
            print("not determined")
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .authorizedAlways:
            print("authorizedAlways")
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            startMyMonitoring()
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region);
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        switch (state) {
        case .inside:

            //開始：(領域内=1)
            //regionNumber.text = "1"
            //print(f.string(from: Date()))
            print("ビーコンの領域内")

            //ビーコン探索停止処理
            myLocationManager = CLLocationManager()
            myLocationManager.stopMonitoring(for: myBeaconRegion)
            //出席処理
            attendanceModel.attendanceProcess(classRoom: roomNumberText, userId: (UserDefaults.standard.object(forKey: "userId") as! String), classId: (UserDefaults.standard.object(forKey: "classId") as! String))
            if attendanceModel.attendanceDataList["resultMsg"] == "AFエラー" {
                let dialog = UIAlertController(title: "エラー", message: attendanceModel.attendanceDataList["resultMsg"], preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: {
                    (action:UIAlertAction!) -> Void in
                    //ビーコン探索停止処理
                    self.myLocationManager = CLLocationManager()
                    self.myLocationManager.stopMonitoring(for: self.myBeaconRegion)
                    //画面遷移
                    self.performSegue(withIdentifier: "backMyPage", sender: nil)
                }))
                self.present(dialog, animated: true, completion: nil)
            } else {
                //画面遷移
                performSegue(withIdentifier: "nextAttendanceComplete", sender: nil)
            }

            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
        case .outside:

            //(領域外=0)
            //regionNumber.text = "0"
            //print(f.string(from: Date()))
            print("ビーコンの領域外")

            //Register()
            break;
        case .unknown:

            //regionNumberに表示(領域外=0)
            //regionNumber.text = "0"
            //print(f.string(from: Date()))
            print("ビーコンが見つかりません！")

            //Register()
            break;
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
        if(beacons.count > 0){
            for i in 0 ..< beacons.count {
                let beacon = beacons[i]
                let beaconUUID = beacon.proximityUUID;
                let minorID = beacon.minor;
                let majorID = beacon.major;
                let rssi = beacon.rssi;
                var proximity = ""
                switch (beacon.proximity) {
                case CLProximity.unknown :
                    print("Proximity: Unknown");
                    proximity = "Unknown"
                    //regionNumber.text = "0"
                    print("ビーコンの領域外")
                    break
                case CLProximity.far:
                    print("Proximity: Far");
                    proximity = "Far"
                    //regionNumber.text = "1"
                    print("ビーコンの領域内")
                    break
                case CLProximity.near:
                    print("Proximity: Near");
                    proximity = "Near"
                    //regionNumber.text = "1"
                    print("ビーコンの領域内")
                    break
                case CLProximity.immediate:
                    print("Proximity: Immediate");
                    proximity = "Immediate"
                    //regionNumber.text = "1"
                    print("ビーコンの領域内")
                    break
                }
                beaconUuids.add(beaconUUID.uuidString)
                var myBeaconDetails = "Major: \(majorID) "
                myBeaconDetails += "Minor: \(minorID) "
                myBeaconDetails += "Proximity:\(proximity) "
                myBeaconDetails += "RSSI:\(rssi)"
                print(myBeaconDetails)
                beaconDetails.add(myBeaconDetails)
                print("ビーコンとの距離：" + proximity)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //開始：regionNumberに表示(領域内=1)
        //regionNumber.text = "1"
        print("ビーコンの領域内")
        
        if attendanceModel.attendanceDataList["resultMsg"] == "AFエラー" {
            let dialog = UIAlertController(title: "エラー", message: attendanceModel.attendanceDataList["resultMsg"], preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                //ビーコン探索停止処理
                self.myLocationManager = CLLocationManager()
                self.myLocationManager.stopMonitoring(for: self.myBeaconRegion)
                //画面遷移
                self.performSegue(withIdentifier: "backMyPage", sender: nil)
            }))
            self.present(dialog, animated: true, completion: nil)
        } else {
            //画面遷移
            performSegue(withIdentifier: "nextAttendanceComplete", sender: nil)
        }
        
        print("didEnterRegion: iBeacon found");
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //regionNumberに表示(領域外=0)
        //regionNumber.text = "0"
        print("ビーコンの領域外")
        //Register()
        print("didExitRegion: iBeacon lost");
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    //画面遷移で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "nextAttendanceComplete" {
            let nextVC = segue.destination as! AttendanceCompleteViewController

            nextVC.attendanceDataList = attendanceModel.attendanceDataList
        }
    }
}

