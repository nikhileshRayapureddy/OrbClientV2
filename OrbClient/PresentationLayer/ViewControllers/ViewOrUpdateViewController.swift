//
//  ViewOrUpdateViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 22/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
class ViewOrUpdateViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ParserDelegate,UITextViewDelegate {
    @IBOutlet weak var lblUrl: FRHyperLabel!
    @IBOutlet weak var vwPlayer: UIView!
    @IBOutlet weak var lblVideoStatus: UILabel!
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var imgBannerAd: UIImageView!
    @IBOutlet weak var lblBannerStatus: UILabel!
    @IBOutlet weak var imgFullAd: UIImageView!
    @IBOutlet weak var lblFullAdStatus: UILabel!
    @IBOutlet weak var lblShareContent1: UILabel!
    @IBOutlet weak var lblShareLink: UILabel!
    @IBOutlet weak var btnUpdateAdvertisement: UIButton!

    @IBOutlet weak var btnBannerAdEdit: UIButton!
    @IBOutlet weak var btnEditVideo: UIButton!
    @IBOutlet weak var btnFullAdEdit: UIButton!
    @IBOutlet weak var btnSMSEdit: UIButton!
    @IBOutlet weak var btnShareLink: UIButton!
    
    
    var isVideoEditClicked = false
    var isBannerAdEditClicked = false
    var isFullAdEditClicked = false
    
    var isVideoSelected = false
    var isBannerAdSelected = false
    var isFullAdSelected = false
    var isSMSEdit = false
    var isShareLink = false
    
    var bannerData = Data()
    var videoData = Data()
    var fullAdData = Data()

    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var userAds = UserAdsBO()
    
    var vwPopUp = CustomAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "View Or Update Ads",isSync: true)
        self.getUserads()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: ScreenWidth, height: 1450)
    }
    func getUserads()
    {
        app_delegate.showLoader(message: "Fetching data....")
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.getUserAds()
    }
    func updateShareLink()
    {
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.updateShareLinkWith(content: userAds.shareLink_Content, link: userAds.shareLink_PreviousURL)
    }
    override func syncClicked(sender:UIButton)
    {
        self.getUserads()
    }

    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        if tag == ParsingConstant.uploadImage.rawValue
        {
            if isFullAdSelected
            {
                isFullAdSelected = false
                self.uploadData(data: fullAdData)
            }
            else if isVideoSelected
            {
                isVideoSelected = false
                self.uploadData(data: videoData)
            }
            else
            {
                self.updateShareLink()
            }
        }
        else if tag == ParsingConstant.updateShareLink.rawValue
        {
            app_delegate.removeloder()
            DispatchQueue.main.async {
                self.showAlertWith(title: "Success!", message: object as! String)
            }

        }
        else
        {
            app_delegate.removeloder()
            userAds = object as! UserAdsBO
            DispatchQueue.main.async {
                self.bindata()
            }
        }
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        if tag == ParsingConstant.uploadImage.rawValue
        {
            DispatchQueue.main.async {
                self.showAlertWith(title: "Sorry!", message: error!)
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.showAlertWith(title: "Sorry!", message: error!)

            }
        }

    }
    override func menuClicked(sender: UIButton) {
        super.menuClicked(sender: sender)
        self.player.pause()
    }
    func bindata()
    {
        //binding Video
        
        
        /*
         var sourceURL = URL(string: "Your Asset URL")
         var asset = AVAsset(url: sourceURL!)
         var imageGenerator = AVAssetImageGenerator(asset: asset)
         var time = CMTimeMake(1, 1)
         var imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
         var thumbnail = UIImage(cgImage:imageRef)

 */
        let videoUrl = URL(string: userAds.video_ad)
        let item = AVPlayerItem(url: videoUrl!)
        self.player = AVPlayer(playerItem: item)
        self.avpController = AVPlayerViewController()
        self.avpController.player = self.player
        avpController.view.frame = CGRect(x: 0, y: 0, width: vwPlayer.frame.size.width, height: vwPlayer.frame.size.height)
        self.addChildViewController(avpController)
        vwPlayer.addSubview(avpController.view)
        lblVideoStatus.text = userAds.video_Status
        if lblVideoStatus.text?.lowercased() == "live"
        {
            lblVideoStatus.textColor = UIColor(red: 0, green: 113.0/255.0, blue: 0, alpha: 1.0)
        }
        else
        {
            lblVideoStatus.textColor = UIColor(red: 237.0/255.0, green: 77.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        }

        //binding Banner Ad
        imgBannerAd.kf.indicatorType = .activity
        imgBannerAd.kf.setImage(with: URL(string:userAds.banner_ad_url) ,
                                       placeholder: UIImage(named: "no-image"),
                                       options: [.transition(ImageTransition.fade(1))],
                                       progressBlock: { receivedSize, totalSize in
                                        
        },
                                       completionHandler: { image, error, cacheType, imageURL in
                                        
        })
        lblBannerStatus.text = userAds.banner_Status
        
        if lblBannerStatus.text?.lowercased() == "live"
        {
            lblBannerStatus.textColor = UIColor(red: 0, green: 113.0/255.0, blue: 0, alpha: 1.0)
        }
        else
        {
            lblBannerStatus.textColor = UIColor(red: 237.0/255.0, green: 77.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        }
        
        //binding Full Ad
        imgFullAd.kf.indicatorType = .activity
        imgFullAd.kf.setImage(with: URL(string:userAds.full_ad_url) ,
                                placeholder: UIImage(named: "no-image"),
                                options: [.transition(ImageTransition.fade(1))],
                                progressBlock: { receivedSize, totalSize in
                                    
        },
                                completionHandler: { image, error, cacheType, imageURL in
                                    
        })
        lblFullAdStatus.text = userAds.banner_Status
        if lblFullAdStatus.text?.lowercased() == "live"
        {
            lblFullAdStatus.textColor = UIColor(red: 0, green: 113.0/255.0, blue: 0, alpha: 1.0)
        }
        else
        {
            lblFullAdStatus.textColor = UIColor(red: 237.0/255.0, green: 77.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        }

        //binding ShareContent
        lblShareContent1.text = userAds.Text_default1 + " " + userAds.shareLink_Content +  userAds.Text_default2
        lblUrl.text = userAds.shareLink_Link
        lblUrl.setLinkForSubstring(userAds.shareLink_Link) { (hyperLabel, subString) in
            let link = URL(string: "https://www." + self.userAds.shareLink_Link)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(link!)
            }
        }

        //binding Share link
        lblShareLink.text = userAds.shareLink_PreviousURL

    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if isVideoEditClicked
        {
            var dataTemp = NSData()
            var videoUrl = NSURL()
            if let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                videoUrl = fileURL
                if let data = NSData(contentsOf: videoUrl as URL) {
                    dataTemp = data
                    print("Total bytes \(data.length)")
                }
            }
            
            if dataTemp.length/1024/1024 < 75
            {
                videoData = dataTemp as Data
                isVideoEditClicked = false
                isVideoSelected = true
                let item = AVPlayerItem(url: videoUrl as URL)
                self.player = AVPlayer(playerItem: item)
                self.avpController = AVPlayerViewController()
                self.avpController.player = self.player
            }
            else
            {
                self.showAlertWith(title: "Alert!", message: "Video size should be less than 75MB")
            }
            self.dismiss(animated: true, completion: nil)

        }
        else if isBannerAdEditClicked
        {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print("image height:",image.size.height)
            print("image width:",image.size.width)
            if image.size.width == 520 && image.size.height == 110
            {
                isBannerAdEditClicked = false
                isBannerAdSelected = true
                bannerData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 0.7)!
                imgBannerAd.contentMode = .scaleAspectFit
                imgBannerAd.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            else
            {
                self.showAlertWith(title: "Alert!", message: "Banner size should be 520 X 110 pixels.")
            }
            dismiss(animated:true, completion: nil)
        }
        else if isFullAdEditClicked
        {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            if image.size.width == 1280 && image.size.height == 850
            {
                
                isFullAdEditClicked = false
                isFullAdSelected = true
                fullAdData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 0.7)!
                imgFullAd.contentMode = .scaleAspectFit
                imgFullAd.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            else
            {
                self.showAlertWith(title: "Alert!", message: "Image size should be 1280 X 850 pixels.")
            }
            dismiss(animated:true, completion: nil)

        }
    }
    @IBAction func btnUpdateAdvertisementClicked(_ sender: UIButton) {
        
        if isBannerAdSelected
        {
            self.uploadData(data: bannerData)
        }
        else if isFullAdSelected
        {
            self.uploadData(data: fullAdData)
        }
        else if isVideoSelected
        {
            self.uploadData(data: videoData)
        }
        else if userAds.shareLink_PreviousURL != lblShareLink.text || lblShareContent1.text != userAds.Text_default1 + userAds.shareLink_Content +  userAds.Text_default2

        {
            app_delegate.showLoader(message: "Updating data....")
            self.updateShareLink()

        
        }

    }
    func uploadData(data:Data)
    {
        var dataType = ""
        var fileName = ""
        var contentType = ""
        var uploadString = ""

        if isBannerAdSelected{
            isBannerAdSelected = false

            dataType = image
            fileName = "\(NSDate().timeIntervalSince1970 * 1000)" + ".jpg"
            contentType = "image/jpeg"
            uploadString = "imageupload"
        }
        else if isFullAdSelected
        {
            isFullAdSelected = false
            dataType = banner
            fileName = "\(NSDate().timeIntervalSince1970 * 1000)" + ".jpg"
            contentType = "image/jpeg"
            uploadString = "bannerupload"
        }
        else if isVideoSelected
        {
            isVideoSelected = false
            dataType = video
            fileName = "\(NSDate().timeIntervalSince1970 * 1000)" + ".mov"
            contentType = "video/mov"
            uploadString = "videoupload"
        }
        app_delegate.showLoader(message: "uploading....")
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.uploadWith(data: data, dataType: dataType, fileName: fileName, contentType: contentType,uploadString:uploadString)
    }
    @IBAction func btnEditVideoClicked(_ sender: UIButton) {
        isVideoEditClicked = true
        self.openCamera()
    }
    
    @IBAction func btnBannerAdEditClicked(_ sender: UIButton) {
        isBannerAdEditClicked = true
        self.openCamera()
    }
    
    @IBAction func btnFullAdEditClicked(_ sender: UIButton) {
        isFullAdEditClicked = true
        self.openCamera()
    }
    
    @IBAction func btnSMSEditClicked(_ sender: UIButton) {
        vwPopUp =   (Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)![0] as? CustomAlertView)!
        vwPopUp.frame = CGRect(x:0,y: 0,width: ScreenWidth, height:ScreenHeight - 64)
        vwPopUp.txtVw.delegate = self
        isSMSEdit = true

        vwPopUp.txtVw.text = userAds.shareLink_Content
        vwPopUp.lblCharCount.text = "\(vwPopUp.txtVw.text.characters.count)//160"
        vwPopUp.btnBg.addTarget(self, action: #selector(btnPopUpBgClicked(sender:)), for: .touchUpInside)
        vwPopUp.btnCancel.addTarget(self, action: #selector(btnCancelClicked(sender:)), for: .touchUpInside)
        vwPopUp.btnUpdate.addTarget(self, action: #selector(btnUpdateClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(self.vwPopUp)
    }
    func btnPopUpBgClicked(sender:UIButton)
    {
        self.removePopUp()
    }
    func btnCancelClicked(sender:UIButton)
    {
        self.removePopUp()
    }
    func btnUpdateClicked(sender:UIButton)
    {
        if isSMSEdit
        {
            isSMSEdit = false
            userAds.shareLink_Content = vwPopUp.txtVw.text
            lblShareContent1.text = userAds.Text_default1 + " " + userAds.shareLink_Content +  userAds.Text_default2
            self.removePopUp()
        }
        else if isShareLink
        {
            isShareLink = false
            userAds.shareLink_PreviousURL = vwPopUp.txtVw.text
            lblShareLink.text = userAds.shareLink_PreviousURL
            self.removePopUp()
        }

    }
    func removePopUp()
    {
        vwPopUp.removeFromSuperview()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count > 160 && range.length == 0 {
            return false
        }
        vwPopUp.lblCharCount.text = "\(textView.text.characters.count)\\160"

        return true
    }
    @IBAction func btnShareLinkClicked(_ sender: UIButton) {
        vwPopUp =   (Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)![0] as? CustomAlertView)!
        vwPopUp.frame = CGRect(x:0,y: 0,width: ScreenWidth, height:ScreenHeight - 64)
        vwPopUp.txtVw.delegate = self
        isShareLink = true
        vwPopUp.txtVw.text = userAds.shareLink_PreviousURL
        vwPopUp.lblCharCount.text = "\(vwPopUp.txtVw.text.characters.count)//160"
        vwPopUp.btnBg.addTarget(self, action: #selector(btnPopUpBgClicked(sender:)), for: .touchUpInside)
        vwPopUp.btnCancel.addTarget(self, action: #selector(btnCancelClicked(sender:)), for: .touchUpInside)
        vwPopUp.btnUpdate.addTarget(self, action: #selector(btnUpdateClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(self.vwPopUp)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}