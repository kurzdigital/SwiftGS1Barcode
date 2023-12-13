//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import Foundation

public class GS1Barcode: NSObject, Barcode {
    /** RAW Data of the barcode in a string */
    public var raw: String?
    /** Stores if the last parsing was successfull */
    private var lastParseSuccessfull: Bool = false

    /** Array containing all supported application identifiers */
    public var applicationIdentifiers: [GS1ApplicationIdentifier] = [
        GS1ApplicationIdentifier("00", "Serial Shipping Container Code", length: 18, type: .AlphaNumeric),
        GS1ApplicationIdentifier("01", "GTIN", length: 14, type: .AlphaNumeric),
        GS1ApplicationIdentifier("02", "GTIN of Contained Trade Items", length: 14, type: .AlphaNumeric),
        GS1ApplicationIdentifier("10", "Lot Number", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("11", "Production Date", length: 6, type: .Date),
        GS1ApplicationIdentifier("12", "Due Date", length: 6, type: .Date),
        GS1ApplicationIdentifier("13", "Packaging Date", length: 6, type: .Date),
        GS1ApplicationIdentifier("15", "Best Before Date", length: 6, type: .Date),
        GS1ApplicationIdentifier("16", "SellByDate", length: 6, type: .Date),
        GS1ApplicationIdentifier("17", "Expiration Date", length: 6, type: .Date),

        GS1ApplicationIdentifier("20", "Product Variant", length: 2, type: .AlphaNumeric),
        GS1ApplicationIdentifier("21", "Serial Number", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("22", "Secondary Data Fields", length: 29, type: .AlphaNumeric, dynamicLength: true),

        GS1ApplicationIdentifier("235", "Serialised Extension of GTIN (TPX)", length: 28, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("240", "Additional Product Identification", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("241", "Customer Part Number", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("242", "Made-to-Order Variation Number", length: 6, type: .AlphaNumeric),
        GS1ApplicationIdentifier("243", "Packaging Component Number", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("250", "Secondary Serial Number", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("251", "Reference to Source Entity", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("253", "Global Document Type Identifier (GDTI)", length: 17, type: .AlphaNumeric),
        GS1ApplicationIdentifier("254", "GLN Extension Component", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("255", "Global Coupon Number (GCN)", length: 12, type: .Numeric),

        GS1ApplicationIdentifier("30", "Count of Items", length: 8, type: .Numeric, dynamicLength: true),
        GS1ApplicationIdentifier("37", "Number of Units Contained", length: 8, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("310", "Product Weight in kg", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("311", "Length in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("312", "Width in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("313", "Height in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("314", "Surface Area in m²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("315", "Net Volume in L", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("316", "Net Volume in m³", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("320", "Net Weight in lb", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("321", "Length in in", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("322", "Length in ft", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("323", "Length in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("324", "Width in in", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("325", "Width in ft", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("326", "Width in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("327", "Height in in", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("328", "Height in ft", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("329", "Height in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("330", "Gross Weight in kg", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("331", "Length in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("332", "Width in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("333", "Height in m", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("334", "Surface Area in m²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("335", "Logistic Volume", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("336", "Net Weight in kg", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("337", "Kg per m²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("340", "Gross Volume in m³", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("341", "Gross Volume in ft³", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("342", "Net Volume in ft³", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("343", "Length in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("344", "Width in in", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("345", "Width in ft", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("346", "Width in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("347", "Height in in", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("348", "Height in ft", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("349", "Height in yd", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("350", "Area in in²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("351", "Area in ft²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("352", "Area in yd²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("353", "Area in in²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("354", "Area in ft²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("355", "Area in yd²", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("356", "Net weight, troy ounces", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("357", "Net weight, ounces", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("360", "Net volume, quarts", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("361", "Net volume, gallons U.S.", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("362", "Logistic volume, quarts", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("363", "Logistic volume, gallons U.S.", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("364", "Net volume, cubic inches", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("365", "Net volume, cubic feet", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("366", "Net volume, cubic yards", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("367", "Logistic volume, cubic inches", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("368", "Logistic volume, cubic feet", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("369", "Logistic volume, cubic yards", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("390", "Coupon value, local currency", length: 15, type: .NumericDouble, dynamicLength: true),
        GS1ApplicationIdentifier("391", "Amount payable, ISO currency", length: 15, type: .NumericDouble, dynamicLength: true),
        GS1ApplicationIdentifier("392", "Price - Single Monetary Area", length: 15, type: .NumericDouble, dynamicLength: true),
        GS1ApplicationIdentifier("393", "Amount payable, ISO currency", length: 15, type: .NumericDouble, dynamicLength: true),
        GS1ApplicationIdentifier("394", "Coupon discount percentage", length: 6, type: .NumericDouble),
        GS1ApplicationIdentifier("395", "Price per UOM", length: 6, type: .NumericDouble),

        GS1ApplicationIdentifier("400", "Customer Purchase Order Number", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("401", "Global Identification Number for Consignment (GINC)", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("402", "Global Shipment Identification Number (GSIN)", length: 17, type: .Numeric),
        GS1ApplicationIdentifier("403", "Routing Code", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("410", "Ship to / Deliver to GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("411", "Bill to / Invoice to GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("412", "Purchased from GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("413", "Ship for / Deliver for - Forward to GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("414", "Identification of a Physical Location - GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("415", "GLN of the Invoicing Party", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("416", "GLN of the Production or Service Location", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("417", "Party GLN", length: 13, type: .Numeric),
        GS1ApplicationIdentifier("420", "Ship to / Deliver to Postal Code within a Single Postal Authority", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("421", "Ship to / Deliver to Postal Code with ISO Country Code", length: 9, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("422", "Country of Origin", length: 3, type: .AlphaNumeric),
        GS1ApplicationIdentifier("423", "Country of Initial Processing", length: 12, type: .Numeric),
        GS1ApplicationIdentifier("424", "Country of Processing", length: 3, type: .Numeric),
        GS1ApplicationIdentifier("425", "Country of Disassembly", length: 12, type: .Numeric),
        GS1ApplicationIdentifier("426", "Country Covering Full Process Chain", length: 3, type: .Numeric),
        GS1ApplicationIdentifier("427", "Country Subdivision of Origin", length: 3, type: .AlphaNumeric, dynamicLength: true),

        GS1ApplicationIdentifier("4300", "Ship-to/Deliver-to Company Name", length: 35, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4301", "Ship-to/Deliver-to Contact", length: 35, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4302", "Ship-to/Deliver-to Address Line 1", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4303", "Ship-to/Deliver-to Address Line 2", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4304", "Ship-to/Deliver-to Suburb", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4305", "Ship-to/Deliver-to Locality", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4306", "Ship-to/Deliver-to Region", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4307", "Ship-to/Deliver-to Country Code", length: 2, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4308", "Ship-to/Deliver-to Telephone Number", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4309", "Ship-to/Deliver-to GEO Location", length: 20, type: .Numeric),
        GS1ApplicationIdentifier("4310", "Return-to Company Name", length: 35, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4311", "Return-to Contact", length: 35, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4312", "Return-to Address Line 1", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4313", "Return-to Address Line 2", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4314", "Return-to Suburb", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4315", "Return-to Locality", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4316", "Return-to Region", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4317", "Return-to Country Code", length: 2, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4318", "Return-to Postal Code", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4319", "Return-to Telephone Number", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4320", "Service Code Description", length: 35, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("4321", "Dangerous Goods Flag", length: 1, type: .Numeric),
        GS1ApplicationIdentifier("4322", "Authority to Leave", length: 1, type: .Numeric),
        GS1ApplicationIdentifier("4323", "Signature Required Flag", length: 1, type: .Numeric),
        GS1ApplicationIdentifier("4324", "Not Before Delivery Date Time", length: 10, type: .Numeric),
        GS1ApplicationIdentifier("4325", "Not After Delivery Date Time", length: 10, type: .Numeric),
        GS1ApplicationIdentifier("4326", "Release Date", length: 6, type: .Numeric),

        GS1ApplicationIdentifier("710", "NHRN - Germany PZN", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("711", "NHRN - France CIP", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("712", "NHRN - Spain CN", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("713", "NHRN - Brasil DRN", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("714", "NHRN - Portugal AIM", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("715", "NHRN - United States of America NDC", length: 20, type: .AlphaNumeric, dynamicLength: true),

        GS1ApplicationIdentifier("8001", "Roll Products", length: 14, type: .Numeric),
        GS1ApplicationIdentifier("8002", "Cellular Mobile Telephone Identifier", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8003", "GRAI", length: 14, type: .Numeric),
        GS1ApplicationIdentifier("8004", "GIAI", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8005", "Price per Unit of Measure", length: 6, type: .Numeric),
        GS1ApplicationIdentifier("8006", "ITIP", length: 18, type: .Numeric),
        GS1ApplicationIdentifier("8007", "IBAN", length: 34, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8008", "Date and Time of Production", length: 8, type: .Numeric),
        GS1ApplicationIdentifier("8009", "Optically Readable Sensor Indicator", length: 50, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8010", "CPID", length: 30, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8011", "CPID Serial Number", length: 12, type: .Numeric),
        GS1ApplicationIdentifier("8012", "Software Version", length: 20, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8013", "GMN", length: 25, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8017", "GSRN (Provider)", length: 18, type: .Numeric),
        GS1ApplicationIdentifier("8018", "GSRN (Recipient)", length: 18, type: .Numeric),
        GS1ApplicationIdentifier("8019", "SRIN", length: 10, type: .Numeric),
        GS1ApplicationIdentifier("8020", "Payment Slip Reference Number", length: 25, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8026", "ITIP in Logistic Unit", length: 18, type: .Numeric),
        GS1ApplicationIdentifier("8110", "Coupon Code Identification for North America", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8111", "Loyalty Points of a Coupon", length: 4, type: .Numeric),
        GS1ApplicationIdentifier("8112", "Paperless Coupon Code for North America", length: 70, type: .AlphaNumeric, dynamicLength: true),
        GS1ApplicationIdentifier("8200", "Extended Packaging URL", length: 70, type: .AlphaNumeric, dynamicLength: true)
    ]


    /** Array containing all application identifiers that have a value  */
    public var filledApplicationIdentifiers: [GS1ApplicationIdentifier]{
        get{
            return self.applicationIdentifiers.filter{ $0.rawValue != nil }
        }
    }

    required override public init() {
        super.init()
    }

    /** Init barcode with string and parse it */
    required public init(raw: String) {
        super.init()
        // Setting Original Data
        self.raw = raw
        // Parsing Barcode
        try? parse()
    }

    required public init(raw: String, customApplicationIdentifiers: [GS1ApplicationIdentifier]) {
        super.init()
        // Setting Original Data
        self.raw = raw

        // Adding Custom Application Identifiers
        self.applicationIdentifiers.append(contentsOf: customApplicationIdentifiers)

        // Parsing Barcode
        try? parse()
    }

    /** Validating if the barcode got parsed correctly **/
    public func validate() throws -> Bool {
        if raw == nil{
            throw GS1BarcodeErrors.ValidationError.barcodeNil
        }
        // TODO check for whitespaces
        if raw == "" {
            throw GS1BarcodeErrors.ValidationError.barcodeEmpty
        }
        if raw!.replacingOccurrences(of: "\u{1D}", with: "").range(of: #"^\d+[a-zA-Z0-9äöüÄÖU/\\@#\-]*$"#, options: .regularExpression) == nil {
            throw GS1BarcodeErrors.ValidationError.unallowedCharacter
        }
        if !lastParseSuccessfull{
            throw GS1BarcodeErrors.ValidationError.parseUnsucessfull
        }
        return true
    }

    private func parseApplicationIdentifier(_ ai: GS1ApplicationIdentifier, data: inout String) throws{
        if(data.startsWith(ai.identifier)){
            // This can throw an error! Make sure data setting is like expected
            do{
                try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: data)
                data =  GS1BarcodeParser.reduce(data: data, by: ai)!
            }catch let error{
                // Pass error to calling function
                throw error
            }
        }else{
            print("The data didn't start with the expected Application Identifier \(ai.identifier)")
        }
    }

    @available(*, deprecated, message: "Please use the function parse() to parse a barcode")
    /** Temporary function, to allow a smooth transition of the legacy parse function */
    public func tryParse() -> Bool{
        do{
            try parse()
            return true
        }catch{
            return false
        }

    }

    public func parse() throws {
        self.lastParseSuccessfull = false
        var data = raw

        if data != nil {
            while data!.count > 0 {
                // Removing Group Separator from the beginning of the string
                if(data!.startsWith("\u{1D}")){
                    data = String(data!.dropFirst())
                }

                var foundOne = false
                for ai in applicationIdentifiers {
                    do {
                        if(data!.startsWith(ai.identifier)){
                            try parseApplicationIdentifier(ai, data: &data!)
                            foundOne = true

                            // here, at least one AI was parsed successfull
                            self.lastParseSuccessfull = true
                            break
                        }
                    } catch {
                        // Error handling if parsing fails
                        debugPrint("ERROR: \(error.localizedDescription)")
                        // Continue the loop to check for other AIs
                    }
                }

                // If no known AI was found, remove the unknown AI and continue parsing
                if !foundOne {
                    data = removeUnknownAI(from: data!)
                }

                // Break the loop if no data is left to parse
                if data!.isEmpty {
                    break
                }
            }
        }
    }

    private func removeUnknownAI(from string: String) -> String {
        // Custom logic to remove unknown AI from the string
        // For simplicity, let's remove up to the next Group Separator or end of the string
        if let range = string.range(of: "\u{1D}") {
            return String(string[range.lowerBound...])
        } else {
            return ""
        }
    }
}


extension GS1Barcode {
    public func findApplicationIdentifier(by id: String) -> GS1ApplicationIdentifier? {
        return applicationIdentifiers.first(where: { $0.identifier == id })
    }

    public func findApplicationIdentifier(byReadableId: String) -> GS1ApplicationIdentifier? {
        return applicationIdentifiers.first(where: { $0.readableIdentifier == byReadableId })
    }

    public var serialShippingContainerCode: String? { findApplicationIdentifier(by: "00")?.stringValue }
    public var gtin: String? { findApplicationIdentifier(by: "01")?.stringValue }
    public var gtinOfContainedTradeItems: String? { findApplicationIdentifier(by: "02")?.stringValue }
    public var lotNumber: String? { findApplicationIdentifier(by: "10")?.stringValue }
    public var productionDate: Date? { findApplicationIdentifier(by: "11")?.dateValue }
    public var dueDate: Date? { findApplicationIdentifier(by: "12")?.dateValue }
    public var packagingDate: Date? { findApplicationIdentifier(by: "13")?.dateValue }
    public var bestBeforeDate: Date? { findApplicationIdentifier(by: "15")?.dateValue }
    public var expirationDate: Date? { findApplicationIdentifier(by: "17")?.dateValue }
    public var productVariant: String? { findApplicationIdentifier(by: "20")?.stringValue }
    public var serialNumber: String? { findApplicationIdentifier(by: "21")?.stringValue }
    public var secondaryDataFields: String? { findApplicationIdentifier(by: "22")?.stringValue }
    public var countOfItems: Int? { findApplicationIdentifier(by: "30")?.intValue }
    public var numberOfUnitsContained: String? { findApplicationIdentifier(by: "37")?.stringValue }
    public var productWeightInKg: Double? { findApplicationIdentifier(by: "310")?.doubleValue }

    public var additionalProductIdentification: String? { findApplicationIdentifier(by: "240")?.stringValue }
    public var customerPartNumber: String? { findApplicationIdentifier(by: "241")?.stringValue }
    public var madeToOrderVariationNumber: String? { findApplicationIdentifier(by: "242")?.stringValue }
    public var secondarySerialNumber: String? { findApplicationIdentifier(by: "250")?.stringValue }
    public var referenceToSourceEntity: String? { findApplicationIdentifier(by: "251")?.stringValue }
    public var priceSingleMonetaryArea: Double? { findApplicationIdentifier(by: "392")?.doubleValue }
    public var priceAndISO: Double? { findApplicationIdentifier(by: "393")?.doubleValue }
    public var pricePerUOM: Double? { findApplicationIdentifier(by: "395")?.doubleValue }
    public var countryOfOrigin: String? { findApplicationIdentifier(by: "422")?.stringValue }
    public var nationalHealthcareReimbursementNumberAIM: String? { findApplicationIdentifier(by: "714")?.stringValue }
    public var extendedPackagingURL: String? { findApplicationIdentifier(by: "8200")?.stringValue }
}
