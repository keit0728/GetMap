//
//  ViewController.swift
//  GetMap
//
//  Created by keit0728 on 2020/06/01.
//  Copyright © 2020 keit0728. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{

        
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //表示範囲
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        //表示場所
        let location = CLLocationCoordinate2D(latitude: 34.703476, longitude: 137.734892)
        
        //どれだけの範囲でどこを表示するか
        let region = MKCoordinateRegion(center: location, span: span)
        
        //上記regionでmapを表示
        mapView.setRegion(region, animated: true)
        
    }
    
    //map上のregionが変化したときに実行
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //map上の緯度経度を取得
        let currentLocation = mapView.centerCoordinate
        let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        //緯度経度から住所を表示(逆ジオコーディング)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard
                let placemark = placemarks?.first, error == nil,        //データが取得できているかチェック
                let administrativeArea = placemark.administrativeArea,  //都道府県
                let locality = placemark.locality,                      //市区町村
                let thoroughfare = placemark.thoroughfare,              //地名(丁目)
                let subThoroughfare = placemark.subThoroughfare         //番地
            else {
                self.addressLabel.text = self.address
                return
            }
            
            self.address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            self.addressLabel.text = self.address
            
        }
        
    }
}

