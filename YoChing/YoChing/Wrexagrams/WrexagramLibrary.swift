//
//  WrexagramLibrary.swift
//  YoChing
//
//  Created by Marc Risney on 4/3/16.
//  Copyright © 2016 Yo Ching. All rights reserved.
//

import AromaSwiftClient
import Foundation
import Haneke
import SwiftyJSON

class WrexagramLibrary {
    
    class func getOutcome(hexNum: Int) -> String {
        
        switch (hexNum) {
            
            case 111111: return "wrexagram01"
            case 111112: return "wrexagram43"
            case 111121: return "wrexagram14"
            case 111122: return "wrexagram34"
            case 111211: return "wrexagram09"
            case 111212: return "wrexagram05"
            case 111221: return "wrexagram26"
            case 111222: return "wrexagram11"
            case 112111: return "wrexagram10"
            case 112112: return "wrexagram58"
            case 112121: return "wrexagram38"
            case 112122: return "wrexagram54"
            case 112211: return "wrexagram61"
            case 112212: return "wrexagram60"
            case 112221: return "wrexagram41"
            case 112222: return "wrexagram19"
            case 121111: return "wrexagram13"
            case 121112: return "wrexagram49"
            case 121121: return "wrexagram30"
            case 121122: return "wrexagram55"
            case 121211: return "wrexagram37"
            case 121212: return "wrexagram63"
            case 121221: return "wrexagram22"
            case 121222: return "wrexagram36"
            case 122111: return "wrexagram25"
            case 122112: return "wrexagram17"
            case 122121: return "wrexagram21"
            case 122122: return "wrexagram51"
            case 122211: return "wrexagram42"
            case 122212: return "wrexagram03"
            case 122221: return "wrexagram27"
            case 122222: return "wrexagram24"
            case 211111: return "wrexagram44"
            case 211112: return "wrexagram28"
            case 211121: return "wrexagram50"
            case 211122: return "wrexagram32"
            case 211211: return "wrexagram57"
            case 211212: return "wrexagram48"
            case 211221: return "wrexagram18"
            case 211222: return "wrexagram46"
            case 212111: return "wrexagram06"
            case 212112: return "wrexagram47"
            case 212121: return "wrexagram64"
            case 212122: return "wrexagram40"
            case 212211: return "wrexagram59"
            case 212212: return "wrexagram29"
            case 212221: return "wrexagram04"
            case 212222: return "wrexagram07"
            case 221111: return "wrexagram33"
            case 221112: return "wrexagram31"
            case 221121: return "wrexagram56"
            case 221122: return "wrexagram62"
            case 221211: return "wrexagram53"
            case 221212: return "wrexagram39"
            case 221221: return "wrexagram52"
            case 221222: return "wrexagram15"
            case 222111: return "wrexagram12"
            case 222112: return "wrexagram45"
            case 222121: return "wrexagram35"
            case 222122: return "wrexagram16"
            case 222211: return "wrexagram20"
            case 222212: return "wrexagram08"
            case 222221: return "wrexagram23"
            case 222222: return "wrexagram02"
            
            default: return "wrexagram01"
        }
    }

    
    static func bodyForWrexagram(wrexagramNumber: Int) -> String {

        let formattedOutcome = String(format: "wrexagram%02d", wrexagramNumber)
        let filename = "txt/\(formattedOutcome)"
        
        if let text = NSBundle.mainBundle().pathForResource(filename, ofType: "txt") {
            do {
                let string = try String(contentsOfFile: text, encoding: NSUTF8StringEncoding)
                
                return string
                
            } catch let ex {
                AromaClient.beginWithTitle("Failed To Load")
                    .addBody("\(UIDevice.currentDevice().name)")
                    .addLine().addLine()
                    .addBody("\(ex)")
                    .send()
                
            }
        }
        
        return ""
        
    }
    
    private static let JSON_FILE = "json/wrexagrams.json"
    
    static var wrexagrams: [Wrexagram] = {
        
        print("Loading Wrexagrams from Memory")
        
        guard let url = NSBundle.mainBundle().URLForResource(JSON_FILE, withExtension: nil)
        else { return [] }
        
        guard let string = try? String(contentsOfURL: url),
              let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        else { return [] }
        
        let json = JSON(data: data)
        
        var wrexagrams: [Wrexagram] = []
        for (_, element) in json {
            let wrexagram = Wrexagram.fromJson(element)
            wrexagrams.append(wrexagram)
        }
        
        return wrexagrams
    }()
}


//MARK: Image Loading
extension WrexagramLibrary {
    
    
    static func loadWrexagram(number number: Int, intoImageView imageView: UIImageView, useThumbnail: Bool = false) {
        
        if useThumbnail {
            let fetcher = WrexagramImageFetcher(wrexagramNumber: number)
            imageView.hnk_setImageFromFetcher(fetcher)
        }
        else {
            let image = WrexagramLibrary.imageForWrexagram(number)
            imageView.image = image
        }
    }
    
    
    static func imageForWrexagram(number: Int) -> UIImage? {
        let imageName = "WREX\(number)"
        return UIImage(named: imageName)
    }
    
    static func wrexPost(forWrexagram wrexagramNumber: Int) -> UIImage? {
        let name = "WrexaPost-\(wrexagramNumber)"
        return UIImage(named: name)
    }
    
    
}

class WrexagramImageFetcher: Fetcher<UIImage> {
    
    let wrexagramNumber: Int
    
    init(wrexagramNumber: Int) {
        self.wrexagramNumber = wrexagramNumber
        super.init(key: String(wrexagramNumber))
    }
    
    override func fetch(failure fail: ((NSError?) -> ()), success succeed: (UIImage) -> ()) {
        
        if let image = WrexagramLibrary.imageForWrexagram(wrexagramNumber) {
            succeed(image)
        }
        else {
            fail(nil)
        }
    }
    
    override func cancelFetch() {}
    
}