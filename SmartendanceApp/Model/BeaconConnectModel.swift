
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //ビーコン用の変数定義
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!

    //受信したいビーコンのUUIDを下記に記載（最大20個？）
    let UUIDList = [
        "48534442-4C45-4144-80C0-1800FFFFFFFF",
        // この数値はUUIDに応じて変更ください。
    ]

    //regionInOut...登録日時の表示
    @IBOutlet weak var dateTimeNow: UILabel!

    //regionInOut...領域内外の表示（outside/inside）
    @IBOutlet weak var regionInOut: UILabel!

    //regionNumber...ビーコン領域内外(0 or 1)の表示
    @IBOutlet weak var regionNumber: UILabel!

    //distanceBeacon...ビーコンとの距離表示
    @IBOutlet weak var distanceBeacon: UILabel!

    //UUIDの表示
    @IBOutlet weak var uuidNumber: UILabel!

    //情報の登録をするためのPHPのURL
    let URL_SAVE_DATA = "https://yourserver/MyWebService/api/recordbeacon.php"

    //日時の記録(日本時間)
    func datejapan(){
    let f = DateFormatter()
    f.dateStyle = .short
    f.timeStyle = .medium
    print(f.string(from: Date()))
    }
    //MySQLデータベースに登録するファンクション
    func Register() {
        //created NSURL
        let requestURL = URL(string: URL_SAVE_DATA)

        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL!)

        //setting the method to post
        request.httpMethod = "POST"

        //日時の記録(日本時間)
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))

        let Number = regionNumber.text
        let Now = dateTimeNow.text

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "date="+Now!+"&flag="+Number!;

        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)

        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error is \(String(describing: error))")
                return
            }

            do { //parsing the response
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //converting resonse to NSDictionary

                //parsing the json
                if let parseJSON = myJSON {

                    //creating a string
                    var msg : String!

                    //getting the json response
                    msg = parseJSON["message"] as! String?

                    //printing the response
                    print(msg)

                }
            } catch {
                print(error)
            }

        }
        //executing the task
        task.resume()

    }

    //以下、ビーコン側の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationManager = CLLocationManager()
        // バックグランドモードで使用する場合YESにする必要あり？(追加)
        myLocationManager.allowsBackgroundLocationUpdates = true;
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
    }

    private func startMyMonitoring() {
        for i in 0 ..< UUIDList.count {
            let uuid: NSUUID! = NSUUID(uuidString: "\(UUIDList[i].lowercased())")
            let identifierStr: String = "abcde\(i)"
            myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
            myBeaconRegion.notifyEntryStateOnDisplay = false
            myBeaconRegion.notifyOnEntry = true
            myBeaconRegion.notifyOnExit = true
            myLocationManager.startMonitoring(for: myBeaconRegion)
            uuidNumber.text = UUIDList[0]
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //日時の記録(日本時間)
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))
        dateTimeNow.text = f.string(from: Date())
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
        //日時の記録(日本時間)
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))
        switch (state) {
        case .inside:

            //開始：regionNumberに表示(領域内=1)
            regionNumber.text = "1"
            dateTimeNow.text = f.string(from: Date())
            regionInOut.text = "inside"

            Register()
            print("iBeacon inside")

            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
        case .outside:

            //regionNumberに表示(領域外=0)
            regionNumber.text = "0"
            dateTimeNow.text = f.string(from: Date())
            regionInOut.text = "outside"

            Register()
            print("iBeacon outside")
            break;
        case .unknown:

            //regionNumberに表示(領域外=0)
            regionNumber.text = "0"
            dateTimeNow.text = f.string(from: Date())
            regionInOut.text = "outside"

            Register()
            print("iBeacon unknown")
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
                    regionNumber.text = "0"
                    regionInOut.text = "outside"
                    break
                case CLProximity.far:
                    print("Proximity: Far");
                    proximity = "Far"
                    regionNumber.text = "1"
                    regionInOut.text = "inside"
                    break
                case CLProximity.near:
                    print("Proximity: Near");
                    proximity = "Near"
                    regionNumber.text = "1"
                    regionInOut.text = "inside"
                    break
                case CLProximity.immediate:
                    print("Proximity: Immediate");
                    proximity = "Immediate"
                    regionNumber.text = "1"
                    regionInOut.text = "inside"
                    break
                }
                beaconUuids.add(beaconUUID.uuidString)
                var myBeaconDetails = "Major: \(majorID) "
                myBeaconDetails += "Minor: \(minorID) "
                myBeaconDetails += "Proximity:\(proximity) "
                myBeaconDetails += "RSSI:\(rssi)"
                print(myBeaconDetails)
                beaconDetails.add(myBeaconDetails)
                distanceBeacon.text = proximity
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //日時の記録(日本時間)
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))
        //開始：regionNumberに表示(領域内=1)
        regionNumber.text = "1"
        dateTimeNow.text = f.string(from: Date())
        regionInOut.text = "inside"
        Register()
        print("didEnterRegion: iBeacon found");
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //日時の記録(日本時間)
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        print(f.string(from: Date()))
        //regionNumberに表示(領域外=0)
        regionNumber.text = "0"
        dateTimeNow.text = f.string(from: Date())
        regionInOut.text = "outside"
        Register()
        print("didExitRegion: iBeacon lost");
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
}
