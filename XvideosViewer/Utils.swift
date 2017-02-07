//
//  Utils.swift
//  XvideosViewer
//
//  Created by kimiko88 on 22/03/16.
//  Copyright © 2016 kimiko88. All rights reserved.
//

import Foundation


class Utils{
    
    static func GetStringsByRegularExpression(_ stringWhereFind: NSString,regularexp : String) -> [String]
    {
                    var results = [String]()
    do {
    let regex = try NSRegularExpression(pattern: regularexp, options: NSRegularExpression.Options.caseInsensitive)
    let range = NSMakeRange(0, stringWhereFind.length)
    let matches = regex.matches(in: stringWhereFind as String, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: range)
    for match in matches{
    results.append(stringWhereFind.substring(with: match.range))
    }
    }catch{
    print("error");
    }
        return results
    }
}
