//
//  DetaileViewController.swift
//  MemeMe
//
//  Created by manar Aldossari on 26/04/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit

class DetaileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
  

}
