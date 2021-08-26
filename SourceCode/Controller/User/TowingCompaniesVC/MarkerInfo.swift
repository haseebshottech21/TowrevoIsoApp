//
//  MarkerInfo.swift
//  SwiftDemoApp
//


import UIKit

class MarkerInfo: UIView {
    @IBOutlet var viewMarkerContainer: UIView!
    @IBOutlet var imgBGImage: UIImageView!
    @IBOutlet var imgMarkerIcon: UIImageView!
    @IBOutlet var lblMarkerTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func initWith(owner: UIViewController!) -> MarkerInfo? {
        let infoView = Bundle.main.loadNibNamed("MarkerInfo", owner: owner, options: nil)?.first as? MarkerInfo
        return infoView
    }
    
    func setup(title: String, color: UIColor, icon: UIImage) {
      //  self.imgBGImage.image = bg.stretchableImage(withLeftCapWidth: 15, topCapHeight: 15)
        self.imgMarkerIcon.image = icon
        self.lblMarkerTitle.text = String(format: "%@", title)
        self.lblMarkerTitle.font = Utility.SetBold(Utility.Small_size_12())
        self.lblMarkerTitle.textColor = color
        self.layoutIfNeeded()
        
        
    }
    
    func snapShot() -> UIImage {
        self.layoutIfNeeded()
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: self.viewMarkerContainer.bounds)
            let image = renderer.image { rendererContext in
                self.viewMarkerContainer.layer.render(in: rendererContext.cgContext)
            }
            return image
        } else {
            return UIImage()
            // Fallback on earlier versions
        }
        
    }
}
