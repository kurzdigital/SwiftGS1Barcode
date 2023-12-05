//
//  GS1ApplicationIdentifier.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import Foundation

public enum GS1ApplicationIdentifierType: String{
    case AlphaNumeric
    case Numeric
    case NumericDouble
    case Date
    var description: String{
        return self.rawValue
    }
}

public class GS1ApplicationIdentifier: NSObject{
    /** Barcode Parser will search for this identifier and will */
    public var identifier: String

    /** This is the readable identifier taken mostly from https://www.gs1.org/standards/barcodes/application-identifiers?lang=en */
    public var readableIdentifier: String

    /** Maximum length. The value can be smaller if there are not enough characters available or if dynamic length is active (and a GS character is available) */
    public var maxLength: Int

    /** Seperates by the next GS-character */
    public var dynamicLength: Bool = false
    
    public var type: GS1ApplicationIdentifierType?
    
    /** The original data from the AI. This will always been set to the content that was trying to be parsed. If Date / Int parsing failed it will still pout the content in there */
    public var rawValue: String?
    /** This will be set by the Barcode parser, if type is Date */
    public var dateValue: Date?
    /** This will be set by the Barcode parser, if type is Numeric */
    public var intValue: Int?
    /** This will be set by the Barcode parser, if type is NumericDouble */
    public var doubleValue: Double?
    /** This will be set by the Barcode parser, if type is AlphaNumeric */
    public var stringValue: String?
    
    public var decimalPlaces: Int?
    
    /** Initiates a GS1 AI with a maximum length */
    public init(_ identifier: String, _ readableIdentifier: String? = nil, length: Int){
        self.identifier = identifier
        self.maxLength = length
        self.readableIdentifier = readableIdentifier ?? identifier
    }
    
    /** Initiates a GS1 AI with a maximum length and a type */
    public convenience init(_ identifier: String, _ readableIdentifier: String? = nil, length: Int, type: GS1ApplicationIdentifierType){
        self.init(identifier, readableIdentifier, length: length)
        self.type = type
    }
    
    /** Initiates a GS1 AI with a maximum length and dynamic length and a type. The dynamic length is always stronger than the maximum length */
    public convenience init(_ identifier: String, _ readableIdentifier: String? = nil, length: Int, type: GS1ApplicationIdentifierType, dynamicLength: Bool){
        self.init(identifier, readableIdentifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
    
    /** Initiates a GS1 AI of type date */
    public convenience init(dateIdentifier identifier: String, _ readableIdentifier: String? = nil){
        // Defaults the max length to 6 and sets default type to Date
        self.init(identifier, readableIdentifier, length: 6, type: .Date)
    }
    
    public var readableValue: String{
        get{
            if self.type == GS1ApplicationIdentifierType.AlphaNumeric{
                return self.stringValue ?? ""
            }
            if self.type == GS1ApplicationIdentifierType.NumericDouble{
                if self.doubleValue == nil {
                    return ""
                }
                return String(self.doubleValue!)
            }
            if self.type == GS1ApplicationIdentifierType.Numeric{
                if self.intValue == nil {
                    return ""
                }
                return String(self.intValue!)
            }
            if self.type == GS1ApplicationIdentifierType.Date{
                if self.dateValue == nil {
                    return ""
                }
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                return formatter.string(for: self.dateValue!)!
            }
            return self.rawValue ?? ""
        }
    }
}
