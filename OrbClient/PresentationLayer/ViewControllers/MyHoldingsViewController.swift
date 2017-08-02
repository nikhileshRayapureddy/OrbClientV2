//
//  MyHoldingsViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 20/05/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MyHoldingsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate {
    let path = GMSMutablePath()

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var vwFilter = FilterCustomView()
    var btnFilterBg = UIButton()
    var arrSelIndices = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "My Hoardings",isFilter: true)
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
        //mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        // Do any additional setup after loading the view.
        
        
        let btnAddHoarding = UIButton(frame: CGRect(x: ScreenWidth - 70, y: ScreenHeight - 70-64, width: 50, height: 50))
        btnAddHoarding.backgroundColor = UIColor.white
        btnAddHoarding.addTarget(self, action: #selector(btnAddHoardingClicked(sender:)), for: .touchUpInside)
        btnAddHoarding.layer.cornerRadius = 25
        btnAddHoarding.layer.masksToBounds = true
        btnAddHoarding.setImage(#imageLiteral(resourceName: "morning"), for: .normal)
        self.view.addSubview(btnAddHoarding)
        
        let btnMapCenter = UIButton(frame: CGRect(x: ScreenWidth - 70, y: ScreenHeight - 70, width: 50, height: 50))
        btnMapCenter.backgroundColor = UIColor.clear
        btnMapCenter.setImage(UIImage(named:"location-pin.png"), for: .normal)
        btnMapCenter.addTarget(self, action: #selector(btnMapCenterClicked(sender:)), for: .touchUpInside)
        btnMapCenter.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 25)
        self.view.addSubview(btnMapCenter)

    }
    override func viewWillAppear(_ animated: Bool) {

        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 17.456296, longitude: 78.367922)
        marker1.title = "Kothaguda"
        marker1.snippet = "Hyderabad"
        marker1.map = mapView
        path.add(marker1.position)
        
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 17.494181, longitude: 78.399299)
        marker2.title = "Kukatpally"
        marker2.snippet = "Australia"
        marker2.map = mapView
        path.add(marker2.position)
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2D(latitude: 17.490088, longitude: 78.391925)
        marker3.title = "Kukatpally Housing Board"
        marker3.snippet = "Australia"
        marker3.map = mapView
        path.add(marker3.position)
        
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2D(latitude: 17.498868, longitude: 78.384629)
        marker4.title = "Miyapur"
        marker4.snippet = "Australia"
        marker4.map = mapView
        path.add(marker4.position)
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let point = mapView.center
        let coor = mapView.projection.coordinate(for: point)
        print("lat : \(coor.latitude) , lon : \(coor.longitude)")
        
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(coor.latitude),Double(coor.longitude))
        
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                print("currentAddress : \(currentAddress)")
            }
        }     


    }
    func btnMapCenterClicked(sender:UIButton)
    {
        
    }

    func btnAddHoardingClicked(sender:UIButton)
    {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddHoardingViewController") as! AddHoardingViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func filterClicked(sender:UIButton)
    {
        btnFilterBg = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        btnFilterBg.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        btnFilterBg.addTarget(self, action: #selector(btnFilterBgClicked(sender:)), for: .touchUpInside)
        self.view.window?.addSubview(btnFilterBg)

        vwFilter =   (Bundle.main.loadNibNamed("FilterCustomView", owner: nil, options: nil)![0] as? FilterCustomView)!
        vwFilter.btnClear.addTarget(self, action: #selector(btnFilterClearClicked(sender:)), for: .touchUpInside)
        vwFilter.btnCancel.addTarget(self, action: #selector(btnFilterCancelClicked(sender:)), for: .touchUpInside)
        vwFilter.btnFilter.addTarget(self, action: #selector(btnFilterClicked(sender:)), for: .touchUpInside)
        vwFilter.tblAreas.delegate = self
        vwFilter.tblAreas.dataSource = self
        vwFilter.tblAreas.register(UINib(nibName: "FilterCustomCell", bundle: nil), forCellReuseIdentifier: "FilterCustomCell")

        vwFilter.frame = CGRect(x:50,y: 64,width: ScreenWidth-50, height:ScreenHeight - 64)
        self.view.window?.addSubview(vwFilter)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FilterCustomCell =  tableView.dequeueReusableCell(withIdentifier: "FilterCustomCell", for: indexPath) as! FilterCustomCell
        cell.lblAreaName.text = "Area \(indexPath.row)"
        if arrSelIndices.contains(indexPath.row)
        {
            cell.btnSelection.isSelected = true
        }
        else
        {
            cell.btnSelection.isSelected = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if arrSelIndices.contains(indexPath.row) == true
        {
            let index = arrSelIndices.index(of: indexPath.row)
            arrSelIndices.remove(at: index!)
        }
        else
        {
            arrSelIndices.append(indexPath.row)
        }
    tableView.reloadData()

    }
    func btnFilterClearClicked(sender : UIButton)
    {
        arrSelIndices.removeAll()
        vwFilter.tblAreas.reloadData()
    }
    func btnFilterClicked(sender : UIButton)
    {
        
    }
    func btnFilterCancelClicked(sender : UIButton)
    {
        btnFilterBg.removeFromSuperview()
        vwFilter.removeFromSuperview()
    }

    func btnFilterBgClicked(sender : UIButton)
    {
        sender.removeFromSuperview()
        vwFilter.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MyHoldingsViewController: CLLocationManagerDelegate {
    
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
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = "Kondapur"
            marker.snippet = "Hyderabad"
            marker.map = mapView
            
            path.add(marker.position)


        } else {
            mapView.animate(to: camera)
        }
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        

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
