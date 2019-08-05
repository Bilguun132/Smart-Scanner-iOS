//
//  TextRecognizer.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 2/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import Firebase

public class TextRecognizer {
    
    private let image: UIImage!
    
    public var usefulInfo = [ContactFieldType: [String]]()
    
    init(image: UIImage) {
        self.image = image
        usefulInfo[ContactFieldType.nameSuggestions] = []
        usefulInfo[ContactFieldType.links] = []
        usefulInfo[ContactFieldType.emails] = []
        usefulInfo[ContactFieldType.phones] = []
        usefulInfo[ContactFieldType.addresses] = []
    }
    
    func recognizeText(completion: @escaping ([ContactFieldType: [String]]?)-> ()) {
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { (result, error) in
            guard error == nil, let result = result else {
                completion(nil)
                return
            }
            
            var nameSuggestions: [String] = result.text.components(separatedBy: "\n")
            
            do {
                let input: String = result.text
                let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .address, .link]
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                for match in matches {
                    guard let range = Range(match.range, in: input) else {continue}
                    let matchString = "\(input[range])"
                    if match.resultType == .phoneNumber {
                        self.usefulInfo[ContactFieldType.phones]?.append(matchString)
                    }
                    if match.resultType == .address {
                        self.usefulInfo[ContactFieldType.addresses]?.append(matchString)
                    }
                    if match.resultType == .link {
                        if matchString.contains("@") {
                            self.usefulInfo[ContactFieldType.emails]?.append(matchString)
                        }
                        else {
                            self.usefulInfo[ContactFieldType.links]?.append(matchString)
                        }
                    }
                    nameSuggestions = nameSuggestions.filter {$0.contains(matchString) == false}
                }
            }
            catch {
                
            }
            print(nameSuggestions)
            print(self.usefulInfo)
            self.usefulInfo[ContactFieldType.nameSuggestions] = nameSuggestions
            completion(self.usefulInfo)
        }
    }
    
    
    private func getEmails(text: String) -> [String] {
        if let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        {
            let string = text as NSString
            
            return regex.matches(in: text, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "").lowercased()
            }
        }
        return []
    }
}

public enum ContactFieldType {
    case nameSuggestions, links, emails, addresses, phones
}
