//
//  MemeTabelViewController.swift
//  MemeMe
//
//  Created by manar Aldossari on 25/04/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit

class MemeTabelViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource {
    //MARK: -Properties
    var memes:[Meme]!{
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes
        
        
    }
    //MARK: -IBOutlets
    @IBOutlet weak var memeTabelView: UITableView!
    
    //MARK: -lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.memeTabelView.reloadData()
        self.memeTabelView.endUpdates()
    }
    
    //MARK: -IBActions
    @IBAction func add(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
        navigationController?.pushViewController(vc,animated: true)
    }
    
    //MARK: -TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMeme")!
        cell.imageView!.image = meme.originalImage
        cell.detailTextLabel!.text = meme.topText + meme.bottomText
        cell.textLabel?.text = ""
        return cell
    }
    
    
    //MARK: -TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMeme = memes[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeView") as! DetaileViewController
        vc.meme = currentMeme
        navigationController!.pushViewController(vc, animated: true)
        
    }
  
}
