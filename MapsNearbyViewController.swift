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
    var urlString = ""
    var dataRecevie = Int()
    var locationManager = CLLocationManager()
    var latCenter = ""
    var lngCenter = ""
    var headOfUrl = ""
    var locationOfUrl = ""
    var tailOfUrl = ""
    var latDirection = Double()
    var lngDirection = Double()
    var titlePinLocation = ""
    var subtitlePinLocation = ""
    var latPinLocation = ""
    var lngPinLocation = ""
    var dataRadius = ""
    var listCheckBox = [Int]()
    var listTest = [ModelLocation]()
    var countRegionChange = 0
    
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
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        removeAnnotation()
        latCenter = String(mapView.centerCoordinate.latitude)
        lngCenter = String(mapView.centerCoordinate.longitude)
        
        choiceDataToLoadWhenUSerChangeRegion(list: listCheckBox, data: dataRecevie, lat: latCenter, lng: lngCenter)
        print("USER STOP MOVING \(countRegionChange)")
        countRegionChange = countRegionChange + 1 // done
    }
    
    func removeAnnotation(){
        let annotationsToRemove = mapsToShow.annotations.filter { $0 !== mapsToShow.userLocation }
        mapsToShow.removeAnnotations( annotationsToRemove )
    }
    
    func comeback(){
        removeAnnotation()
        let latitude:CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
        let longitude:CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        mapsToShow.setRegion(region, animated: false)
        mapsToShow.reloadInputViews()
    }

    func showNearLocationAlamoClosure(dataArray: [ModelLocation]){
        for value in dataArray {
            mapsToShow.delegate = self
            mapsToShow.showsScale = true
            mapsToShow.showsUserLocation = true
            let location = CLLocationCoordinate2D(latitude: Double(value.lat)!, longitude: Double(value.lng)!)
            let annotation = MKPointAnnotation()
            annotation.title = value.name
            annotation.subtitle = value.address
            annotation.coordinate = location
            self.mapsToShow.addAnnotation(annotation)
        }
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
            for urlValue in listTest[0..<listTest.count] {
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
    
    func choiceDataToShow(listChoice: [Int], dataRecevie: Int){
        if listChoice.count == 0{
            loadDataToShowAlamoClosure(data: dataRecevie)
            
        }else{
            for value in listChoice[0..<listChoice.count]{
                loadDataToShowAlamoClosure(data: value)
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
    
    func loadDataToShowAlamoClosure(data: Int){
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
        
        getDataAlamofireClosureView(url: urlString) { (listData) in
            self.listTest = listData
            print("aaaaaaaaaaaaaaaaaa")
            print(self.listTest.count)
            self.showNearLocationAlamoClosure(dataArray: self.listTest)
        }
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
        getDataAlamofireClosureView(url: urlString) { (listData) in
            self.listTest = listData
            print("Region change")
            print(self.listTest.count)
            self.showNearLocationAlamoClosure(dataArray: self.listTest)
        }
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
        }))
        self.present(alert, animated:  true, completion: nil)
    }
    
    func MyDetails(alert: UIAlertAction){
        performSegue(withIdentifier: "showDetailsInMap", sender: self)
    }
    
    func MyDirections(alert: UIAlertAction){
        performSegue(withIdentifier: "showDirections", sender: self)
    }

}
