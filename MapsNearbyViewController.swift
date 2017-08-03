//
//  MapsNearbyViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 7/28/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
// 
// ok ok ok
import UIKit
import MapKit
import CoreLocation

class MapsNearbyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapsToShow: MKMapView!
    var dataMapsType = Int()
    var urlString = ""
    var dataRecevie = Int()
    var locationManager = CLLocationManager()
    var latCenter = ""
    var lngCenter = ""
    var headOfUrl = ""
    var locationOfUrl = ""
    var tailOfUrl = ""
    var url = ""
    var listToShow = [ModelOfDirec]()
    var annotations = [MKAnnotation]()
    var listToSendTableDetail = [ModelOfDirec]()

    var latDirection = Double()
    var lngDirection = Double()
    var titlePinLocation = ""
    var subtitlePinLocation = ""
    var latPinLocation = ""
    var lngPinLocation = ""
    var urlChoice = ""
    var urlToShow = ""
    var listCheckBox = [Int]()
    var count = 0 // test did animataion

    private var mapChangedFromUserInteraction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapsToShow.delegate = self
        mapsToShow.showsCompass = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Your Location", style: .plain, target: self, action: #selector(MapsNearbyViewController.comeback) )
        //loadData()
        choiceDataToShow(listChoice: listCheckBox, dataRecevie: dataRecevie)
    }
    // new key
    // AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction){
            latCenter = String(mapView.centerCoordinate.latitude)
            lngCenter = String(mapView.centerCoordinate.longitude)
            print("stop move")
            print("lat: \(latCenter), Lng: \(lngCenter)")
            loadDataregionDidChange(lat: latCenter, lng: lngCenter) // heraaaaaaaaa
        }
        
        print("STOP MOVE ALL \(count)")
        count = count + 1 // need fix
        
    }
    
    func removeAnnotation(){
        let annotationsToRemove = mapsToShow.annotations.filter { $0 !== mapsToShow.userLocation }
        mapsToShow.removeAnnotations( annotationsToRemove )
    }
    
    func comeback(){
        removeAnnotation()
        //loadData()
        choiceDataToShow(listChoice: listCheckBox, dataRecevie: dataRecevie)
        mapsToShow.reloadInputViews()
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if !(annotation is MKUserLocation) {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .detailDisclosure)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            pinView?.pinTintColor = UIColor.red
            pinView?.isEnabled = true
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = rightButton
            switch dataRecevie{
                case 0:
                    url = "https://www.shareicon.net/data/512x512/2016/08/05/807064_knife_512x512.png"
                case 1:
                    url = "https://www.shareicon.net/data/512x512/2015/11/01/665295_medical_512x512.png"
                case 2:
                    url = "https://www.shareicon.net/data/512x512/2016/09/23/833197_school_512x512.png"
                case 3:
                    url = "https://www.shareicon.net/data/512x512/2016/08/19/816747_hotel_512x512.png"
                case 4:
                    url = "https://www.shareicon.net/data/512x512/2016/09/21/831298_business_512x512.png"
                case 5:
                    url = "https://www.shareicon.net/data/128x128/2016/04/25/501800_refresh_40x40.png"
                case 6:
                    url = "https://www.shareicon.net/data/512x512/2015/12/14/687106_service_512x512.png"
                default:
                    url = "https://www.shareicon.net/data/512x512/2015/12/14/687106_service_512x512.png"
            }
//            if listCheckBox.count == 0{
//                url = choiceUrlImage(data: dataRecevie)
//            }else{
//                for value in listCheckBox[0..<listCheckBox.count]{
//                    url = choiceUrlImage(data: value)
//                }
//            }
            imageView.image = UIImage(imageView.downLoadFromUrlDemoSimple(urlSimple: url))
            pinView?.leftCalloutAccessoryView = imageView
            
            
            return pinView
        }
        else {
            return nil
        }
    }
    // key API
    //AIzaSyCv4yTcccoPiEoL76MBX__VHMlZtDHGx-U
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapsToShow.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if(recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func showNearLocation(lat: Double, lng: Double, name: String, address: String){
        mapsToShow.delegate = self
        mapsToShow.showsScale = true
        mapsToShow.showsUserLocation = true
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: location, span: span)
        mapsToShow.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.subtitle = address
        annotation.coordinate = location
        annotations.append(annotation)
    
    }
    func showData(array: [ModelOfDirec]) {
        for i in 0..<array.count {
            showNearLocation(lat: Double(array[i].lat), lng: Double(array[i].lng), name: array[i].name, address: array[i].vicinity)
        }
        
    }
    func choiceDataToShow(listChoice: [Int], dataRecevie: Int){
        if listChoice.count == 0{
            loadData(data: dataRecevie)
        }else{
            for value in listChoice[0..<listChoice.count]{
                loadData(data: value)
            }
        }
    }
    
    func choiceUrlImage(data: Int) -> String{
        switch data{
        case 0:
            urlChoice = "https://www.shareicon.net/data/512x512/2016/08/05/807064_knife_512x512.png"
        case 1:
            urlChoice = "https://www.shareicon.net/data/512x512/2015/11/01/665295_medical_512x512.png"
        case 2:
            urlChoice = "https://www.shareicon.net/data/512x512/2016/09/23/833197_school_512x512.png"
        case 3:
            urlChoice = "https://www.shareicon.net/data/512x512/2016/08/19/816747_hotel_512x512.png"
        case 4:
            urlChoice = "https://www.shareicon.net/data/512x512/2016/09/21/831298_business_512x512.png"
        case 5:
            urlChoice = "https://www.shareicon.net/data/128x128/2016/04/25/501800_refresh_40x40.png"
        case 6:
            urlChoice = "https://www.shareicon.net/data/512x512/2015/12/14/687106_service_512x512.png"
        default:
            urlChoice = "https://www.shareicon.net/data/512x512/2015/12/14/687106_service_512x512.png"
        }
        //print(urlChoice)
        return urlChoice
    }
    
    func loadData(data: Int) {

        switch data {
        case 0:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=2000&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 1:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=2000&type=hospital&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 2:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=2000&type=school&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 3:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=2000&type=hotel&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 4:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=5000&type=museum&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 5:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=5000&type=atm&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 6: urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=5000&type=gas_station&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        default:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=2000&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        }
        print(urlString)
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Some thing Wrong")
            } else
            {
                OperationQueue.main.addOperation{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    guard let topApps = TopApps(json: parsedData) else {return}
                    guard let appItem = topApps.results  else {return}
                    self.annotations.removeAll()
                    for i in 0..<appItem.count {
                        self.showNearLocation(lat: Double(appItem[i].lat), lng: Double(appItem[i].lng), name: appItem[i].name, address: appItem[i].vicinity)
                        //self.showNearLocation(lat: ), lng: Double(), name: , address: appItem[i].vicinity)
                    }
                    self.mapsToShow.addAnnotations(self.annotations)
                } catch let error as NSError {
                    print(error)
                }
                catch let someError as NSException{
                    print(someError)
                }
               //self.showData(array: self.listToShow)
                }
            }
            }.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadDataregionDidChange(lat: String, lng: String) {
        removeAnnotation()
        switch dataRecevie {
        case 0:
            
            tailOfUrl = "&radius=2000&type=restaurant&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 1:
            tailOfUrl = "&radius=2000&type=hospital&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 2:
            tailOfUrl = "&radius=2000&type=school&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 3:
            tailOfUrl = "&radius=2000&type=hotel&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 4:
            tailOfUrl = "&radius=5000&type=museum&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 5:
            tailOfUrl = "&radius=5000&type=atm&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 6:
            tailOfUrl = "&radius=5000&type=gas_station&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        default:
            tailOfUrl = "&radius=2000&type=restaurant&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        }
        headOfUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
        locationOfUrl = "\(lat)" + "," + "\(lng)"
        urlString = headOfUrl + locationOfUrl + tailOfUrl
        print(urlString)
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Some thing Wrong ")
            } else
            {
                OperationQueue.main.addOperation{
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                        guard let topApps = TopApps(json: parsedData) else {return}
                        guard let appItem = topApps.results  else {return}
                        self.annotations.removeAll()
                        for i in 0..<appItem.count {
                            self.showNearLocation(lat: Double(appItem[i].lat), lng: Double(appItem[i].lng), name: appItem[i].name, address: appItem[i].vicinity)
                        }
                        self.mapsToShow.addAnnotations(self.annotations)
                    } catch let error as NSError {
                        print(error)
                    }
                    catch let someError as NSException{
                        print(someError)
                    }
                }
            }
            }.resume()
            }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            makeChoice(title: "More Details")
            titlePinLocation = (view.annotation?.title!)!
            subtitlePinLocation = (view.annotation?.subtitle!)!
            latPinLocation = String(describing: (view.annotation?.coordinate.latitude)!)
            lngPinLocation = String(describing: (view.annotation?.coordinate.longitude)!)
            latDirection = Double((view.annotation?.coordinate.latitude)!)
            lngDirection = Double((view.annotation?.coordinate.longitude)!)
            print("Button right was tapped")
        }
        if control == view.leftCalloutAccessoryView {
            print("User press at image")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailsInMap"){
            let secondViewController = segue.destination as! ShowDetailInMapsTableViewController
            secondViewController.titlePinLocation = self.titlePinLocation
            secondViewController.subtitlePinLocation = self.subtitlePinLocation
            secondViewController.latPinLocation = self.latPinLocation
            secondViewController.lngPinLocation = self.lngPinLocation
        }
        if (segue.identifier == "showDirections"){
            let nextViewController = segue.destination as! DirectionViewController
            nextViewController.latDirection = self.latDirection
            nextViewController.lngDirection = self.lngDirection
        }
    }
    
    func makeChoice(title: String){
        //var numchoice = 0
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Details", style: .default, handler: MyDetails))
        alert.addAction(UIAlertAction(title: "Direction", style: .default, handler: MyDirections))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("User cancel")
        }))
        self.present(alert, animated:  true, completion: nil)


    }
    func MyDetails(alert: UIAlertAction){
        performSegue(withIdentifier: "showDetailsInMap", sender: self)
        print("Choice details")
    }
    func MyDirections(alert: UIAlertAction){
        performSegue(withIdentifier: "showDirections", sender: self)
        print("Choice directions")
    }

}
