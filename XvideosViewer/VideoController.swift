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
    
    var bounds = UIScreen.main.bounds
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
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            for var i in 0 ..< splitted.count
            {
                let oo = splitted[i]
                
                if (oo.range(of: "downloadOption") != nil){
                    var tempLink = ""
                    var tempTitle = ""
                    var start = false
                    i += 1
                    while((splitted[i].range(of: "/a>")) == nil)
                    {
                        i += 1
                        if(splitted[i].range(of: "href=") != nil){
                            tempLink = splitted[i]
                        }
                        
                        if(splitted[i].range(of: "\'>") != nil && tempLink.characters.count > 2){
                            start = true
                        }
                        if(start)
                        {
                            tempTitle += " " + splitted[i]
                        }
                        
                    }
                    let link = tempLink.replacingOccurrences(of: "href='", with: "")
                    let title = tempTitle.replacingOccurrences(of: " Video'>", with: "").replacingOccurrences(of: "</a>\n<span", with: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
            }
            
            
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    if(downloadLink.Title.range(of: "3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    {
                        self.createButton(downloadLink,index: i)
                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    func XvideosVideo(){
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "http://(\\w[^\"|^\']+/videos/\\w[^\"|^\']+)", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substring(with: match.range)
                    if(result.range(of: "mp4") != nil){
                        var title = "mp4 quality"
                        if(result.range(of: "3gp") != nil)
                        {
                            title = "3gp quality"
                        }
                        if(!self.downloadLinks.contains { $0.Link == result})
                        {
                        self.downloadLinks.append(DownloadLink(link: result, title: title))
                        }else
                        {
                            
                        }
                    }
                }
            }catch{
                print("error");
            }
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    if(downloadLink.Title.range(of: "3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    {
                        self.createButton(downloadLink,index: i)
                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    func PornhubVideo(){
       
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "player_quality_\\w+=\".*?\"", options: NSRegularExpression.Options.caseInsensitive)
                 let regexVariableCombination = try NSRegularExpression(pattern: "player_quality_\\w+=player.*?;", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let variables = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                let variablesCombination = regexVariableCombination.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                var variablesDictionary = [String:String]()
                for match in variables{
                    let result = stringa.substring(with: match.range)
                    var splitted = result.characters.split{$0 == "="}.map(String.init)
                    let nameVariable = splitted[0]
                    var contentVariable = splitted[1].replacingOccurrences(of: "\"", with: "")
                    let splittedCount = splitted.count
                    var index = 2;
                    while index < splittedCount{
                        contentVariable.append(splitted[index].replacingOccurrences(of: "\"", with: ""))
                        index += 1
                    }
                    variablesDictionary[nameVariable] = contentVariable
                    }
                for match in variablesCombination{
                    let result = stringa.substring(with: match.range)
                    var splitted = result.characters.split{$0 == "="}.map(String.init)
                    let title = splitted[0].replacingOccurrences(of: "player_quality_", with: "")
                    let contentVariable = splitted[1].replacingOccurrences(of: ";", with: "").replacingOccurrences(of: " ", with: "").characters.split{$0 == "+"}.map(String.init)
                    var link = ""
                    for contVariable in contentVariable{
                       link.append(variablesDictionary[contVariable]!)
                    }
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                }
//                }
            }catch{
                print("error");
            }
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
//                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
//                    {
                        self.createButton(downloadLink,index: i)
//                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    
    func RedTubeVideo(){
        
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "\\{\"hd\"(.*?)\\}", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substring(with: match.range)
                    let splitted = result.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").characters.split{$0 == ","}.map(String.init)
                    for split in splitted
                    {
                    let titlelink = split.characters.split{$0 == "\""}.map(String.init)
                        if(titlelink.count > 2)
                        {
                        let title = titlelink[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "{", with: "")
                            print(title)
                        let link = titlelink[2].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "}", with: "")
                    self.downloadLinks.append(DownloadLink(link: link, title: title))
                        }
                    }
                }
                //                }
            }catch{
                print("error");
            }
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    
    func Tube8Video(){
        
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "quality_\\w\\w\\w\\w\":\"[^\"]*\"", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substring(with: match.range)
                    let splitted = result.characters.split{$0 == "\""}.map(String.init)
                    print(splitted)
                        if(splitted.count > 2 && splitted[2].characters.count > 10)
                        {
                            let title = splitted[0].replacingOccurrences(of: "\"", with: "")
                            print(title)
                            let link = splitted[2].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\\", with: "")
                            self.downloadLinks.append(DownloadLink(link: link, title: title))
                        }
                }
                //                }
            }catch{
                print("error");
            }
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    
    func  ThumbzillaVideo(){
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "data-quality=\"[^\"]*\">(\\w+)<", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substring(with: match.range)
                    let link = Utils.GetStringsByRegularExpression(result as NSString, regularexp: "\"[^\"]*\"")[0].replacingOccurrences(of: "\"", with: "")
                    let title = Utils.GetStringsByRegularExpression(result as NSString, regularexp: ">(\\w*)<")[0].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "<", with: "")
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
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }) 
        task.resume()
    }
    
    func  XTubeVideo(){
        let url = URL(string: self.video.Link)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let stringa = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            do {
                let regex = try NSRegularExpression(pattern: "quality_\\w\\w\\w\\w\":\"(.*?)\"", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, stringa.length)
                let matches = regex.matches(in: stringa as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
                for match in matches{
                    let result = stringa.substring(with: match.range)
                    let splitted = result.characters.split{$0 == "\""}.map(String.init)
                if(splitted.count > 2)
                {
                    let title = splitted[0]
                    let link = splitted[2].removingPercentEncoding!
                        self.downloadLinks.append(DownloadLink(link: link, title: title))
                    }
                }
                //                }
            }catch{
                print("error");
            }
            DispatchQueue.main.async{
                var i = 0
                
                for downloadLink in self.downloadLinks{
                    //                    if(downloadLink.Title.rangeOfString("3GP") == nil)//AVPlayer for tvos can't play 3GP file
                    //                    {
                    self.createButton(downloadLink,index: i)
                    //                    }
                    i += 1;
                }
            }
        }) 
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
    
    func tapped(_ sender: UIButton) {
        let object = self.downloadLinks[sender.tag]
        self.performSegue(withIdentifier: "SeeVideo", sender: object)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let video = sender as! DownloadLink
        if segue.identifier == "SeeVideo"{
            let vc = segue.destination as! AVVideoPlayerController
            vc.downloadVideo = video
        }
    }
    
    func createButton(_ download: DownloadLink, index: Int){
        let numImagePerRow = Int(bounds.width) / (Int(1600) + 20)
        let width = CGFloat(1600)
        let height = CGFloat(180)
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow)
        let button = UIButton(type: UIButtonType.system)
        button.frame =  CGRect(x: CGFloat(x), y: CGFloat(y), width: width, height: height)
        button.setTitle(download.Title, for: UIControlState())
        button.tag = index
        button.addTarget(self, action: #selector(VideoController.tapped(_:)), for: .primaryActionTriggered)
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



