//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by manar Aldossari on 13/04/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate{
    //MARK: -Properties
    
//    var memes:[Meme]! {
//        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
//        return appDelegate.memes
//    }
    
    //MARK: -IBOutlets
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButtom: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var tobTextField: UITextField!
    @IBOutlet weak var bottoomTextField: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.backgroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0),
        NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,
        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -6
    ]
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        stateForCancelAndSharing(false)

        configure(tobTextField, with: "TOP",and: memeTextAttributes )
        configure(bottoomTextField, with: "BOTTOOM",and: memeTextAttributes)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // configure Method for textField text and TextAttributes
    func configure(_ textField: UITextField, with defaultText: String ,and defaultTextAttributes:[NSAttributedString.Key : Any] ) {
        textField.defaultTextAttributes = defaultTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.delegate = self
    }
    //IBAction for Album Button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }
    //IBAction for Camera Button
    @IBAction func pickAnImangeFromCamera(_ sender: Any) {
        pickAnImage(from:.camera)
    }
    //pickAnImage method
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //IBAction for Share Button
    @IBAction func shareAMeme(_ sender: Any) {
        let  memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.present(controller,animated: true ,completion: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if(completed){
               self.save()
            }
            
        }
    }
    //IBAction for Cancel Button
    @IBAction func cancel(_ sender: Any) {
        configure(tobTextField, with: "TOP",and: memeTextAttributes)
        configure(bottoomTextField, with: "BOTTOOM",and: memeTextAttributes)
        stateForCancelAndSharing(false)
        imageView.image = nil
    }

    //cancel and share buttom state method
    func stateForCancelAndSharing(_ state:Bool){
        shareButtom.isEnabled = state
        cancelButton.isEnabled = state
    }
    
    // MARK: -UIImagePickerController Delgate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        stateForCancelAndSharing(true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -UITextField Delgate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOOM"){
            textField.text = ""
        }
        stateForCancelAndSharing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - accommodate the keyboard Method
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
   @objc func keyboardWillShow(_ notification:Notification) {
    if(bottoomTextField.isEditing){
         view.frame.origin.y = getKeyboardHeight(notification) * (-1)
    }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //MARK: -for sharing the memedImage method
    func generateMemedImage() -> UIImage {
        state(of: navbar, and: toolbar, is: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        state(of: navbar, and: toolbar, is: false)
        return memedImage
    }
    func state(of navbar: UINavigationBar ,and toolbar:UIToolbar ,is state:Bool){
        navbar.isHidden = state
        toolbar.isHidden = state
    }
    func save() {
        let  memedImage = generateMemedImage()
        
        let meme = Meme(topText: tobTextField.text!, bottomText: bottoomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        //add it to the memes array on thr Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        //go back to the MemeTabelViewControoler
         navigationController!.popViewController(animated: true)


    }

    
 }

    


