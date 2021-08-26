//
//  S3bucketHelper.swift
//  Monuments
//
//  Created by jayesh.d on 12/11/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit
import AVFoundation
import AWSS3


let API_S3 = AWSS3Manager.shared

enum S3_Folder : String {
    
    case User_Profile_Pic_Path = "profile_images/"
    case Trip_Pic_Path = "trip_image/"
    case Event_Pic_Path = "event_image/"
    case Post_Pic_Path = "post_media/"
    case Place_Gallery_Path = "place_gallery/"
    case Group_assets = "group_assets/"

//    case Post_Video_Path = "post_media_video/"
//    case Post_Video_Thumbnail_Path = "post_media_video_thumbnail/"

    case Other_Pic_Path = "other_media/"
    case chat = "chat_media/"
    case none = "none"
    
    // S3 Paths
//    let Aws_S3_User_Profile_Pic_Path = "profile_images/"
//    let Aws_S3_Trip_Pic_Path = "trip_image/"
//    let Aws_S3_Event_Pic_Path = "event_image/"
//    let Aws_S3_Post_Pic_Path = "post_media/"
//    let Aws_S3_Other_Pic_Path = "other_media/"
}

class AWSS3Manager {
    
//    =======================================================================================================================
//    AWS S3 Bucket Details:-
//    ======================================================================================================================
//    S3 bucketname:- socialbug
//    S3 bucketurl:- https://socialbug.s3.amazonaws.com/
//    Access key : AKIARYE7YTHYGOQFVYF2
//    Secret key : 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
    
//    vrinsoft test
//    let S3_BUCKET_NAME : String = "s3-ios-test"//"rentz-s3"
//    let S3_ACCESS_KEY : String = "AKIA3QCTYD3ANYNLBLJK"//"AKIA5CLJ6TJRJHTMDJTI"
//    let S3_SECRET_KEY : String = "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"//"Lup467WxMlwaBj6RlQOnRXXb/cROVwmQpKHoBxje"
//    let S3_REGION_TYPE : AWSRegionType = .USEast1//.EUWest2
    
    //    Client Live
        let S3_BUCKET_NAME : String = "socialbug"//"rentz-s3"
        let S3_ACCESS_KEY : String = "AKIARYE7YTHYGOQFVYF2"//"AKIA5CLJ6TJRJHTMDJTI"
        let S3_SECRET_KEY : String = "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"//"Lup467WxMlwaBj6RlQOnRXXb/cROVwmQpKHoBxje"
        let S3_REGION_TYPE : AWSRegionType = .USEast1//.EUWest2
    
    
    static let shared = AWSS3Manager()
    private init() { }
    
    
    func initializeS3() {
        let credentialProvider = AWSStaticCredentialsProvider(accessKey: self.S3_ACCESS_KEY, secretKey: self.S3_SECRET_KEY)
        let awsConfiguration = AWSServiceConfiguration(region: self.S3_REGION_TYPE, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awsConfiguration
    }

    // Upload image using UIImage object
    func uploadImage(image: UIImage, fileName: String = "", folder: S3_Folder, progress: progressBlock?, completion: completionBlock?) {
        
        guard let imageData = (image.compressImage(compressionQuality: 0.5)).data else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, nil,error.localizedDescription)
            return
        }
        
        var fileName = fileName
        
        let tmpPath = NSTemporaryDirectory() as String
        let stamp = Int(TimeInterval(Date().timeIntervalSince1970))
        if fileName == "" {
            fileName = "IMAGE_\(stamp)" + (".jpeg")
        }
                
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: fileName, folder: folder, contenType: .Image, progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, nil, error.localizedDescription)
        }
    }
    
    func upload(url: URL, fileCount: Int, folder: S3_Folder, contentType: FileType, progress: progressBlock?, completion: completionBlock?) {
        
        let fileName = self.getUniqueFileName(fileUrl: url, contentType: contentType, strCount: fileCount)
        self.uploadfile(fileUrl: url, fileName: fileName, folder: folder, contenType: contentType, progress: progress, completion: completion)
    }
    
    func uploadVideo(url: URL, fileCount: Int, videoFolder: S3_Folder, videoThumbFolder: S3_Folder, contentType: FileType, progress: progressVideoBlock?, completion: completionVideoBlock?) {
        
        let videoFileName = self.getUniqueFileName(fileUrl: url, contentType: contentType, strCount: fileCount)
        self.uploadVideofile(fileUrl: url, fileCount: fileCount, fileName: videoFileName, videoFolder: videoFolder, videoThumbFolder: videoThumbFolder, contenType: contentType, progress: progress, completion: completion)
    }
    
    
    
    
    
    
    
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    
    private func uploadfile(fileUrl: URL, fileName: String, folder: S3_Folder, contenType: FileType, progress: progressBlock?, completion: completionBlock?) {
        
        let newKey = ((folder == .none) ? "" : folder.rawValue) + fileName
        
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            
            guard let uploadProgress = progress else { return }
            
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.S3_BUCKET_NAME).appendingPathComponent(newKey)
                    
                    print("S3 UPLOADED URL:- \(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, fileName, nil)
                    }
                    
                } else {
                    
                    if let completionBlock = completion {
                        completionBlock(nil, nil, error?.localizedDescription)
                    }
                }
            })
        }
        
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        
        awsTransferUtility.uploadFile(fileUrl, bucket: self.S3_BUCKET_NAME, key: newKey, contentType: contenType.rawValue, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            
            if let error = task.error {
                print("S3 ERROR:-: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    
    private func uploadVideofile(fileUrl: URL, fileCount : Int = 0, fileName: String, videoFolder: S3_Folder, videoThumbFolder: S3_Folder, contenType: FileType, progress: progressVideoBlock?, completion: completionVideoBlock?) {
        
        let newKey = ((videoFolder == .none) ? "" : videoFolder.rawValue) + fileName
        
        func finalUploadVideo(fileUrl: URL, fileName: String, videoFolder: S3_Folder, thumbFileName: String?, contenType: FileType, vidProgress: progressVideoBlock?, vidCompletion: completionVideoBlock?) {
            
            // Upload progress block
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, awsProgress) in
                
                guard let uploadProgress = vidProgress else { return }
                
                DispatchQueue.main.async {
                    uploadProgress(.Video, awsProgress.fractionCompleted)
                }
            }
            
            // Completion block
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    if error == nil {
                        
                        let url = AWSS3.default().configuration.endpoint.url
                        let publicURL = url?.appendingPathComponent(self.S3_BUCKET_NAME).appendingPathComponent(newKey)
                        
                        print("S3 UPLOADED URL:- \(String(describing: publicURL))")
                        if let completionBlock = vidCompletion {
                            completionBlock(publicURL?.absoluteString, fileName, thumbFileName, nil)
                        }
                        
                    } else {
                        
                        if let completionBlock = vidCompletion {
                            completionBlock(nil, nil, nil, error?.localizedDescription)
                        }
                    }
                })
            }
            
            // Start uploading using AWSS3TransferUtility
            let awsTransferUtility = AWSS3TransferUtility.default()
            
            awsTransferUtility.uploadFile(fileUrl, bucket: self.S3_BUCKET_NAME, key: newKey, contentType: contenType.rawValue, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                
                if let error = task.error {
                    print("S3 ERROR:-: \(error.localizedDescription)")
                }
                if let _ = task.result {
                    // your uploadTask
                }
                return nil
            }
        }
        
        
        self.getVideoThumbFromUrl(fileUrl: fileUrl) { (thumbImage) in
            
            if thumbImage == nil {
                                
                finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: nil, contenType: contenType, vidProgress: progress, vidCompletion: completion)
                
            } else {
                
                API_S3.uploadImage(image: thumbImage!, fileName: API_S3.getUniqueFileNameWithPngExtension(contentType: .Image,strCount : fileCount), folder: videoThumbFolder, progress: { (progressImage) in
                    
                    print("S3 UPLOAD THUMB:- ",Float(progressImage))
                    guard let uploadProgress = progress else { return }
                    
                    DispatchQueue.main.async {
                        uploadProgress(.VideoThumb, progressImage)
                    }
                    
                }, completion: { (uploadedFileUrl, uploadedFileName, error) in
                    
                    if let thumbFileUrl = uploadedFileUrl, let thumbFileName = uploadedFileName {
                        
                        print("S3 UPLOADED THUMB URL:- ",thumbFileUrl)
                        print("S3 UPLOADED THUMB NAME:- ",thumbFileName)
                        
                        finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: thumbFileName, contenType: contenType, vidProgress: progress, vidCompletion: completion)
                        
                    } else {
                        
                        print("S3 UPLOAD THUMB ERROR:- ",error ?? "ERROR THUMB")
                        finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: nil, contenType: contenType, vidProgress: progress, vidCompletion: completion)
                        
                    }
                })
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL, contentType: FileType,strCount : Int? = 0) -> String {
        
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        
        var head = ""
        switch contentType {
            
        case .Image:
            head = "IMG_"
            break;
        case .Audio:
            head = "AUD_"
            break;
        case .Video:
            head = "VID_"
            break;
        case .Doc:
            head = "DOC_"
            break;
        case .PDF:
            head = "PDF_"
            break;
        case .Zip:
            head = "ZIP_"
            break;
        case .Rar:
            head = "RAR_"
            break;
        case .Txt:
            head = "TXT_"
            break;
        case .Text:
            head = "TEXT_"
            break;
        case .Rtf:
            head = "RTF_"
            break;
        default:
            head = "FILE_"
            break;
        }
        
        let stamp = Int(TimeInterval(Date().timeIntervalSince1970))
        return (head + "\(APP_DEL.currentUser?.user_id ?? "0")_" + "\(stamp)_" + "\((strCount ?? 0))_" + (strExt))
    }
    
    // Get unique file name
    func getUniqueFileNameWithPngExtension(contentType: FileType,strCount : Int? = 0) -> String {
        
        
        var head = ""
        switch contentType {
            
        case .Image:
            head = "IMG_"
            break;
        case .Audio:
            head = "AUD_"
            break;
        case .Video:
            head = "VID_"
            break;
        case .Doc:
            head = "DOC_"
            break;
        case .PDF:
            head = "PDF_"
            break;
        case .Zip:
            head = "ZIP_"
            break;
        case .Rar:
            head = "RAR_"
            break;
        case .Txt:
            head = "TXT_"
            break;
        case .Text:
            head = "TEXT_"
            break;
        case .Rtf:
            head = "RTF_"
            break;
        default:
            head = "FILE_"
            break;
        }
        
        let stamp = Int(TimeInterval(Date().timeIntervalSince1970))
        return (head + "\(APP_DEL.currentUser?.user_id ?? "0")_" + "\(stamp)_" + "\((strCount ?? 0))_" + ".png")
    }
    
    
    
    
    
    func getVideoThumbFromUrl(fileUrl: URL, completion: @escaping ((_ thumbImage: UIImage?)->Void)) {
        
        DispatchQueue.global().async {
            
            let asset = AVAsset(url: fileUrl)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumnailTime = CMTimeMakeWithSeconds(1, preferredTimescale: 1)
            
            do {
                
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                
                DispatchQueue.main.async {
                    
                    print("THUMBNAIL:- DONE")
                    completion(thumbImage)
                }
                
            } catch {
                
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    
                    print("THUMBNAIL:- FAILED")
                    completion(nil)
                }
            }
        }
    }
}


typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ url: String?, _ fileName: String?, _ error: String?) -> Void
typealias progressVideoBlock = (_ progressType: ProgressType, _ progress: Double) -> Void
typealias completionVideoBlock = (_ url: String?, _ fileName: String?, _ thumbfileName: String?, _ error: String?) -> Void

enum ProgressType : String {

    case VideoThumb = "VideoThumb"
    case Video = "Video"
}

enum FileType : String {
    
    case Image = "image"
    case Audio = "audio"
    case Video = "video"
    case Doc = "doc"
    case PDF = "pdf"
    case Zip = "zip"
    case Rar = "rar"
    case Txt = "txt"
    case Text = "text"
    case Rtf = "rtf"
}
