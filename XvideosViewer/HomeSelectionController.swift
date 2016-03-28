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
    var bounds = UIScreen.mainScreen().bounds
    var scroll = UIScrollView()
    var field = UITextField()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
    var selectedSite: String = ""
    var baseURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.blackColor()
        showPage(actualPage)
    }
    
    
    func showPage(actualPage: Int){
        videos = [Video]()
        self.isSearch = false
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        if(selectedSite == "YouPorn")
        {
            let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")!
            YouPornCharge(url)
        }
        if(selectedSite == "Xvideos")
        {
            var tempurl = "http://www.xvideos.com/"
            if(actualPage != 0)
            {
                tempurl = "http://www.xvideos.com/new/\(actualPage)"
            }
               let url = NSURL(string:tempurl)!
            XvideosCharge(url)
        }
        if(selectedSite == "Pornhub")
        {
            var tempurl = "http://www.pornhub.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.pornhub.com/video?page=\(actualPage)"
            }
             let url = NSURL(string:tempurl)!
            PornhubCharge(url)
        }
        if(selectedSite == "RedTube")
        {
            var tempurl = "http://www.redtube.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.redtube.com?page=\(actualPage)"
            }
            let url = NSURL(string:tempurl)!
            RedTubeCharge(url)
        }
        if(selectedSite == "Tube8")
        {
            var tempurl = "http://www.tube8.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.tube8.com/latest/page/\(actualPage)/"
            }
            let url = NSURL(string:tempurl)!
            Tube8Charge(url)
        }
        if(selectedSite == "PornMD")
        {
            let tempurl = "http://www.pornmd.com"
            
            let url = NSURL(string: tempurl)!
            PornMDCharge(url)
        }
        if(selectedSite == "Thumbzilla")
        {
            var tempurl = "http://www.thumbzilla.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.thumbzilla.com/?page=\(actualPage + 1)"
            }
            let url = NSURL(string:tempurl)!
            ThumbzillaCharge(url)
        }
        if(selectedSite == "XTube")
        {
            var tempurl = "http://www.xtube.com"
            if(actualPage != 0)
            {
                tempurl = "http://www.xtube.com/video/\(actualPage + 1)"
            }
            let url = NSURL(string:tempurl)!
            ThumbzillaCharge(url)
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
    
    func YouPornCharge(url: NSURL) {
//             let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for var i in 0 ..< splitted.count
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].rangeOfString("\n")) == nil)
                    {
                        i += 1
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "").stringByRemovingPercentEncoding
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    print(img)
                    let video = Video(link: link, imageLink: img, title: title!)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()

    }
    
    func XvideosCharge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "<img\\s+(?:[^>]*?\\s+)?src=\"http://img\\-([^\"]*)\"")
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp: "<a\\s+(?:[^>]*?\\s+)?href=\"/video([^\"]*)\"?\\stitle=\"([^\"]*)\"")
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = imageLink[i].stringByReplacingOccurrencesOfString("<img src=",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let href = titleAndHref[i].stringByReplacingOccurrencesOfString("<a ",withString: "").stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.xvideos.com").characters.split{$0 == "\""}.map(String.init)
                    let video = Video(link: href[0], imageLink: imglinkTemp, title: href[2])
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    func PornhubCharge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("\t", withString: "")
            var imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp:
                "<img\\s+(?:[^>]*?\\s+)?data-end")//"<img\\s+(?:[^>]*?\\s+)?src=\"http://([^\"]*)?([^<]*)"
            var titleAndHref = Utils.GetStringsByRegularExpression(stringa, regularexp:
                "class=\"phimage\">(\\s*)<a\\s+(?:[^>]*?\\s+)?href=\"/view_video.php?([^\"]*)\"?\\stitle=\"([^\"]*)\"")
            print(imageLink.count)
            print(titleAndHref.count)
            if(imageLink.count == titleAndHref.count)
            {
                for i in 0 ..< titleAndHref.count
                {
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i],regularexp: "data-smallthumb=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("data-smallthumb=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.pornhub.com").stringByReplacingOccurrencesOfString("\"", withString: "")
                          let title = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "title=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    
    func RedTubeCharge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
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
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "data-src=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("data-src=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.redtube.com").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "title=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    
    func Tube8Charge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
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
                    let imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "src=\"?([^\"]*)\"?")[0].stringByReplacingOccurrencesOfString("src=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "title=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    
    func ThumbzillaCharge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        
            let imageLink = Utils.GetStringsByRegularExpression(stringa, regularexp: "data-original=\"?([^\"]*)\"?")
            var href = Utils.GetStringsByRegularExpression(stringa, regularexp: "js-thumb\"\\shref=\"[^\"]*\"")
              var title = Utils.GetStringsByRegularExpression(stringa, regularexp: "info\">(\\s*)<span\\s+(?:[^>]*?\\s+)?class=\"title\">(.*?)<")
        
            let uniqueimage = imageLink.unique
            print(uniqueimage.count)
            if(uniqueimage.count == title.count && title.count == href.count)
            {
                for i in 0 ..< href.count
                {
                    let imglinkTemp = uniqueimage[i].stringByReplacingOccurrencesOfString("data-original=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("//", withString: "http://")
                    let href = Utils.GetStringsByRegularExpression(href[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.thumbzilla.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(">", withString: ">")
                    let title = Utils.GetStringsByRegularExpression(title[i], regularexp: ">(.*?)<")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    
    func XTubeCharge(url: NSURL){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
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
                      var imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "src=\"?([^\"]*)\"?")[0].stringByReplacingOccurrencesOfString("src=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    if(imageLink[i].containsString("placeholder"))
                    {
                       imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "data-lazySrc=\"?([^\"]*)\"?")[0].stringByReplacingOccurrencesOfString("data-lazySrc=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    }
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.xtube.com").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "title=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    func PornMDCharge(url: NSURL){
        if(url == NSURL(string: "http://www.pornmd.com"))
        {
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }else{
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
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
                    var imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "src=\"?([^\"]*)\"?")[0].stringByReplacingOccurrencesOfString("src=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    if(imageLink[i].containsString("placeholder"))
                    {
                        imglinkTemp = Utils.GetStringsByRegularExpression(imageLink[i], regularexp: "data-lazySrc=\"?([^\"]*)\"?")[0].stringByReplacingOccurrencesOfString("data-lazySrc=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    }
                    let href = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "href=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.xtube.com").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let title = Utils.GetStringsByRegularExpression(titleAndHref[i], regularexp: "title=\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("title=\"",withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByRemovingPercentEncoding
                    let video = Video(link: href, imageLink: imglinkTemp, title: title!)
                    self.videos.append(video)
                }
            }
            else{
                //refresh button
            }
            dispatch_async(dispatch_get_main_queue()){
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
                self.scroll.scrollEnabled = true
            }
        }
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

    
    func searchText(textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.isSearch = true
        self.selectedSort = "relevance"
        if(selectedSite == "YouPorn")
        {
                   let url = NSURL(string: "http://www.youporn.com/search/?query=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)")!
            YouPornCharge(url)
        }
        if(selectedSite == "Xvideos")
        {
              let url = NSURL(string: "http://www.xvideos.com/?k=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&p=\(actualPage)")!
            XvideosCharge(url)
        }
        if(selectedSite == "Pornhub")
        {
            let tempurl = "http://www.pornhub.com/video/search?search=?query=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
            let url = NSURL(string:tempurl)!
            PornhubCharge(url)
        }
        if(selectedSite == "RedTube"){
            let tempurl = "http://www.redtube.com/?search=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
            let url = NSURL(string:tempurl)!
            RedTubeCharge(url)
        }
        if(selectedSite == "Tube8")
        {
            let tempurl = "http://www.tube8.com/searches.html?q=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
            let url = NSURL(string:tempurl)!
            Tube8Charge(url)
        }
//        if(selectedSite == "PornMD")
//        {
//            let tempurl = "http://www.pornmd.com/straight/\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
//        }
        if(selectedSite == "Thumbzilla")
        {
            let tempurl = "http://www.thumbzilla.com/video/search?q=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage + 1)"
            let url = NSURL(string:tempurl)!
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
    
    func SortBySearch(howSort: String,textToSearch: String){
        videos = [Video]()
        self.isSearch = true
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
    
    func TextField(index: Int)
    {
        field.frame =  calculatePositionLarger(index)
        field.backgroundColor = UIColor.whiteColor()
        scroll.addSubview(field)
        
    }
    
    func searchButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Search", forState: .Normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(HomeSelectionController.search(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func homeButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Home", forState: .Normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: #selector(HomeSelectionController.home(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    func nextButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Next Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: #selector(HomeSelectionController.next(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    func sortButton(index: Int,text: Selector){
        let button = UIButton(type: UIButtonType.System)
        let title = text.description.stringByReplacingOccurrencesOfString(":", withString: "")
        if(selectedSort == title)
        {
            button.backgroundColor = UIColor.grayColor()
        }else{
            button.backgroundColor = UIColor.blackColor()
        }
        button.frame =  calculatePosition(index)
        button.setTitle(title,forState: .Normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: text, forControlEvents: .PrimaryActionTriggered)
        
        button.clipsToBounds = true
        scroll.addSubview(button)
    }

    
    
    func previousButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.frame =  calculatePosition(index)
        button.setTitle("Previous Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: #selector(HomeSelectionController.previous(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    func tapped(sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegueWithIdentifier("Video", sender: object)
    }
    

    func next(sender: UIButton) {
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
    
    
    func previous(sender: UIButton) {
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
    
    func home(sender: UIButton){
        self.actualPage = 0
        self.showPage(actualPage)
    }
    
    
    func search(sender: UIButton){
        self.actualPage = 0
        self.searchText(field.text!)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destinationViewController as! VideoController
            vc.video = video
            vc.webSiteTitle = selectedSite
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculatePosition(index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func calculatePositionLarger(index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(600) + 30)
        let width = CGFloat(600)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func calculatePosition(index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height = CGFloat(169)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    
    func calculatePositionSite(index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 30)
        let width = CGFloat(300)
        let height = CGFloat(120)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func createButton(image: UIImage, index: Int,video: Video){
        let button = UIButton(type: UIButtonType.System)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        button.titleLabel?.lineBreakMode = .ByTruncatingTail
        button.titleLabel?.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Arial", size: 25)
        button.setTitle(String(htmlEncodedString: video.Title), forState: .Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.frame =  calculatePosition(index, image: image)
        button.setBackgroundImage(image, forState: .Normal)
        button.tag = index - 5
        button.addTarget(self, action: #selector(HomeSelectionController.tapped(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.clipsToBounds = true
    }
    
    func chargeImageAsync(image: String, index: Int, video: Video){
        let url = NSURL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = UIImage(named: "ImageNotfound.png")
            dispatch_async(dispatch_get_main_queue()){
                self.createButton(image!,index: index,video: video)
            }
        }else{
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()){
                    self.createButton(image!,index: index,video: video)
                }
            }
            task.resume()
        }
    }
    


}