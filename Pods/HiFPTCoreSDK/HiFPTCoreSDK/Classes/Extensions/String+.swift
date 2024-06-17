//
//  String+.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/14/21.
//

import UIKit
extension String {
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            HiFPTLogger.log(type: .debug, category: .warning, message: "\(#function) invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension String {
    func format(with type: TypePhone) -> String {
        var mask = "XXXXXXXXXX"
        switch type {
        case .mobile:
            mask = "XXXX XXX XXX"// "XXXX-XXX-XXX"
        case .regionCode:
            mask = "XXXXX XXX XXX" // "XXXXX-XXX-XXX"
        case .other:
            mask = "XXXXXX XXX XXX" // "XXXXXX-XXX-XXX"
        case .unknow:
            mask = "XXXX XXX XXX" // "XXXX-XXX-XXX"
        }
        return format(withMask: mask)
    }
    
    func format() -> String {
        var mask = "XXXXXXXXXX"
        if String(prefix(3)) == "840" {
            mask = "XXXXXX XXX XXX" // "XXXXXX-XXX-XXX"
        }
        else if String(prefix(2)) == "84" {
            mask = "XXXXX XXX XXX" // "XXXXX-XXX-XXX"
        }
        else {
            mask = "XXXX XXX XXX" // "XXXX-XXX-XXX"
        }
        return format(withMask: mask)
    }
    
    fileprivate func format(withMask mask: String) -> String {
        let numbers = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func formatPhoneNumber() -> String {
        var mask = "XXXXXXXXXX"
        if String(prefix(3)) == "840" {
            mask = "XXX XXX XXX XXX" // "XXX-XXX-XXX-XXX"
        }
        else if String(prefix(2)) == "84" {
            mask = "XX XXX XXX XXX" // "XX-XXX-XXX-XXX"
        }
        else {
            mask = "XXXX XXX XXX" // "XXXX-XXX-XXX"
        }
        return format(withMask: mask)
    }
}
