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
    public init(_ identifier: String, length: Int){
        self.identifier = identifier
        self.maxLength = length
    }
    
    /** Initiates a GS1 AI with a maximum length and a type */
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType){
        self.init(identifier, length: length)
        self.type = type
    }
    
    /** Initiates a GS1 AI with a maximum length and dynamic length and a type. The dynamic length is always stronger than the maximum length */
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType, dynamicLength: Bool){
        self.init(identifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
    
    /** Initiates a GS1 AI of type date */
    public convenience init(dateIdentifier identifier: String){
        // Defaults the max length to 6 and sets default type to Date
        self.init(identifier, length: 6, type: .Date)
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
    
    // Think about moving this logic to GS1 Barcode
    /** Get a readable english string to display in the user interface */
    public var readableIdentifier: String{
        get{
            if identifier == "00" { return "Serial Shipping Container Code" }
            else if identifier == "01" { return "GTIN" }
            else if identifier == "02" { return "GTIN of contained Trade Items" }
            else if identifier == "10" { return "Lot Number" }
            else if identifier == "11" { return "Production Date" }
            else if identifier == "12" { return "Due Date" }
            else if identifier == "13" { return "Packaging Date" }
            else if identifier == "15" { return "Best Before Date" }
            else if identifier == "17" { return "Expiration Date" }
            else if identifier == "20" { return "Product Variant" }
            else if identifier == "21" { return "Serial Number" }
            else if identifier == "22" { return "Secondary Data Fields" }
            else if identifier == "30" { return "Count of Items" }
            else if identifier == "37" { return "Number of Units Contained" }
            else if identifier == "23n" { return "Lot Number of N" }
            else if identifier == "240" { return "Additional Product Identification" }
            else if identifier == "241" { return "Customer Part Number" }
            else if identifier == "242" { return "Made to Order Variation Number" }
            else if identifier == "250" { return "Secondary Serial Number" }
            else if identifier == "251" { return "Reference to Source Entity" }
            else if identifier == "310" { return "Product Weight in kg" }

            else if identifier == "311" { return "Length in m" }
            else if identifier == "312" { return "Width in m" }
            else if identifier == "313" { return "Height in m" }
            else if identifier == "314" { return "Surface Area in m²" }
            else if identifier == "315" { return "Net Volume in L" }
            else if identifier == "316" { return "Net Volume in m³" }
            else if identifier == "320" { return "Net Weight in lb" }
            else if identifier == "321" { return "Length in in" }
            else if identifier == "322" { return "Length in ft" }
            else if identifier == "323" { return "Length in yd" }
            else if identifier == "324" { return "Width in in" }
            else if identifier == "325" { return "Width in ft" }
            else if identifier == "326" { return "Width in yd" }
            else if identifier == "327" { return "Height in in" }
            else if identifier == "328" { return "Height in ft" }
            else if identifier == "329" { return "Height in yd" }
            else if identifier == "330" { return "Gross Weight in kg" }
            else if identifier == "331" { return "Length in m" }
            else if identifier == "332" { return "Width in m" }
            else if identifier == "333" { return "Height in m" }
            else if identifier == "334" { return "Surface Area in m²" }
            else if identifier == "335" { return "Logistic Volume" }
            else if identifier == "336" { return "Net Weight in kg" }
            else if identifier == "337" { return "Kg per m²" }
            else if identifier == "340" { return "Gross Volume in m³" }
            else if identifier == "341" { return "Gross Volume in ft³" }
            else if identifier == "342" { return "Net Volume in ft³" }
            else if identifier == "343" { return "Length in yd" }
            else if identifier == "344" { return "Width in in" }
            else if identifier == "345" { return "Width in ft" }

            else if identifier == "392" { return "Price - Single Monetary Area" }
            else if identifier == "393" { return "Price and ISO" }
            else if identifier == "395" { return "Price per UOM" }
            else if identifier == "422" { return "Country of Origin" }
            else { return identifier }
        }
    }
}
