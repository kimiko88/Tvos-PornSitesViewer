//
//  VideoController.swift
//  XvideosViewer
//
//  Created by fabrizio chimienti on 21/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//

import UIKit


class DownloadLink{
    var Link: String
    var Title: String
    init(link: String, title: String){
        Link = link
        Title = title
    }
}

class VideoController: UIViewController {
    
    var bounds = UIScreen.mainScreen().bounds
    var video: Video!
    var webSiteTitle: String = ""
    
    var downloadLinks = [DownloadLink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(webSiteTitle == "YouPorn")
        {
           YouPornVideo()
        }
        if(webSiteTitle == "Xvideos")
        {
           XvideosVideo()
        }
        if(webSiteTitle == "Pornhub")
        {
            PornhubVideo()
        }
        if(webSiteTitle == "RedTube")
        {
            RedTubeVideo()
        }
        if(webSiteTitle == "Tube8")
        {
            Tube8Video()
        }
        if(webSiteTitle == "Thumbzilla")
        {
            ThumbzillaVideo()
        }
        if(webSiteTitle == "XTube")
        {
            XTubeVideo()
        }
        //USE Only flv but tvos can't read that format
//        if(webSiteTitle == "YouJizz")
//        {
//            YouJizzVideo()
//        }
//        let url = NSURL(string: self.video.Link)
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//            do {
//                let regex = try NSRegularExpression(pattern: "http://(\\w[^\"|^\']+/videos/\\w[^\"|^\']+)", options: NSRegularExpressionOptions.CaseInsensitive)
//                let range = NSMakeRange(0, stringa.length)
//                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
//                for match in matches{
//                    let result = stringa.substringWithRange(match.range)
//                    if(result.rangeOfString("mp4") != nil){
//                        var title = "mp4 quality"
//                        if(result.rangeOfString("3gp") != nil)
//                        {
//                            title = "3gp quality"
//                        }
//                        print(result)
//                     self.downloadLinks.append(DownloadLink(link: result, title: title))
//                    }
//                }
//            }catch{
//                print("error");
//            }
//            dispatch_async(dispatch_get_main_queue()){
//                var i = 0
//                
//                for downloadLink in self.downloadLinks{
//                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
//                    {
//                        self.createButton(downloadLink,index: i)
//                    }
//                    i += 1;
//                }
//            }
//        }
//        task.resume()
    }
    
    func YouPornVideo(){
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            for var i in 0 ..< splitted.count
            {
                let oo = splitted[i]
                
                if (oo.rangeOfString("downloadOption") != nil){
                    var tempLink = ""
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].rangeOfString("/a>")) == nil)
                    {
                        i += 1
                        if(splitted[i].rangeOfString("href=") != nil){
                            tempLink = splitted[i]
                        }
                        
                        if(splitted[i].rangeOfString("\'>") != nil && tempLink.characters.count > 2){
                            start = true
                        }
                        if(start)
                        {
                            tempTitle += " " + splitted[i]
                        }
                        
                    }
                    let link = tempLink.stringByReplacingOccurrencesOfString("href='", withString: "")
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" Video'>", withString: "").stringByReplacingOccurrencesOfString("</a>\n<span", withString: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    {
                        self.createButton(downloadLink,index: i)
                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    func XvideosVideo(){
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "http://(\\w[^\"|^\']+/videos/\\w[^\"|^\']+)", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    if(result.rangeOfString("mp4") != nil){
                        var title = "mp4 quality"
                        if(result.rangeOfString("3gp") != nil)
                        {
                            title = "3gp quality"
                        }
                        print(result)
                        self.downloadLinks.append(DownloadLink(link: result, title: title))
                    }
                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    {
                        self.createButton(downloadLink,index: i)
                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    func PornhubVideo(){
       
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "player_quality_\\w+\\s+=\\s\'[^\']*\'", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    var spliettd = result.characters.split{$0 == " "}.map(String.init)
                    let title = spliettd[0]
                    let link = spliettd[2].stringByReplacingOccurrencesOfString("'", withString: "")
                        print(result)
                        self.downloadLinks.append(DownloadLink(link: link, title: title))
                    }
//                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
//                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
//                    {
                        self.createButton(downloadLink,index: i)
//                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    
    func RedTubeVideo(){
        
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "\\{\"hd\"(.*?)\\}", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    let splitted = result.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").characters.split{$0 == ","}.map(String.init)
                    for split in splitted
                    {
                    let titlelink = split.characters.split{$0 == "\""}.map(String.init)
                        if(titlelink.count > 2)
                        {
                        let title = titlelink[0].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("{", withString: "")
                            print(title)
                        let link = titlelink[2].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "").stringByReplacingOccurrencesOfString("}", withString: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                        }
                    }
                }
                //                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    
    func Tube8Video(){
        
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "quality_\\w\\w\\w\\w\":\"[^\"]*\"", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    let splitted = result.characters.split{$0 == "\""}.map(String.init)
                    print(splitted)
                        if(splitted.count > 2 && splitted[2].characters.count > 10)
                        {
                            let title = splitted[0].stringByReplacingOccurrencesOfString("\"", withString: "")
                            print(title)
                            let link = splitted[2].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
                            self.downloadLinks.append(DownloadLink(link: link, title: title))
                        }
                }
                //                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    
    func  ThumbzillaVideo(){
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "data-quality=\"[^\"]*\">(\\w+)<", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    let link = Utils.GetStringsByRegularExpression(result, regularexp: "\"[^\"]*\"")[0].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("//", withString: "http://")
                    let title = Utils.GetStringsByRegularExpression(result, regularexp: ">(\\w*)<")[0].stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString("<", withString: "")
                    print(link)
                    if( link.characters.count > 10)
                    {
                        self.downloadLinks.append(DownloadLink(link: link, title: title))
                    }
                }
                //                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    func  XTubeVideo(){
        let url = NSURL(string: self.video.Link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            do {
                let regex = try NSRegularExpression(pattern: "quality_\\w\\w\\w\\w\":\"(.*?)\"", options: NSRegularExpressionOptions.CaseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substringWithRange(match.range)
                    let splitted = result.characters.split{$0 == "\""}.map(String.init)
if(splitted.count > 2)
{
                    let title = splitted[0]
                    let link = splitted[2].stringByRemovingPercentEncoding!
                        self.downloadLinks.append(DownloadLink(link: link, title: title))
                    }
                }
                //                }
            }catch{
                print("error");
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }
        task.resume()
    }
    
    //When tvos could read flv file
//    func  YouJizzVideo(){
//        let url = NSURL(string: self.video.Link)
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//            do {
//                let regex = try NSRegularExpression(pattern: "a(.*?)>Download", options: NSRegularExpressionOptions.CaseInsensitive)
//                let range = NSMakeRange(0, stringa.length)
//                let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
//                for match in matches{
//                    let result = stringa.substringWithRange(match.range)
//
//                        let link = Utils.GetStringsByRegularExpression(result, regularexp: "href=[\"|'][^\"|^']*[\"|']")[0].stringByReplacingOccurrencesOfString("href=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")//.stringByRemovingPercentEncoding!
//                    print(link)
//                      self.downloadLinks.append(DownloadLink(link: link+"&start=0", title: "flv"))
//                }
//                //                }
//            }catch{
//                print("error");
//            }
//            dispatch_async(dispatch_get_main_queue()){
//                var i = 0
//                
//                for downloadLink in self.downloadLinks{
//                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
//                    //                    {
//                    self.createButton(downloadLink,index: i)
//                    //                    }
//                    i += 1;
//                }
//            }
//        }
//        task.resume()
//    }
    
    func tapped(sender: UIButton) {
        let object = self.downloadLinks[sender.tag]
        self.performSegueWithIdentifier("SeeVideo", sender: object)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let video = sender as! DownloadLink
        if segue.identifier == "SeeVideo"{
            let vc = segue.destinationViewController as! AVVideoPlayerController
            vc.downloadVideo = video
        }
    }
    
    func createButton(download: DownloadLink, index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(1600) + 20)
        let width = CGFloat(1600)
        let height = CGFloat(180)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.System)
        button.frame =  CGRectMake(CGFloat(x), CGFloat(y), width, height)
        button.setTitle(download.Title, forState: .Normal)
        button.tag = index
        button.addTarget(self, action: #selector(VideoController.tapped(_:)), forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        self.view.addSubview(button)
        self.view.clipsToBounds = true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//        WHEN TVOS WILL READ .flv
//         let tempurl = NSURL(string: self.video.Link)
//                    let muturl = NSMutableURLRequest(URL: tempurl!)
//
//                    muturl.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36", forHTTPHeaderField: "User-Agent")
//            let url = muturl as NSURLRequest
//
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(url) {(data, response, error) in
//                let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//                //            print(stringa)
//                do {//<img.+?src=[\"'](.+?)[\"']"
//                    let regex = try NSRegularExpression(pattern: "flv_url=([^\\;]*)", options: NSRegularExpressionOptions.CaseInsensitive)
//                    let range = NSMakeRange(0, stringa.length)
//                    let matches = regex.matchesInString(stringa as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
//                    //                print(matches.count)
//                    for match in matches{
//                        let result = stringa.substringWithRange(match.range)
////                        if(result.rangeOfString("mp4") != nil){
////                            var title = "mp4 quality"
////                            if(result.rangeOfString("3gp") != nil)
////                            {
////                                title = "3gp quality"
////                            }
////                            print(result)
////                            self.downloadLinks.append(DownloadLink(link: result, title: title))
////                        }
//                        let link = result.stringByReplacingOccurrencesOfString("flv_url=", withString: "").stringByReplacingOccurrencesOfString("&amp", withString: "").stringByRemovingPercentEncoding!
//
//                         print(NSURL(string: result.stringByReplacingOccurrencesOfString("flv_url=", withString: "").stringByReplacingOccurrencesOfString("&amp", withString: "").stringByRemovingPercentEncoding!)!)
//                        self.downloadLinks.append(DownloadLink(link: link, title: "flv"))
//                    }
//                }catch{
//                    print("error");
//                }



