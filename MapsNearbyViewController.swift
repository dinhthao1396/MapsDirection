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
import Alamofire
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
    var listToShow = [ModelOfAnnotationView]()
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
    var dataRadius = ""
    var listCheckBox = [Int]()
    var listAlamo = [ModelAlamofire]()
    var count = 0 // test did animataion

    private var mapChangedFromUserInteraction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapsToShow.delegate = self
        mapsToShow.showsCompass = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Your Location", style: .plain, target: self, action: #selector(MapsNearbyViewController.comeback) )
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        let latitude:CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
        let longitude:CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        mapsToShow.setRegion(region, animated: false)
        //choiceDataToShow(listChoice: listCheckBox, dataRecevie: dataRecevie)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        latCenter = String(mapView.centerCoordinate.latitude)
        lngCenter = String(mapView.centerCoordinate.longitude)
        choiceDataToLoadWhenUSerChangeRegion(list: listCheckBox, data: dataRecevie, lat: latCenter, lng: lngCenter)
        
        print("STOP MOVE ALL \(count)")
        count = count + 1 // need fix
    }
    
    func removeAnnotation(){
        let annotationsToRemove = mapsToShow.annotations.filter { $0 !== mapsToShow.userLocation }
        mapsToShow.removeAnnotations( annotationsToRemove )
    }
    
    func comeback(){
        removeAnnotation()
        choiceDataToShow(listChoice: listCheckBox, dataRecevie: dataRecevie)
        mapsToShow.reloadInputViews()
    }
    func showNearLocationAlamo(dataArray: (ModelAlamofire)){
        mapsToShow.delegate = self
        mapsToShow.showsScale = true
        mapsToShow.showsUserLocation = true
        //let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let location = CLLocationCoordinate2D(latitude: Double(dataArray.lat)!, longitude: Double(dataArray.lng)!)
       // let region = MKCoordinateRegion(center: location, span: span)
        //mapsToShow.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.title = dataArray.name
        annotation.subtitle = dataArray.address
        annotation.coordinate = location
        annotations.append(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if !(annotation is MKUserLocation) {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let rightButton = UIButton(type: .detailDisclosure)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            pinView?.pinTintColor = UIColor.red
            pinView?.isEnabled = true
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = rightButton            
            for urlValue in listAlamo[0..<listAlamo.count] {
                let url = urlValue.urlImage
                imageView.image = UIImage(imageView.downLoadFromUrlDemoSimple(urlSimple: url))
                pinView?.leftCalloutAccessoryView = imageView
            }
            return pinView
        }
        else {
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapsToShow.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if(recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func choiceDataToShow(listChoice: [Int], dataRecevie: Int){
        if listChoice.count == 0{
            loadDataToShowAlamo(data: dataRecevie)
        }else{
            for value in listChoice[0..<listChoice.count]{
                loadDataToShowAlamo(data: value)
            }
        }
    }
    
    func choiceDataToLoadWhenUSerChangeRegion(list: [Int], data: Int , lat: String, lng: String ){
        if list.count == 0{
            loadDataregionDidChange(lat: lat, lng: lng, data: data)
        }else{
            for value in list[0..<list.count]{
                loadDataregionDidChange(lat: lat, lng: lng, data: value)
            }
        }
    }
    
    func loadDataAlamo(url: String){
        
        Alamofire.request(url)
            .validate()
            .responseJSON{ response in
                
                if response.result.isSuccess {
                    print("JSON Link Available")
                }
                OperationQueue.main.addOperation{
                if let jsonData = response.result.value as? [String: Any] {
                    if  let results = jsonData["results"] as? [[String: Any]]{
                        self.annotations.removeAll()
                            for value in results[0..<results.count] {
                                let data = ModelAlamofire(JSON: value)
                                self.showNearLocationAlamo(dataArray: data!)
                                let dataNameAdd = ModelAlamofire(JSON: value)
                                self.listAlamo.append(dataNameAdd!)
                            }
                        self.mapsToShow.addAnnotations(self.annotations)
                    }
                }
            }
        }
    }
    
    func loadDataToShowAlamo(data: Int){
        switch data {
        case 0:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 1:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=hospital&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 2:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=school&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 3:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=hotel&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 4:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=museum&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 5:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=atm&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 6:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=gas_station&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        default:
            urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        }
        
        loadDataAlamo(url: urlString)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadDataregionDidChange(lat: String, lng: String, data: Int) {
        removeAnnotation()
        switch data {
        case 0:
            
            tailOfUrl = "&radius=\(dataRadius)&type=restaurant&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 1:
            tailOfUrl = "&radius=\(dataRadius)&type=hospital&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 2:
            tailOfUrl = "&radius=\(dataRadius)&type=school&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 3:
            tailOfUrl = "&radius=\(dataRadius)&type=hotel&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 4:
            tailOfUrl = "&radius=\(dataRadius)&type=museum&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        case 5:
            tailOfUrl = "&radius=\(dataRadius)&type=atm&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        case 6:
            tailOfUrl = "&radius=\(dataRadius)&type=gas_station&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
        default:
            tailOfUrl = "&radius=\(dataRadius)&type=restaurant&key=AIzaSyCGqb3PPJHUacR5SywBgNUQPbaHaSoMqUk"
        }
        headOfUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
        locationOfUrl = "\(lat)" + "," + "\(lng)"
        urlString = headOfUrl + locationOfUrl + tailOfUrl
        print(urlString)
        loadDataAlamo(url: urlString)
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
