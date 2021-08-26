//
//  AttachmentHelper.swift
//  Monuments
//
//  Created by jayesh.d on 02/11/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos


/*
 AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
 AttachmentHandler.shared.imagePickedBlock = { (image) in
 /* get your image here */
 }
 */

enum AttachType : String {
    
    case camera = "Camera"
    case phoneLibrary = "Phone Library"
    case video = "Video"
    case file = "File"
    case removePhoto = "Remove Photo"
    case viewPhoto = "View Photo"
}


class AttachmentHandler: NSObject {
    
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var viewPhotoBlock : ((Bool) -> Void)?
    var removePhotoBlock : ((Bool) -> Void)?
    
    var arrAttachType : [AttachType] = [.camera, .phoneLibrary, .video, .file]
    
    enum AttachmentType: String {
        
        case camera, video, photoLibrary
    }
    
    
    //MARK: - Constants
    struct Constants {
        
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        static let removePhoto = "Remove Photo"
        static let viewPhoto = "View Photo"
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    
    //Attachment Helper
    func getAttachmentPermissionStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController, completion: @escaping (Bool) -> ()) {
           
           currentVC = vc
           
           if attachmentTypeEnum == .camera {
               
               let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
               
               switch status {
               case .authorized:
                   
                   completion(true)
                   
               case .denied:
                   print("permission denied")
                   self.addAlertForSettings(attachmentTypeEnum)
               case .notDetermined:
                   print("Permission Not Determined")
                   
                   AVCaptureDevice.requestAccess(for: .video) { (status) in
                       
                       if status {
                           // photo library access given
                           print("access given")
                         
                           DispatchQueue.main.async {
                                 completion(true)
                           }
                       }else{
                           print("restriced manually")
                           self.addAlertForSettings(attachmentTypeEnum)
                       }
                   }
                   
               case .restricted:
                   print("permission restricted")
                   self.addAlertForSettings(attachmentTypeEnum)
               default:
                   break
               }
               
           } else if attachmentTypeEnum == .video {
               
               let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
               
               switch status {
               case .authorized:
                   
                   completion(true)
               case .denied:
                   print("permission denied")
                   self.addAlertForSettings(attachmentTypeEnum)
               case .notDetermined:
                   print("Permission Not Determined")
                   
                   AVCaptureDevice.requestAccess(for: .video) { (status) in
                       
                       if status {
                           // photo library access given
                           print("access given")
                         
                           completion(true)
                           
                       }else{
                           print("restriced manually")
                           self.addAlertForSettings(attachmentTypeEnum)
                       }
                   }
                   
               case .restricted:
                   print("permission restricted")
                   self.addAlertForSettings(attachmentTypeEnum)
               default:
                   break
               }
               
           } else if attachmentTypeEnum == .photoLibrary {
               
               let status = PHPhotoLibrary.authorizationStatus()
               
               switch status {
               case .authorized:
                   
                   completion(true)
                  
               case .denied:
                   print("permission denied")
                   self.addAlertForSettings(attachmentTypeEnum)
                   
               case .notDetermined:
                   print("Permission Not Determined")
                   PHPhotoLibrary.requestAuthorization({ (status) in
                       
                       if status == PHAuthorizationStatus.authorized {
                           // photo library access given
                           print("access given")
                           
                            completion(true)
                           
                       }else{
                           
                           print("restriced manually")
                           self.addAlertForSettings(attachmentTypeEnum)
                       }
                   })
               case .restricted:
                   print("permission restricted")
                   self.addAlertForSettings(attachmentTypeEnum)
               default:
                   break
               }
               
           }
           
           
       }
    
    func showAttachmentActionSheet(type: [AttachType], vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
                   var actionSheet = UIAlertController()
                  
                    if( IS_IPAD == true) {
                      actionSheet = UIAlertController(title: APP_LBL.AlertTitel, message: nil, preferredStyle: .alert)
                    } else  {
                      actionSheet = UIAlertController(title: APP_LBL.AlertTitel, message: nil, preferredStyle: .actionSheet)
                  }
                  
                  
                  if type.contains(.camera) {
                      
                      actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
                          self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
                      }))
                  }
                  
                  if type.contains(.phoneLibrary) {
                      
                      actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                          self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
                      }))
                  }
                  
                  if type.contains(.video) {
                      
                      actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
                          self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
                          
                      }))
                  }
                  
                  if type.contains(.viewPhoto){
                           actionSheet.addAction(UIAlertAction(title: Constants.viewPhoto, style: .default, handler: { (action) -> Void in
                              self.viewPhotoBlock?(true)
                           }))
                       }
                  
                  if type.contains(.removePhoto){
                      actionSheet.addAction(UIAlertAction(title: Constants.removePhoto, style: .default, handler: { (action) -> Void in
                          self.removePhotoBlock?(true)
                      }))
                  }
                  
               
                  
                  
                  if type.contains(.file) {
                      
                      actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
                          self.documentPicker()
                      }))
                  }
                  
                  
                  actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
                  
                  DispatchQueue.main.async {
                      
                      vc.present(actionSheet, animated: true, completion: nil)
                  }
        }
      
    }
    
    func showAttachmentCameraAction(vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
                   self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }
       
    }
    
    func showAttachmentPhotoLibraryAction(vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
                   self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }
       
    }
    
    func showAttachmentVideoAction(maxDurationSecond: Int? = nil, vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
                self.maxDurationSecond = maxDurationSecond
                self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
        }
    
    }
    
    func showAttachmentFileAction(vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
            self.documentPicker()
        }
        
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
        DispatchQueue.main.async {
            self.currentVC = vc
            
            if attachmentTypeEnum == AttachmentType.camera{
                self.openCamera()
            } else {
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .authorized:
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                case .denied:
                    print("permission denied")
                    self.addAlertForSettings(attachmentTypeEnum)
                case .notDetermined:
                    print("Permission Not Determined")
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if status == PHAuthorizationStatus.authorized{
                            // photo library access given
                            print("access given")
                            if attachmentTypeEnum == AttachmentType.camera{
                                self.openCamera()
                            }
                            if attachmentTypeEnum == AttachmentType.photoLibrary{
                                self.photoLibrary()
                            }
                            if attachmentTypeEnum == AttachmentType.video{
                                self.videoLibrary()
                            }
                        }else{
                            print("restriced manually")
                            self.addAlertForSettings(attachmentTypeEnum)
                        }
                    })
                case .restricted:
                    print("permission restricted")
                    self.addAlertForSettings(attachmentTypeEnum)
                default:
                    break
                }
            }
            
        }
        
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            DispatchQueue.main.async {
                
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .camera
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                        if granted {
                            
                            DispatchQueue.main.async {
                                let myPickerController = UIImagePickerController()
                                myPickerController.delegate = self
                                myPickerController.sourceType = .camera
                                self.currentVC?.present(myPickerController, animated: true, completion: nil)
                            }
                            
                        } else {
                            //access denied
                            self.addAlertForSettings(AttachmentType.camera)

                        }
                    })
                }
                
//                let myPickerController = UIImagePickerController()
//                myPickerController.delegate = self
//                myPickerController.sourceType = .camera
//                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            DispatchQueue.main.async {
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    var maxDurationSecond: Int? = nil
    func videoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            DispatchQueue.main.async {
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                myPickerController.allowsEditing = true
                
                if self.maxDurationSecond != nil && self.maxDurationSecond! > 0 {
                    myPickerController.videoMaximumDuration = TimeInterval(self.maxDurationSecond!)
                }
                
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - FILE PICKER
    func documentPicker(){
        
        DispatchQueue.main.async {
            
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            //UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.currentVC?.present(importMenu, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera {
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary {
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video {
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
        DispatchQueue.main.async {
            
            let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
            cameraUnavailableAlertController .addAction(cancelAction)
            cameraUnavailableAlertController .addAction(settingsAction)
            self.currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imagePickedBlock?(image)
            currentVC?.dismiss(animated: true, completion: nil)
            return
        } else {
            print("Something went wrong in edit image")
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if !APP_DEL.isImageAdded
            {
                APP_DEL.isImageAdded = true
            self.imagePickedBlock?(image)
            currentVC?.dismiss(animated: true, completion: nil)
            }
            return
        } else {
            print("Something went wrong in original image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl)
        } else {
            print("Something went wrong in  video")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
                
            default:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        
        exportSession.exportAsynchronously { () -> Void in
            
            handler(exportSession)
        }
    }
}

//MARK: - FILE IMPORT DELEGATE
extension AttachmentHandler: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        
        DispatchQueue.main.async {
            
            self.currentVC?.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        self.filePickedBlock?(url)
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}

