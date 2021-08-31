import UIKit
import CoreLocation
import Lottie

class BeaconSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    //ビーコン用の変数定義
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!
    
    var attendanceModel = Attendance()
    
    var roomNumberText = String()

    //受信したいビーコンのUUID
    var beaconUUID = String()
    
    //AnimationViewの宣言
    var animationView = AnimationView()
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    

    //以下、ビーコン側の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンを丸くする
        stopButtonOutlet.layer.cornerRadius = 10.0
        
        //ラベルに値を代入
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        roomNumberLabel.text = roomNumberText
        
        let animationView = AnimationView(name: "beacon")
        animationView.frame = CGRect(x: 0, y: 380, width: view.frame.size.width, height: view.frame.size.height / 4)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        myLocationManager = CLLocationManager()
        // バックグランドモードで使用する場合YESにする必要あり？(追加)
        //myLocationManager.allowsBackgroundLocationUpdates = true;
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 1
        let status = CLLocationManager.authorizationStatus()
        if(status == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
        
        //タイムアウト（60秒）処理====================================================================================================
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
        //=========================================================================================================================
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
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
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
            
            //ビーコン接続後処理================================================================================================================================

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
            //==============================================================================================================================================

            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
        //ビーコンの領域外
        case .outside:
            break;
        case .unknown:
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
                //ビーコンの領域外
                case CLProximity.unknown :
                    proximity = "Unknown"
                    break
                //ビーコンの領域内
                case CLProximity.far:
                    proximity = "Far"
                    break
                //ビーコンの領域内
                case CLProximity.near:
                    proximity = "Near"
                    break
                //ビーコンの領域内
                case CLProximity.immediate:
                    proximity = "Immediate"
                    break
                }
                beaconUuids.add(beaconUUID.uuidString)
                var myBeaconDetails = "Major: \(majorID) "
                myBeaconDetails += "Minor: \(minorID) "
                myBeaconDetails += "Proximity:\(proximity) "
                myBeaconDetails += "RSSI:\(rssi)"
                beaconDetails.add(myBeaconDetails)
            }
        }
    }

    ////ビーコンの領域外
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }

    //ビーコンの領域外
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
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

