//
//  StringExtension.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import Foundation

extension String {
    /** Returning a substring of the current element */
    func substring(_ from: Int, length: Int) -> String {
        guard from >= 0, length >= 0, from < self.count else { return "" }
        let toIndex = from + length <= self.count ? from + length : self.count
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: toIndex)
        let range = start..<end
        return String(self[range])
    }
    
    /** Returning a substring of the current element */
    func substring(_ from: Int, to: Int) -> String {
        guard from >= 0, to >= 0, from <= to, to <= self.count else { return "" }
        return self.substring(from, length: to - from)
    }
    
    /** Returning a substring of the current element, cutting at the passed char */
    func substring(from: Int) -> String {
        guard from >= 0, from <= self.count else { return "" }
        return self.substring(from, length: self.count - from)
    }
    
    /** Returning a substring of the current element, cutting at the passed char */
    func substring(to: Int) -> String {
        guard to >= 0, to <= self.count else { return "" }
        return self.substring(0, length: to)
    }

    /** returns the index of a substring, if the string contains the parameter */
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    /** checks if the string contains a certain substring */
    func startsWith(_ subString: String) -> Bool {
        return self.hasPrefix(subString)
    }
}