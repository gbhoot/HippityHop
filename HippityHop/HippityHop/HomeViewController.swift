//
//  HomeViewController.swift
//  HippityHop
//
//  Created by Kim Do on 11/2/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class HomeViewController: UIViewController, GADBannerViewDelegate {
   
   @IBOutlet weak var bannerView: GADBannerView!
   @IBOutlet weak var gifView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      gifView.loadGif(name: "dancing")
//      bannerView.adUnitID = "ca-app-pub-2882661438073065/9079075290"
      bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
      bannerView.rootViewController = self
      bannerView.load(GADRequest())
      bannerView.delegate = self
      
        // Do any additional setup after loading the view.
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
