//
//  MapViewController.swift
//  mySpace
//
//  Created by Shom on 05.01.2023.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var locationManager = CLLocationManager()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .small)
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: largeConfig), for: .normal)
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView: MKMapView!
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.showsCompass = true
        self.mapView.showsUserLocation = true
        return self.mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = MKMapView()
        self.mapView.delegate = self
        self.view.addSubviews(mapView, button)
        self.mapView.showsUserLocation = true
        self.navigationItem.title = "Карты"
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
        
        
        //getDirection()
        initialLayout()
        
        //Булавка появляется после длительного нажатия на карту
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(self.handleTap(_:)))
        mapView.addGestureRecognizer(myLongPress)
        
        /*
         let bigTeatr = MKPointAnnotation()
         bigTeatr.coordinate = CLLocationCoordinate2D(latitude: 55.7602196, longitude: 37.6186409)
         mapView.showAnnotations([bigTeatr], animated: true)
         bigTeatr.title = "Teatr"
         */
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    private func initialLayout() {
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.mapView == self.mapView else { return }
        mapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        //mapView.frame = view.bounds
    }
    
    //Добавление точек
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        
        let locations = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locations.fetchCityAndCountry{ city, country, error in //Страна и город
            guard let city = city, let country = country, error == nil else { return }
            
            //адреса и точные данные
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                
                DispatchQueue.main.async {
                    annotation.coordinate = coordinate
                    self.mapView.addAnnotation(annotation)
                    self.mapView.isZoomEnabled = true
                    self.mapView.isScrollEnabled = true
                    annotation.title = "\(placemark.streetName ?? "address not found") \(placemark.streetNumber ?? "")"
                    annotation.subtitle = "\(country) - \(city)"
                }
            }
        }
    }
    
    //Удаление точек и маршрута, кроме точки пользователя!
    @objc func handleTapButton(_ sender: UIButton) {
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
                self.mapView.removeOverlays(mapView.overlays)
            }
        }
        print("Your annotations deleting")
    }
}

//Местоположение пользователя
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        mapView.showsCompass = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        //annotation.coordinate = locValue
        annotation.title = "Мое местоположение"
        annotation.subtitle = "iPhone"
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        
        var viewMaker: MKMarkerAnnotationView
        let idView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMaker = view
        } else {
            viewMaker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMaker.canShowCallout = true
            viewMaker.calloutOffset = CGPoint(x: 0, y: 6)
            viewMaker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return viewMaker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        
        let pinPoint = view.annotation
        let startPoint = MKPlacemark(coordinate: coordinate)
        let endPoint = MKPlacemark(coordinate: pinPoint!.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        
        
        let direction = MKDirections(request: request)
        direction.calculate { responce, error in
            guard let responce = responce else { return }
            self.mapView.removeOverlays(mapView.overlays)//если есть действующий маршрут отменится перед началом следующего
            for route in responce.routes {
                self.mapView.addOverlay(route.polyline)
                if let view = view as? MKMarkerAnnotationView {
                    view.markerTintColor = UIColor.systemGreen
                }
                
            }
            if responce.routes.count > 0 {
                let route = responce.routes[0]
                print("Время по маршруту \(route.expectedTravelTime) секунд")//просто для информации записал, в идела первести в формате времени и сделать label
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        //Показывается zoom маршрута после построения
        let mapRect = MKPolygon(points: renderer.polyline.points(), count: renderer.polyline.pointCount)
        mapView.setVisibleMapRect(mapRect.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0,left: 50.0,bottom: 50.0,right: 50.0), animated: true)
        renderer.lineWidth = 3
        renderer.strokeColor = .systemOrange
        
        return renderer
    }
    
    //изменение цвета булавки при выборе
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? MKMarkerAnnotationView {
            view.markerTintColor = mapView.tintColor
        }
    }
    
    //возвращение цета булавки
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let view = view as? MKMarkerAnnotationView {
            view.markerTintColor = UIColor.systemRed
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    var streetName: String? { thoroughfare }
    var streetNumber: String? { subThoroughfare }
    var city: String? { locality }
    var neighborhood: String? { subLocality }
    var state: String? { administrativeArea }
    var county: String? { subAdministrativeArea }
    var zipCode: String? { postalCode }
    
    @available(iOS 11.0, *)
    
    var postalAddressFormatted: String? {
        guard let postalAddress = postalCode else { return nil }
        return postalAddress
    }
    
    var streetNameFormatted: String? {
        guard let streetName = streetName else { return nil }
        return streetName
    }
    
    var streetNumberForamttes: String? {
        guard let streetNumber = streetNumber else { return nil}
        return streetNumber
    }
}

