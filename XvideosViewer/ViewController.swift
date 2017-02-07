//
//  ViewController.swift
//  XvideosViewer
//
//  Created by kimiko88 on 21/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//

import UIKit
import Foundation


class WebSite{
    var ImageLink: String
    var Name: String
    var HomeURL: URL
    init(imageLink: String, name: String, homeURL: String)
    {
        ImageLink = imageLink
        Name = name
        HomeURL = URL(string: homeURL)!
    }
}


class ViewController: UIViewController {
    var videos = [Video]()
    var actualPage = 0;
    var bounds = UIScreen.main.bounds
    var scroll = UIScrollView()
    var field = UITextField()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
 var sites = [WebSite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.black
        SetSite()
        selectSite()
    }
    
    func SetSite() {
        self.sites.append(WebSite(imageLink: "http://cdn1f.static.youporn.phncdn.com/cb/bundles/youpornwebfront/images/l_youporn_black.png", name: "YouPorn", homeURL: "http://www.youporn.com"))
            
         self.sites.append(WebSite(imageLink: "http://img100.xvideos.com/videos/thumbs/xvideos.gif", name: "Xvideos", homeURL: "http://www.xvideos.com"))
        
         self.sites.append(WebSite(imageLink: "http://cdn1b.static.pornhub.phncdn.com/www-static/images/pornhub_logo_straight.png", name: "Pornhub", homeURL: "http://www.pornhub.com"))
        
        self.sites.append(WebSite(imageLink: "http://img01.redtubefiles.com/_thumbs/design/new-design/logo-new-design.png", name: "RedTube", homeURL: "http://www.redtube.com"))
        
        self.sites.append(WebSite(imageLink: "http://cdn1.static.tube8.phncdn.com/images/tube8-header-logo-2015.png", name: "Tube8", homeURL: "http://www.tube8.com"))
        
         self.sites.append(WebSite(imageLink: "https://cdn-d-static.pornhub.com/tz-static/images/pc/logo.png", name: "Thumbzilla", homeURL: "http://www.thumbzilla.com"))
        
        
            self.sites.append(WebSite(imageLink: "http://cdn1.static.xtube.com/v3_img/logo_xtube.png", name: "XTube", homeURL: "http://www.xtube.com"))
        
//           self.sites.append(WebSite(imageLink: "http://www.youjizz.com/gfx_new/yjlogo.jpeg", name: "YouJizz", homeURL: "http://www.youjizz.com"))
//        
//           self.sites.append(WebSite(imageLink: "http://eu-st.xhcdn.com/images/logo/logo.png", name: "xHamster", homeURL: "http://www.xhamster.com"))
    }
    
    
    func selectSite()
    {
        var i = 0;
        for site in sites{
            chargeSiteImageAsync(site.ImageLink, index: i, name: site.Name)
            i += 1
        }
    }
    
    

    func tappedSite(_ sender: UIButton) {
        let object = self.sites[sender.tag]
        self.performSegue(withIdentifier: "HomeSelection", sender: object)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let webSite = sender as! WebSite
        if segue.identifier == "HomeSelection"{
            let vc = segue.destination as! HomeSelectionController
            vc.selectedSite = webSite.Name
            vc.baseURL = webSite.HomeURL
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func calculatePositionSite(_ index: Int, image: UIImage) -> CGRect
    {
        //        let numImagePerRow = Int(bounds.width) / (Int(image.size.width) + 20)
        let numImagePerRow = Int(bounds.width) / (Int(300) + 25)
        //        let width = image.size.width
        //        let height = image.size.height
        let width = CGFloat(300)
        let height = CGFloat(120)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    
    func chargeSiteImageAsync(_ image: String, index: Int, name: String){
        let url = URL(string: image)
        if(( (url == nil || (url?.hashValue) == nil) || name == "PornMD")){
            var image = UIImage(named: "ImageNotfound.png")
            if(name == "PornMD")
            {
                image = UIImage(named: "PornMD.png")!
            }
            DispatchQueue.main.async{
                self.createSiteButton(image!,index: index,name: name)
            }
        }else{
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                let image = UIImage(data: data!)
                DispatchQueue.main.async{
                    self.createSiteButton(image!,index: index,name: name)
                }
            }) 
            task.resume()
        }
    }
    
    
    func createSiteButton(_ image: UIImage, index: Int,name: String){
        let button = UIButton(type: UIButtonType.system)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), for: UIControlState())
        button.titleLabel?.font = UIFont(name: "Arial", size: 25)
        button.setTitle(name, for: UIControlState())
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.frame =  calculatePositionSite(index, image: image)
        button.setBackgroundImage(image, for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(ViewController.tappedSite(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.clipsToBounds = true
    }
    
    
}

