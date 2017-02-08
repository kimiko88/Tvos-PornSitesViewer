//
//  HomeSelectionController.swift
//  XvideosViewer
//
//  Created by kimiko88 on 22/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//
//        let muturl = NSMutableURLRequest(URL: NSURL(string:tempurl)!)
//
//        muturl.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36", forHTTPHeaderField: "User-Agent")
//let url = muturl as NSURLRequest

import Foundation
import UIKit

class Video{
    var Link: String
    var ImageLink: String
    var Title: String
    init(link: String, imageLink: String, title: String)
    {
        Link = link
        ImageLink = imageLink
        Title = title
    }
}


extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

class HomeSelectionController: UIViewController {
    
    var videos = [Video]()
    var actualPage = 0;
    var bounds = UIScreen.main.bounds
    var scroll = UIScrollView()
    var field = UITextField()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
    var selectedSite: String = ""
    var baseURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.black
        showPage(actualPage)
    }
    
    
    func showPage(_ actualPage: Int){
        videos = [Video]()
        self.isSearch = false
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        if(selectedSite == "YouPorn")
        {
            let url = URL(string: "http://www.youporn.com/?page=\(actualPage)")!
            YouPornCharge(url)
        }
        if(selectedSite == "Xvideos")
        {
            var tempurl = "http://www.xvideos.com/"
            if(actualPage != 0)
            {
                tempurl = "http://www.xvideos.com/new/\(actualPage)"
            }
               let url = URL(string:tempurl)!
            XvideosCharge(url)
        }
        if(selectedSite == "Pornhub")
        {
            var tempurl = "http://www.pornhub.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.pornhub.com/video?page=\(actualPage)"
            }
             let url = URL(string:tempurl)!
            PornhubCharge(url)
        }
        if(selectedSite == "RedTube")
        {
            var tempurl = "http://www.redtube.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.redtube.com?page=\(actualPage)"
            }
            let url = URL(string:tempurl)!
            RedTubeCharge(url)
        }
        if(selectedSite == "Tube8")
        {
            var tempurl = "http://www.tube8.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.tube8.com/latest/page/\(actualPage)/"
            }
            let url = URL(string:tempurl)!
            Tube8Charge(url)
        }
        if(selectedSite == "PornMD")
        {
            let tempurl = "http://www.pornmd.com"
            
            let url = URL(string: tempurl)!
            PornMDCharge(url)
        }
        if(selectedSite == "Thumbzilla")
        {
            var tempurl = "http://www.thumbzilla.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.thumbzilla.com/?page=\(actualPage + 1)"
            }
            let url = URL(string:tempurl)!
            ThumbzillaCharge(url)
        }
        if(selectedSite == "XTube")
        {
            var tempurl = "http://www.xtube.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.xtube.com/video/\(actualPage + 1)"
            }
            let url = URL(string:tempurl)!
            XTubeCharge(url)
        }
//        if(selectedSite == "YouJizz")
//        {
//            var tempurl = "http://www.youjizz.com"
//            if(actualPage != 0)
//            {
//                tempurl = "http://www.youjizz.com/page/\(actualPage + 1).html"
//            }
//            let url = NSURL(string:tempurl)!
//            YouJizzCharge(url)
//        }

    }
    
    func YouPornCharge(_ url: URL) {
//             let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for var i in 0 ..< splitted.count
            {
                let oo = splitted[i]
                if (oo.range(of: "href=\"/watch/") != nil && splitted[i + 1].range(of: "class='video-box-image'") != nil){
                    let link = oo.replacingOccurrences(of: "href=\"",with: "http://www.youporn.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\">", with: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.replacingOccurrences(of: " title=\"", with: "").replacingOccurrences(of: "\">\n<img", with: "").removingPercentEncoding
                    let img = splitted[i+1].replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    print(img)
                    let video = Video(link: link, imageLink: img, title: title!)
                    self.videos.append(video)
                }
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()

    }
    
    func XvideosCharge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "<img\\s+(?:[^>]*?\\s+)?src=\"http://img\\-([^\"]*)\"")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\s+href=\"/video([^\"]*)\"?\\stitle=\"([^\"]*)\"")
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = imageLink[i].replacingOccurrences(of: "<img src=",with: "").replacingOccurrences(of: "\"", with: "")
                    let href = titleAndHref[i].replacingOccurrences(of: "<a ",with: "").replacingOccurrences(of: "href=\"",with: "http://www.xvideos.com").characters.split{$0 == "\""}.map(String.init)
                    let video = Video(link: href[0], imageLink: imglinkTemp, title: href[2])
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    func PornhubCharge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "")
            var imageLink = Utils.GetStringsByRegularExpression(stringa as NSString, regularexp:
                "<imgsrc=\"([^\"]*)\".*?data-end=\".*?\"[^>]*>")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa as NSString, regularexp:
                "class=\"title\"><a\\s+(?:[^>]*?\\s+)?href=\"/view_video.php?([^\"]*)\"?\\stitle=\"([^\"]*)\"")
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString,regularexp: "data-mediumthumb=\"[^\"]*\"")[0].replacingOccurrences(of: "data-mediumthumb=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "http://www.pornhub.com").replacingOccurrences(of: "\"", with: "")
                          let title = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "title=\"[^\"]*\"")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "\"", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    
    func RedTubeCharge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "span>(\\s*)<img\\s+(?:[^>]*?\\s+)?src=\"?([^\"]*)\"?\\s")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\s+(?:[^>]*?\\s+)?class=\"video-thumb([^\"]*)\"?")
            print(imageLink)
            print(titleAndHref)
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "data-src=\"[^\"]*\"")[0].replacingOccurrences(of: "data-src=\"",with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "//", with: "http://")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "http://www.redtube.com").replacingOccurrences(of: "\"", with: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "title=\"[^\"]*\"")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "\"", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    
    func Tube8Charge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "class=\"videoThumbs\"\\s+(?:[^>]*?\\s+)?src=\"?([^\"]*)\"?")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "video_title\">(\\s*)<a\\s+(?:[^>]*?\\s+)?href=\"?([^\"]*)\"?\\stitle=\"?([^\"]*)\"?")
            print(imageLink)
            print(titleAndHref)
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "src=\"?([^\"]*)\"?")[0].replacingOccurrences(of: "src=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "title=\"[^\"]*\"")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "\"", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    
    func ThumbzillaCharge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        
            let imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "data-original=\"?([^\"]*)\"?")
            var href = Utils.GetStringsByRegularExpression(stringa, regularexp: "js-thumb\"\\shref=\"[^\"]*\"")
              var title = Utils.GetStringsByRegularExpression(stringa, regularexp: "info\">(\\s*)<span\\s+(?:[^>]*?\\s+)?class=\"title\">(.*?)<")
        
            let uniqueimage = imageLink.unique
            print(uniqueimage.count)
            if(uniqueimage.count == title.count && title.count == href.count)
            {
                for i in 0 ..< href.count
                {
                    let imglinkTemp = uniqueimage[i].replacingOccurrences(of: "data-original=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    let href = Utils.GetStringsByRegularExpression(href[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "http://www.thumbzilla.com").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ">", with: ">")
                    let title = Utils.GetStringsByRegularExpression(title[i] as NSString, regularexp: ">(.*?)<")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    
    
    func XTubeCharge(_ url: URL){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "video\"(\\s*)>(\\s*)<(.*?)>")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\shref=\"/video-watch(.*?)>")
            print(imageLink)
            print(titleAndHref)
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                      var imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "src=\"?([^\"]*)\"?")[0].replacingOccurrences(of: "src=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    if(imageLink[i].contains("placeholder"))
                    {
                       imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "data-lazySrc=\"?([^\"]*)\"?")[0].replacingOccurrences(of: "data-lazySrc=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    }
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "http://www.xtube.com").replacingOccurrences(of: "\"", with: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "title=\"[^\"]*\"")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "\"", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
//                self.TextField(i)
                i += 3
//                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
    }
    func PornMDCharge(_ url: URL){
        if(url == URL(string: "http://www.pornmd.com"))
        {
            DispatchQueue.main.async{
                var i = 1;
                                self.TextField(i)
                i += 3
                                self.searchButton(i)
                i += 1
//                for video in self.videos{
//                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
//                    i += 1;
//                }
//                self.nextButton(i)
//                i += 1;
//                if(self.actualPage > 0){
//                    self.previousButton(i)
//                    i += 1
//                }
//                
//                self.homeButton(i)
//                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }else{
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "video\"(\\s*)>(\\s*)<(.*?)>")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\shref=\"/video-watch(.*?)>")
            print(imageLink)
            print(titleAndHref)
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    var imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "src=\"?([^\"]*)\"?")[0].replacingOccurrences(of: "src=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    if(imageLink[i].contains("placeholder"))
                    {
                        imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i] as NSString, regularexp: "data-lazySrc=\"?([^\"]*)\"?")[0].replacingOccurrences(of: "data-lazySrc=\"",with: "").replacingOccurrences(of: "\"", with: "")
                    }
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "href=\"[^\"]*\"")[0].replacingOccurrences(of: "href=\"",with: "http://www.xtube.com").replacingOccurrences(of: "\"", with: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i] as NSString, regularexp: "title=\"[^\"]*\"")[0].replacingOccurrences(of: "title=\"",with: "").replacingOccurrences(of: "\"", with: "").removingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            DispatchQueue.main.async{
                var i = 1;
                //                self.TextField(i)
                i += 3
                //                self.searchButton(i)
                i += 1
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i += 1;
                }
                self.nextButton(i)
                i += 1;
                if(self.actualPage > 0){
                    self.previousButton(i)
                    i += 1
                }
                
                self.homeButton(i)
                i += 1
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.isScrollEnabled = true
            }
        }) 
        task.resume()
        }
    }
    
//    func YouJizzCharge(url: NSURL){
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//            print(stringa)
//            let imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "data-original=\"[^\"]*\"")
//            var href = Utils.GetStringsByRegularExpression(stringa, regularexp: "frame\"(.*?)href=[\"|'](.*?)[\"|']")
//            var title = Utils.GetStringsByRegularExpression(stringa, regularexp: "title1\"(.*?)<")
//            print(imageLink)
//            print(href)
//            print(title)
//            print(imageLink.count)
//            print(href.count)
//            print(title.count)
////            let uniqueimage = imageLink.unique
////            print(uniqueimage.count)
//            if(imageLink.count == title.count && title.count == href.count)
//            {
//                for i in 0 ..< href.count
//                {
//                    print(imageLink[i])
//                    let imglinkTemp = imageLink[i].stringByReplacingOccurrencesOfString("data-original=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
//                    print(imglinkTemp)
//                    print(href[i])
//                    let href = Utils.GetStringsByRegularExpression(href[i], regularexp: "href=[\"|'][^\"|^']*[\"|']")[0].stringByReplacingOccurrencesOfString("href='",withString: "http://www.youjizz.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("'", withString: "").stringByReplacingOccurrencesOfString(">", withString: ">")
//                    print(href)
//                    print(title[i])
//                    let title = Utils.GetStringsByRegularExpression(title[i], regularexp: ">(.*?)<")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByRemovingPercentEncoding
//                    print(title)
//                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
//                    self.videos.append(video)
//                }
//            }
//            else{
//                //refresh button
//            }
//            dispatch_async(dispatch_get_main_queue()){
//                var i = 1;
//                self.TextField(i)
//                i += 3
//                self.searchButton(i)
//                i += 1
//                for video in self.videos{
//                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
//                    i += 1;
//                }
//                self.nextButton(i)
//                i += 1;
//                if(self.actualPage > 0){
//                    self.previousButton(i)
//                    i += 1
//                }
//                
//                self.homeButton(i)
//                i += 1
//                
//                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
//                self.scroll.scrollEnabled = true
//            }
//        }
//        task.resume()
//    }

    
    func searchText(_ textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.isSearch = true
        self.selectedSort = "relevance"
        if(selectedSite == "YouPorn")
        {
                   let url = URL(string: "http://www.youporn.com/search/?query=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage + 1)")!
            YouPornCharge(url)
        }
        if(selectedSite == "Xvideos")
        {
              let url = URL(string: "http://www.xvideos.com/?k=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&p=\(actualPage)")!
            XvideosCharge(url)
        }
        if(selectedSite == "Pornhub")
        {
            let tempurl = "http://www.pornhub.com/video/search?search=?query=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage + 1)"
            let url = URL(string:tempurl)!
            PornhubCharge(url)
        }
        if(selectedSite == "RedTube"){
            let tempurl = "http://www.redtube.com/?search=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage + 1)"
            let url = URL(string:tempurl)!
            RedTubeCharge(url)
        }
        if(selectedSite == "Tube8")
        {
            let tempurl = "http://www.tube8.com/searches.html?q=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage + 1)"
            let url = URL(string:tempurl)!
            Tube8Charge(url)
        }
//        if(selectedSite == "PornMD")
//        {
//            let tempurl = "http://www.pornmd.com/straight/\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
//        }
        if(selectedSite == "Thumbzilla")
        {
            let tempurl = "http://www.thumbzilla.com/video/search?q=\(textToSearch.replacingOccurrences(of: " ", with: "+"))&page=\(actualPage + 1)"
            let url = URL(string:tempurl)!
           ThumbzillaCharge(url)
        }
        
//        if(selectedSite == "YouJizz")
//        {
//            let tempurl = "http://www.youjizz.com/search/\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "-"))-\(actualPage + 1)"
//            let url = NSURL(string:tempurl)!
//            YouJizzCharge(url)
//        }
        
//        let url = NSURL(string: "http://www.xvideos.com/?k=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&p=\(actualPage)")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "<img\\s+(?:[^>]*?\\s+)?src=\"http://img\\-([^\"]*)\"")
//            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\s+(?:[^>]*?\\s+)?href=\"/video([^\"]*)\"?\\stitle=\"([^\"]*)\"")
//            if(imageLink.count == titleAndHref.count)
//            {
//                for i in 0 ..< titleAndHref.count
//                {
//                    let imglinkTemp = imageLink[i].stringByReplacingOccurrencesOfString("<img src=",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
//                    let href = titleAndHref[i].stringByReplacingOccurrencesOfString("<a ",withString: "").stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.xvideos.com").characters.split{$0 == "\""}.map(String.init)
//                    let video = Video(link: href[0], imageLink: imglinkTemp, title: href[2])
//                    self.videos.append(video)
//                }
//            }else{
//                //Refresh button
//            }
//            dispatch_async(dispatch_get_main_queue()){
//                var i = 1;
//                self.TextField(i)
//                i += 3
//                self.searchButton(i)
//                i += 1;
//                i += 1;//TODO remove when use sort
//                for video in self.videos{
//                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
//                    i += 1;
//                }
//                self.nextButton(i)
//                i += 1;
//                if(self.actualPage > 1){
//                    self.previousButton(i)
//                    i += 1
//                }
//                self.homeButton(i)
//                i += 1
//                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
//                self.scroll.scrollEnabled = true
//            }
//        }
//        task.resume()
    }
    
    func SortBySearch(_ howSort: String,textToSearch: String){
        videos = [Video]()
        self.isSearch = true
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
    
    func TextField(_ index: Int)
    {
        field.frame =  calculatePositionLarger(index)
        field.backgroundColor = UIColor.white
        scroll.addSubview(field)
        
    }
    
    func searchButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Search", for: UIControlState())
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(HomeSelectionController.search(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func homeButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Home", for: UIControlState())
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(HomeSelectionController.home(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    func nextButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.frame =  calculatePosition(index)
        button.setTitle("Next Page", for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(HomeSelectionController.next(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    func sortButton(_ index: Int,text: Selector){
        let button = UIButton(type: UIButtonType.system)
        let title = text.description.replacingOccurrences(of: ":", with: "")
        if(selectedSort == title)
        {
            button.backgroundColor = UIColor.gray
        }else{
            button.backgroundColor = UIColor.black
        }
        button.frame =  calculatePosition(index)
        button.setTitle(title,for: UIControlState())
        //        button.tag = index + 1)
        button.addTarget(self, action: text, for: .primaryActionTriggered)
        
        button.clipsToBounds = true
        scroll.addSubview(button)
    }

    
    
    func previousButton(_ index: Int){
        let button = UIButton(type: UIButtonType.system)
        button.frame =  calculatePosition(index)
        button.setTitle("Previous Page", for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(HomeSelectionController.previous(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    func tapped(_ sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegue(withIdentifier: "Video", sender: object)
    }
    

    func next(_ sender: UIButton) {
        actualPage += 1
        //TODO ADD SORT PAGINATION
        if(!isSearch){
            if(!isSorted)
            {
                self.showPage(actualPage)
            }else
            {
                //                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    
    func previous(_ sender: UIButton) {
        actualPage -= 1
        if(!isSearch){
            if(!isSorted)
            {
                if(actualPage < 0)
                {
                    actualPage = 0
                }
                self.showPage(actualPage)
            }else
            {
                //                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    func home(_ sender: UIButton){
        self.actualPage = 0
        self.showPage(actualPage)
    }
    
    
    func search(_ sender: UIButton){
        self.actualPage = 0
        self.searchText(field.text!)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destination as! VideoController
            vc.video = video
            vc.webSiteTitle = selectedSite
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculatePosition(_ index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func calculatePositionLarger(_ index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(600) + 30)
        let width = CGFloat(600)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    func calculatePosition(_ index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height = CGFloat(169)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    
    func calculatePositionSite(_ index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height = CGFloat(120)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
    }
    
    
    func createButton(_ image: UIImage, index: Int,video: Video){
        let button = UIButton(type: UIButtonType.system)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), for: UIControlState())
        button.titleLabel?.font = UIFont(name: "Arial", size: 25)
        button.setTitle(String(htmlEncodedString: video.Title), for: UIControlState())
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.frame =  calculatePosition(index, image: image)
        button.setBackgroundImage(image, for: UIControlState())
        button.tag = index - 5
        button.addTarget(self, action: #selector(HomeSelectionController.tapped(_:)), for: .primaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.clipsToBounds = true
    }
    
    func chargeImageAsync(_ image: String, index: Int, video: Video){
        let url = URL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = UIImage(named: "ImageNotfound.png")
            DispatchQueue.main.async{
                self.createButton(image!,index: index,video: video)
            }
        }else{
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if(data != nil){
                let image = UIImage(data: data!)
                if(image != nil){
                DispatchQueue.main.async{
                    self.createButton(image!,index: index,video: video)
                }
                }
                }
            })
            task.resume()
        }
    }
    


}
