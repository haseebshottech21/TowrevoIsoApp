//
//  Extention.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD


extension UIViewController
{
    func isModal() -> Bool
    {
        return self.presentingViewController?.presentedViewController == self || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) || self.tabBarController?.presentingViewController is UITabBarController
    }

    
    func showProgressHUD(message: String? = nil, progress: Float? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        
        if progress == nil {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.showProgress(progress ?? 0.0, status: message)
        }
    }
    
    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-150, width: SCREEN_WIDTH - 100, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = Utility.SetRagular(Utility.TextField_Font_size() - 2)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.numberOfLines = 2
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: APP_LBL.AlertTitel, message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: APP_LBL.ok, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(message : String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: APP_LBL.ok, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPopAlert(message: String) {
        
        let alert = UIAlertController(title: APP_LBL.AlertTitel, message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: APP_LBL.ok, style: UIAlertAction.Style.default) { (action) in
            if self.isModal() {
                self.dismiss(animated: true, completion: nil)
            }else if let navC : UINavigationController = self.navigationController, navC.viewControllers.count > 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
}


extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}


extension Date {

    static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
    
    /// Returns the amount of seconds from another date
      func seconds(from date: Date) -> Int {
          return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
      }
}

extension UIView {
    
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isUserInteractionEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = .darkGray
            self.addSubview(indicator)
            self.layoutIfNeeded()
            indicator.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func setGradient(startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createDottedLine(width: CGFloat, color: UIColor, horizontal : Bool) {
         let path = UIBezierPath()
         path.lineWidth = width
         
         let rect = self.frame
         
             let lineWidth: CGFloat = CGFloat(4)
         
         if horizontal {
             let center = rect.height * 0.5
             let drawWidth = rect.size.width - (rect.size.width).truncatingRemainder(dividingBy: (lineWidth * 2)) + lineWidth
             let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
             
             path.move(to: CGPoint(x: startPositionX, y: center))
             path.addLine(to: CGPoint(x: drawWidth, y: center))
             
         } else {
             let center = rect.width * 0.5
             let drawHeight = rect.size.height - (rect.size.height).truncatingRemainder(dividingBy: (lineWidth * 2)) + lineWidth
             let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
             
             path.move(to: CGPoint(x: center, y: startPositionY))
             path.addLine(to: CGPoint(x: center, y: drawHeight))
         }
         
         let dashes: [CGFloat] = [lineWidth, lineWidth]
         path.setLineDash(dashes, count: dashes.count, phase: 0)
         path.lineCapStyle = CGLineCap.butt
         
         color.setStroke()
         
         path.stroke()
           let caShapeLayer = CAShapeLayer()
             caShapeLayer.strokeColor = color.cgColor
           caShapeLayer.lineWidth = width
           caShapeLayer.lineDashPattern = [2,3]
     //        let cgPath = path.cgPath
     //      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
     //      cgPath.addLines(between: cgPoint)
             caShapeLayer.path = path.cgPath
           layer.addSublayer(caShapeLayer)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        self.layer.masksToBounds = true
    }
    
    
    
    func roundCorner(value : CGFloat) {
        
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    
    func roundButton() {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    func roundView() {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    func curveTxtField() {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    
    func round() {
        
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
    }
    
}

extension UIButton
{
    func setFont(font: FontName, size: CGFloat)
    {
        self.titleLabel?.font = UIFont(name: font.rawValue, size: APP_FUNC.getFontSize(size: size))!
    }
    func setTitle(title: String)
    {
        self.setTitle(title, for: UIControl.State.normal)
        self.setTitle(title, for: UIControl.State.selected)
    }
    func setTitleYellow()
    {
        self.setTitleColor(APP_COLOR, for: UIControl.State.normal)
        self.setTitleColor(APP_COLOR, for: UIControl.State.selected)
    }
  

    
    func  setAttributedString(string: String,
                              color: UIColor? = nil,
                              backgroundColor: UIColor? = nil,
                              strikethroughStyle: Int? = nil,
                              shadowBlurRadius: Int? = nil,
                              shadowOffset: CGSize? = nil,
                              shadowColor: UIColor? = nil,
                              strokeWidth: Int? = nil,
                              underlineStyle: NSUnderlineStyle? = nil,
                              font: UIFont? = nil)
    {
        self.titleLabel?.attributedText = APP_FUNC.getAttributedString(string: string, color: color, backgroundColor: backgroundColor, strikethroughStyle: strikethroughStyle, shadowBlurRadius: shadowBlurRadius, shadowOffset: shadowOffset, shadowColor: shadowColor, strokeWidth: strokeWidth, underlineStyle: underlineStyle, font: font)
    }
    
    func rounded() {
        
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
    }
    
    func addBorderAppColorWithRoundedCorner(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.borderColor = APP_COL.App.cgColor
        self.layer.borderWidth = 1.0
    }
}

extension UILabel
{
    func setFont(font: FontName, size: CGFloat)
    {
        self.font = UIFont(name: font.rawValue, size: APP_FUNC.getFontSize(size: size))!
    }
    

    
    func  setAttributedString(string: String,
                              color: UIColor? = nil,
                              backgroundColor: UIColor? = nil,
                              strikethroughStyle: Int? = nil,
                              shadowBlurRadius: Int? = nil,
                              shadowOffset: CGSize? = nil,
                              shadowColor: UIColor? = nil,
                              strokeWidth: Int? = nil,
                              underlineStyle: NSUnderlineStyle? = nil,
                              font: UIFont? = nil)
    {
        self.attributedText = APP_FUNC.getAttributedString(string: string, color: color, backgroundColor: backgroundColor, strikethroughStyle: strikethroughStyle, shadowBlurRadius: shadowBlurRadius, shadowOffset: shadowOffset, shadowColor: shadowColor, strokeWidth: strokeWidth, underlineStyle: underlineStyle, font: font)
    }
}



extension UIImageView
{
    func setImageWith(urlString: String, displayIndicater: Bool = false, placeholder: String?) {
        
        if displayIndicater {
//            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
        
        self.sd_setImage(with: URL(string: urlString), placeholderImage: (placeholder == nil) ? nil : UIImage(named: placeholder ?? ""), options: SDWebImageOptions.refreshCached, completed: nil)
    }
    
    func setHieghtByAspectToWidth() -> CGFloat {
        
        let ratio = CGFloat(image?.size.width ?? 0.0) / CGFloat(image?.size.height ?? 0.0)
        let newHeight = self.frame.width / ratio
        return newHeight
    }
    
    func rounded() {
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

extension UIImage {
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    func compressImage(compressionQuality: CGFloat = 0.5) -> (image: UIImage?, data: Data?) {
        
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        
        let maxHeight : CGFloat = 2524.0
        let maxWidth : CGFloat = 3532.0
        
        var currentRatio : CGFloat = actualWidth / actualHeight
        let maxRatio : CGFloat = maxWidth / maxHeight
        
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if currentRatio < maxRatio {
                //adjust width according to maxHeight
                currentRatio = maxHeight / actualHeight;
                actualWidth = currentRatio * actualWidth;
                actualHeight = maxHeight;
            } else if currentRatio > maxRatio {
                //adjust height according to maxWidth
                currentRatio = maxWidth / actualWidth;
                actualHeight = currentRatio * actualHeight;
                actualWidth = maxWidth;
            } else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let imageRect : CGRect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(imageRect.size)
        self.draw(in: imageRect)
        
        guard let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            
            return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
        
        guard let tempData : Data = newImage.jpegData(compressionQuality: compressionQuality) else {
            
            UIGraphicsEndImageContext(); return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
        
        UIGraphicsEndImageContext();
        
        if let finalImage : UIImage = UIImage(data: tempData) {
            return (image: finalImage, data: tempData)
        } else {
            return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
    }
}

extension Data {
    
    
    var imageType: String {
        
        let array = [UInt8](self)
        
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "png"
        }
        return ext
    }
    
}


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension URL {
    
//    func getInfo() -> (bytes: Double, kb: Double, mb: Double, gb: Double) {
//        
//        do {
//            
//            let res = try self.resourceValues(forKeys: [.fileSizeKey])
//            
//            if let resBytes : Int = res.fileSize, let resBytesInt64 : Int64 = Int64(resBytes) {
//                
//                return (bytes: Double(Units(bytes: resBytesInt64!).bytes),
//                        kb: Double(Units(bytes: resBytesInt64!).kilobytes),
//                        mb: Double(Units(bytes: resBytesInt64!).megabytes),
//                        gb: Double(Units(bytes: resBytesInt64!).gigabytes));
//            }
//        } catch { }
//        
//        return (bytes: 0.0, kb: 0.0, mb: 0.0, gb: 0.0);
//    }
}

public struct Units {
    
    public let bytes: Int64
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) gb"
        default:
            return "\(bytes) bytes"
        }
    }
}



extension String
{
    func firstLetter() -> String
    {
        guard let firstChar = self.first else {
            return ""
        }
        return String(firstChar)
    }
    
    
    
    func between(left: String, right: String) -> String? {
        
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            ,leftRange.upperBound <= rightRange.lowerBound else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    
    func getHtml() -> (string: String?, attributedString: NSAttributedString?) {
        
        guard let data = data(using: .utf8) else { return (string: nil, attributedString: nil) }
        
        do {
            let attStr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return (string: attStr.string, attributedString: attStr)
        } catch {
            print("error:", error)
            return (string: nil, attributedString: nil)
        }
    }
  
    func capitalizingFirstLetter() -> String {
          return prefix(1).capitalized + dropFirst()
      }

  
    mutating func capitalizeFirstLetter() {
          self = self.capitalizingFirstLetter()
      }
}

extension Double {
    
    /// Rounds the double to decimal places value
    func roundToPlaces(places: Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension NSMutableAttributedString
{
    func  appendAttributedString(string: String,
                                 color: UIColor? = nil,
                                 backgroundColor: UIColor? = nil,
                                 strikethroughStyle: Int? = nil,
                                 shadowBlurRadius: Int? = nil,
                                 shadowOffset: CGSize? = nil,
                                 shadowColor: UIColor? = nil,
                                 strokeWidth: Int? = nil,
                                 underlineStyle: NSUnderlineStyle? = nil,
                                 font: UIFont? = nil)
    {
        self.append(APP_FUNC.getAttributedString(string: string, color: color, backgroundColor: backgroundColor, strikethroughStyle: strikethroughStyle, shadowBlurRadius: shadowBlurRadius, shadowOffset: shadowOffset, shadowColor: shadowColor, strokeWidth: strokeWidth, underlineStyle: underlineStyle, font: font))
    }
}

extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                    b = CGFloat(hexNumber & 0x0000FF) / 255.0

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}


extension UILabel {
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        
        return ceil(labelSize.width)
    }
}


extension UITextField
{
    func setFont(font: FontName, size: CGFloat)
    {
        self.font = UIFont(name: font.rawValue, size: APP_FUNC.getFontSize(size: size))!
    }
    
    func setLeftPading(padding: CGFloat) {
        
        let padView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        padView.backgroundColor = UIColor.clear
        self.leftView = padView
        self.leftViewMode = .always
    }
    
    func setRightPading(padding: CGFloat) {
        
        let padView = UIView(frame: CGRect(x: self.frame.size.width - padding, y: 0, width: padding, height: self.frame.size.height))
        padView.backgroundColor = UIColor.clear
        self.rightView = padView
        self.rightViewMode = .always
    }
}

extension ACFloatingTextfield
{
    
    func  setAttributedString(string: String,
                              color: UIColor? = nil,
                              backgroundColor: UIColor? = nil,
                              strikethroughStyle: Int? = nil,
                              shadowBlurRadius: Int? = nil,
                              shadowOffset: CGSize? = nil,
                              shadowColor: UIColor? = nil,
                              strokeWidth: Int? = nil,
                              underlineStyle: NSUnderlineStyle? = nil,
                              font: UIFont? = nil)
    {
        self.attributedText = APP_FUNC.getAttributedString(string: string, color: color, backgroundColor: backgroundColor, strikethroughStyle: strikethroughStyle, shadowBlurRadius: shadowBlurRadius, shadowOffset: shadowOffset, shadowColor: shadowColor, strokeWidth: strokeWidth, underlineStyle: underlineStyle, font: font)
    }
    
    func setACTxt()
    {
        self.font = UIFont(name: FontName.Regular.rawValue, size: APP_FUNC.getFontSize(size: FontSize.Txt_Default.rawValue))!
        
        self.lineColor = UIColor.clear
        self.selectedLineColor = UIColor.clear
        
        self.placeHolderColor = APP_COL.TxtUnSelPlaceHolder
        self.selectedPlaceHolderColor = APP_COL.TxtSelPlaceHolder
        
        self.textColor = APP_COL.TxtText
    }
    
    func setACTxtLine() {
        self.font = UIFont(name: FontName.Regular.rawValue, size: APP_FUNC.getFontSize(size: FontSize.Txt_Default.rawValue))!
        
        self.lineColor = APP_COL.TxtUnSelPlaceHolder
        self.selectedLineColor = APP_COL.TxtSelPlaceHolder
        
        self.placeHolderColor = APP_COL.TxtUnSelPlaceHolder
        self.selectedPlaceHolderColor = APP_COL.TxtUnSelPlaceHolder
        
        self.textColor = APP_COL.TxtText
    }

}

extension UINavigationController: UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
