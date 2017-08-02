//
//  AddHoardingViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 23/05/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AddHoardingViewController: BaseViewController,GMSMapViewDelegate{
//,GMSAutocompleteViewControllerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "My Hoardings",isFilter: false)
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86,
                                              longitude: 151.20,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.isHidden = true

        let btnMapCenter = UIButton(frame: CGRect(x: ScreenWidth - 70, y: ScreenHeight - 70, width: 50, height: 50))
        btnMapCenter.backgroundColor = UIColor.clear
        btnMapCenter.setImage(UIImage(named:"location-pin.png"), for: .normal)
        btnMapCenter.addTarget(self, action: #selector(btnMapCenterClicked(sender:)), for: .touchUpInside)
        btnMapCenter.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 25)
        self.view.addSubview(btnMapCenter)
        
        //Search area code
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.barTintColor = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        searchController?.searchBar.tintColor = UIColor.white
        resultsViewController?.primaryTextHighlightColor = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)

        let subView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        //        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        
        let vwAddressBg = UIView(frame: CGRect(x: 20, y: ScreenHeight - 64 - 120, width: ScreenWidth - 40, height: 100))
        vwAddressBg.backgroundColor = UIColor.clear
        vwAddressBg.tag = 500
        self.view.addSubview(vwAddressBg)
        
        let vwAddress = UIView(frame: CGRect(x: 0, y: 0, width: vwAddressBg.frame.size.width - 25, height: 100))
        vwAddress.backgroundColor = UIColor.white
        vwAddress.layer.cornerRadius = 5
        vwAddress.layer.masksToBounds = true
        vwAddressBg.addSubview(vwAddress)

        let btnAddress = UIButton(frame: CGRect(x: 5, y: 5, width: vwAddress.frame.size.width - 10, height: vwAddressBg.frame.size.height - 10))
        btnAddress.backgroundColor = UIColor.clear
        btnAddress.tag = 501
        btnAddress.setAttributedTitle(NSAttributedString(string: "Address"), for: .normal)
        btnAddress.contentVerticalAlignment = .top
        btnAddress.titleLabel?.textAlignment = .left
        btnAddress.titleLabel?.numberOfLines = 0
        vwAddress.addSubview(btnAddress)
        
        
        
        let btnAddHoarding = UIButton(frame: CGRect(x:  vwAddressBg.frame.size.width - 50, y: 25 , width: 50, height: 50))
        btnAddHoarding.backgroundColor = UIColor.white
        btnAddHoarding.addTarget(self, action: #selector(btnAddHoardingClicked(sender:)), for: .touchUpInside)
        btnAddHoarding.layer.cornerRadius = 25
        btnAddHoarding.layer.masksToBounds = true
        btnAddHoarding.setImage(UIImage(named:"Remember_selected.png"), for: .normal)
        vwAddressBg.addSubview(btnAddHoarding)


        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let point = mapView.center
        let coor = mapView.projection.coordinate(for: point)
        print("lat : \(coor.latitude) , lon : \(coor.longitude)")
        
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(coor.latitude),Double(coor.longitude))
        
        
        var currentAddress = String()
        
        let vwAddress : UIView = self.view.viewWithTag(500)!
        let btnAddress : UIButton = vwAddress.viewWithTag(501)! as! UIButton
        
        
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                btnAddress.setAttributedTitle(NSAttributedString(string: "\(currentAddress)"), for: .normal)
                print("currentAddress : \(currentAddress)")
            }
        }
        
        
    }
    func btnMapCenterClicked(sender:UIButton)
    {
        
    }
    

    func btnAddHoardingClicked(sender:UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension AddHoardingViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        if CLLocationCoordinate2DIsValid(place.coordinate) {
            print("selected address with lat : \(place.coordinate.latitude), long : \(place.coordinate.longitude)")
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                  longitude: place.coordinate.longitude,zoom: zoomLevel)
            mapView.animate(to: camera)
        }

        let vwAddress : UIView = self.view.viewWithTag(500)!
        let btnAddress : UIButton = vwAddress.viewWithTag(501)! as! UIButton
        btnAddress.setAttributedTitle(NSAttributedString(string: "\(place.formattedAddress)"), for: .normal)

        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension AddHoardingViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
            
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
