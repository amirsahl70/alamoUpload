//
//  ViewController.swift
//  alamoFileUpload
//
//  Created by Amir on 7/20/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    //let parameters = ["user" : "amir" , "pass": "12345"]
    var imagePath : URL?
    
    var uploadRequest: Request?
    var progressUpload : Request?
    var sessionManager = SessionManager()
    
    let fileURL = Bundle.main.url(forResource: "highVol", withExtension: "jpg")
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
          //imageView.image = UIImage.init(named: "nature.jpeg")
        imageView.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let image =  UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage , let imageURL = info[UIImagePickerControllerImageURL] as? URL  {
            imageView.image = pickImage
            imageView.backgroundColor = UIColor.clear
            self.imagePath = imageURL
        }
        self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func upload(_ sender: Any) {
        uploadImage()
    }
    
    
    func uploadImage(){
        guard let uploadURL = URL(string: "https://192.168.17.253:443/app_dev.php/ios/test/upload") else {return}

        //let imageData = UIImageJPEGRepresentation( imageView.image! , 0.1)
        HttpHandler.fileUpload(url: uploadURL, filePath: fileURL!,sessionManager: self.sessionManager, completionHandler : responseProgress )
        //self.uploadButton.isEnabled = false
        
    }
    func responseProgress(data: SessionManager.MultipartFormDataEncodingResult)  {
        switch data {
        case .success(let upload,_,_):
            let request = upload.responseJSON { res in
                print("response --> \(res.result.value as Any)")
                //self.uploadButton.isEnabled = true
            }
            self.uploadRequest = request
            let progress = upload.uploadProgress { progress in
                print("Upload Progress : \(progress.fractionCompleted)")
                self.progressBarView.progress = Float(progress.fractionCompleted)
                let progressPercent = Int(progress.fractionCompleted * 100)
                self.percentLabel.text = "\(progressPercent)%"
            }
            self.progressUpload = progress
            
        case .failure(let error): print("error is -->> \(error)")
        }
    }
    
    @IBAction func cancelUpload(_ sender: Any) {
        
        self.uploadRequest?.cancel()
        //self.uploadButton.isEnabled = true
        
    }
    
    @IBAction func pauseUpload(_ sender: Any) {
        
        self.uploadRequest?.suspend()
    }
    
    @IBAction func resumeUpload(_ sender: Any) {
        self.uploadRequest?.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

