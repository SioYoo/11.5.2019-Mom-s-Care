//
//  FourthViewController.swift
//  mom's care
//
//  Created by Daniel Dz on 4/4/19.
//  Copyright © 2019 Daniel Dz. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseDatabase
import CoreLocation

//import Firebase

class FourthViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, GMSAutocompleteFetcherDelegate{
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */

    @IBOutlet weak var googleMapsContainer: UIView!
    
    @IBAction func findParantRoom(_ sender: Any) {
//            self.addMarker()
        let alertController = UIAlertController(title: "Mom's Care", message: "You can find the nearest Hopital and Parenting Room on the map", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Parenting Room", style: .default) { (action:UIAlertAction) in
            self.addMarker();
        }
        
        let action2 = UIAlertAction(title: "Hospital", style: .default) { (action:UIAlertAction) in
            self.calculateDistance()
            if self.nearestlonArray.count != 0{
                self.addHosMarker()
            }
            else{
                let alert = UIAlertController(title: "Sorry", message: "There is no hospital in your area", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the destructive");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    let previewDemoData = [(title: "Mom's Care Demo", img: #imageLiteral(resourceName: "img"), rate: 10), (title: "Mom's Care Demo", img: #imageLiteral(resourceName: "img"), rate: 8), (title: "Mom's Care Demo", img: #imageLiteral(resourceName: "img"), rate: 12)]
    
    //var ref: DatabaseReference!
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var dataFromFirebaseArray = [String]()
    var latArray = [Double]()
    var lonArray = [Double]()
    var HoslatArray = [Double]()
    var HoslonArray = [Double]()
    var nearestlatArray = [Double]()
    var nearestlonArray = [Double]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager = CLLocationManager()
    
    var ref: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signIn(withEmail: "localhost@theshield.com", password: "4theshield.com")
        
        ref = Database.database().reference()
        
        
        ref?.child("parentingRoom").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [Any]
            
            let count = value!.count
            
            self.dataFromFirebaseArray.removeAll()
            
            for index in 1...(count - 1){
                self.dataFromFirebaseArray.append(value?[index] as! String)
            }
            
            self.getLatAndLon()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref?.child("Hospital").child("Hoslat").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [Double]
            
            self.HoslatArray.removeAll()
            
            self.HoslatArray = value!
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref?.child("Hospital").child("Hoslong").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [Double]
            
            self.HoslonArray.removeAll()
            
            self.HoslonArray = value!
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = googleMapsView.myLocation
        if location != nil {
            googleMapsView.animate(toLocation: (location?.coordinate)!)
            googleMapsView.animate(toZoom: 17)
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(true)
        
        initialMapView()
        
    }
    
    func addMarker(){
        googleMapsView.clear()
        print(lonArray.count)
        print(latArray.count)

        for i in 0...(lonArray.count - 1) {
            let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[0].img, borderColor: UIColor.darkGray, tag: 0)
            
            
            marker.iconView=customMarker

            marker.position = CLLocationCoordinate2D(latitude: latArray[i], longitude: lonArray[i])
            marker.map = self.googleMapsView
        }
    }
    
    func addHosMarker(){
        googleMapsView.clear()
        print(nearestlonArray.count)
        print(nearestlatArray.count)
        
        for i in 0...(nearestlonArray.count - 1) {
            let lat = nearestlatArray[i]
            let lon = nearestlonArray[i]
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 17)
            self.googleMapsView.camera = camera
            
            marker.title = "Hospital"
            marker.map = self.googleMapsView
        }
    }
    
    func initialMapView(){
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        self.googleMapsView?.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: -37.877006, longitude: 145.044759, zoom: 17.0)
        self.googleMapsView.camera = camera
        //Location Manager code to fetch current location
        self.locationManager.delegate = self as? CLLocationManagerDelegate
        self.locationManager.startUpdatingLocation()
        
        
        self.view.addSubview(self.googleMapsView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive=true
        btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)
        
        
    }
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 17)
            self.googleMapsView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            
        }
        
    }
    
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()


        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil)  {(results, error: Error?) -> Void in
           // NSError myerr = Error;
            print("Error @%",Error.self)

            self.resultsArray.removeAll()
            if results == nil {
                return
            }

            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }

            self.searchResultController.reloadDataWithArray(self.resultsArray)

        }
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 27.0)
        
        self.googleMapsView.animate(to: camera)
    }
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "my_location"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()

    func getLatAndLon(){
        latArray.removeAll()
        lonArray.removeAll()
        for item in dataFromFirebaseArray{
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(item) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                if lat != nil{
                    self.latArray.append(Double(lat!))
                    self.lonArray.append(Double(lon!))
                }
            }
            
        }
    
    }
    
    func calculateDistance(){
        let location: CLLocation? = googleMapsView.myLocation
        
        for i in 0...HoslatArray.count - 1{
            let coordinate = CLLocation(latitude: HoslatArray[i], longitude: HoslonArray[i])
            let distanceInMeters = coordinate.distance(from: location!)
            if distanceInMeters <= 2000{
                nearestlatArray.append(HoslatArray[i])
                nearestlonArray.append(HoslonArray[i])
            }
        }
        
    }


}
