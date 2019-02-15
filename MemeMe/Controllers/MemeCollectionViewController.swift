//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by manar Aldossari on 25/04/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit
//,UICollectionViewDelegate

class MemeCollectionViewController: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource{
    
    //MARK: -Properties
    var memes:[Meme]! {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes
    }
    //MARK: -IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2*space))/3.0
        let heightDimension = (view.frame.size.height - (2*space))/3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    //MARK: -IBActions
    @IBAction func add(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -UICollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectonViewCell", for: indexPath) as! CollectionViewCell
        let currentMeme = memes[indexPath.row]
        cell.imageView.image = currentMeme.originalImage
        cell.topLabel.text = currentMeme.topText
        cell.buttomLabel.text = currentMeme.bottomText
        return cell
    }
    //MARK: -UICollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentMeme = memes[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeView") as! DetaileViewController
        vc.meme = currentMeme
        navigationController!.pushViewController(vc, animated: true)
    }
    


}
