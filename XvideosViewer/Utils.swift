//
//  Utils.swift
//  XvideosViewer
//
//  Created by kimiko88 on 22/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//

import Foundation


class Utils{
    
    static func GetStringsByRegularExpression(stringWhereFind: NSString,regularexp : String) -> [String]
    {
                    var results = [String]()
    do {
    let regex = try NSRegularExpression(pattern: regularexp, options: NSRegularExpressionOptions.CaseInsensitive)
    let range = NSMakeRange(0, stringWhereFind.length)
    let matches = regex.matchesInString(stringWhereFind as String, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
    for match in matches{
    results.append(stringWhereFind.substringWithRange(match.range))
    }
    }catch{
    print("error");
    }
        return results
    }
}