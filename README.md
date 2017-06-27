# SwiftGS1Barcode
A GS1 Barcode Library and Parser written in Swift

[![Language](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)
[![iOS](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/xremix/SwiftGS1Barcode/master/LICENSE)

This project is mostly a wraper around the complex logic of parsing GS1 Barcode Strings.

## Usage
Parsing is as simple as

```Swift
import SwiftGS1Barcode
// ...
let gs1Barcode = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode(raw: gs1Barcode)

print(barcode.gtin) // 10123467041728
print(barcode.amount) // 2
print(barcode.expirationDate) // 31.10.2021
print(barcode.lotNumber) // S123456
```
##### Advanced Usage

To seperate the parsing from initializing I'd recommend a code like

```Swift
import SwiftGS1Barcode
// ...
let gs1BarcodeText = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode()
barcode.raw = gs1BarcodeText
_ = barcode.parse()
```

To parse **custom Application Identifiers** use the following code

```Swift
import SwiftGS1Barcode
// ...
let gs1BarcodeText = "90HelloWorld\u{1D}01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode()
barcode.applicationIdentifiers["custom1"] = GS1ApplicationIdentifier("90", length: 30, type: .String, dynamicLength: true)
barcode.raw = gs1BarcodeText
_ = barcode.parse()
print(barcode.applicationIdentifiers["custom1"]!.stringValue)
```

### Available Properties
**!Attention!** Currently only the following properties are available and do get parsed


| Application Identifier | ID           |
| ------------------ |:-------------:|
| serialShippingContainerCode |  00 |
| gtin               | 01  |
| gtinIndicatorDigit | 01  |
| gtinOfContainedTradeItems | 02  |
| lotNumber (batchNumber) | 10  |
| productionDate     | 11  |
| dueDate            | 12  |
| packagingDate      | 13  |
| bestBeforeDate     | 15  |
| expirationDate     | 17  |
| productVariant     | 20  |
| serialNumber       | 21  |
| secondaryDataFields | 22  |
| amount (quantity)  | 30  |
| numberOfUnitsContained | 37  |

Other properties can be extended pretty easily. **You** can contribute yourself, or open an [issue](https://github.com/xremix/SwiftGS1Barcode/issues/new) if there is something missing for you.

### Initializers

| Initializer | Description           |
| ------------------ |:-------------:|
| `Barcode()` |  Creates plain Barcode |
| `Barcode(raw: String)` |  Creates Barcode with raw data and parses it |
| `Barcode(raw: String, customApplicationIdentifiers: [String: GS1ApplicationIdentifier])` |  Creates Barcode with raw data, custom AIs and parses it |

## Installation
### CocoaPods
You can install the library to you project using [CocoaPods](https://cocoapods.org). Add the following code to your `Podfile`:
```
pod 'SwiftGS1Barcode'
```
Alternative you can also add the direct Github URL: 
```
pod 'SwiftGS1Barcode', :git => 'https://github.com/xremix/SwiftGS1Barcode', :branch => 'master'
```

### Manually
You can add the project as a git `submodule`. Simply drag the `SwiftGS1Barcode.xcodeproj` file into your Xcode project.  
**Don't forget to add the framework in your application target**


## Deployment Steps
- Run Unit Tests
- Lint Podfile using `pod lib lint`
- Update Version in `Project Settings` and `Pod Specs`
- Push Code to Git
- Create Release on Git
- Push code to CocoaPods using `pod trunk push SwiftGS1Barcode.podspec`

## Resources
A couple of resources, used for this project.

#### GS1 parsing
https://www.activebarcode.de/codes/ean128_ucc128_ai.html
https://www.gs1.at/fileadmin/user_upload/Liste_GS1_Austria_Application_Identifier.pdf

#### CocoaPod
https://www.appcoda.com/cocoapods-making-guide/


![Analytics](https://ga-beacon.appspot.com/UA-40522413-9/SwiftGS1Barcode/readme?pixel)
