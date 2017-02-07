//
//  SeeVideo.swift
//  XvideosViewer
//
//  Created by kimiko88 on 21/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class AVVideoPlayerController: AVPlayerViewController{
    var downloadVideo: DownloadLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:  String(htmlEncodedString: downloadVideo.Link))
        player = AVPlayer(url: url!)
        player?.play()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(AVVideoPlayerController.tick), userInfo: nil, repeats: true)
        
    }
    
    
    
    func tick() {//Failed case
        if(player!.status == .failed)
        {
            let url = URL(string:  String(htmlEncodedString: downloadVideo.Link))
            let item = AVPlayerItem(url: url!)
            player?.replaceCurrentItem(with: item)
        }
    }
}


extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.data(using: String.Encoding.utf8)!
        let attributedOptions: [ String: AnyObject ] = [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject ]
        var attributedString = NSAttributedString()
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
        }catch{
            print("error")
        }
        self.init(attributedString.string)!
    }
}
