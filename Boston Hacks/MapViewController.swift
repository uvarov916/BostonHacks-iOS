//
//  MapViewController.swift
//  Boston Hacks
//
//  Created by Aleksander Skjoelsvik on 10/22/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: VARIABLES
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.5
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}