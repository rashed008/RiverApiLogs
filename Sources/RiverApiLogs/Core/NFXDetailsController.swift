//
//  NFXDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class NFXDetailsController: NFXGenericController {
    
    enum EDetailsView {
        case info
        case request
        case response
    }
    
    private enum Constants: String {
        case headersTitle = "-- Headers --\n\n"
        case bodyTitle = "\n-- Body --\n\n"
        case tooLongToShowTitle = "Too long to show. If you want to see it, please tap the following button\n"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //    func getInfoStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
    //        var tempString: String
    //        tempString = String()
    //
    //        tempString += "[URL] \n\(object.requestURL!)\n\n"
    //        tempString += "[Method] \n\(object.requestMethod!)\n\n"
    //        if !(object.noResponse) {
    //            tempString += "[Status] \n\(object.responseStatus!)\n\n"
    //        }
    //        tempString += "[Request date] \n\(object.requestDate!)\n\n"
    //        if !(object.noResponse) {
    //            tempString += "[Response date] \n\(object.responseDate!)\n\n"
    //            tempString += "[Time interval] \n\(object.timeInterval!)\n\n"
    //        }
    //        tempString += "[Timeout] \n\(object.requestTimeout!)\n\n"
    //        tempString += "[Cache policy] \n\(object.requestCachePolicy!)\n\n"
    //
    //        return formatNFXString(tempString)
    //    }
    
    
    func getInfoStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        func append(header: String, value: String?) {
            guard let value = value else { return }
            
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NFXColor.NFXOrangeColor(),
                .font: NFXFont.NFXFontBold(size: 14)
            ]
            
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NFXColor.NFXBlackColor(),
                .font: NFXFont.NFXFont(size: 12)
            ]
            
            let headerString = NSAttributedString(string: "[\(header)]\n", attributes: headerAttributes)
            let valueString = NSAttributedString(string: "\(value)\n\n", attributes: valueAttributes)
            
            result.append(headerString)
            result.append(valueString)
        }
        
        // Use correct formatting before passing
        append(header: "URL", value: object.requestURL)
        append(header: "Method", value: object.requestMethod)
        
        if !object.noResponse {
            append(header: "Status", value: formatInt(object.responseStatus))
        }
        
        append(header: "Request date", value: formatDate(object.requestDate))
        
        if !object.noResponse {
            append(header: "Response date", value: formatDate(object.responseDate))
            append(header: "Time interval", value: formatFloat(object.timeInterval))
        }
        
        append(header: "Timeout", value: object.requestTimeout)
        append(header: "Cache policy", value: object.requestCachePolicy)
        
        // ✅ Add Request Body
        //append(header: "Request Body", value: object.requestBody)
        
        // ✅ Add Response Body
        // append(header: "Response Body", value: object.responseBody)
        
        return result
    }
    
    // MARK: - Helper Functions
    
    private func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func formatFloat(_ float: Float?) -> String? {
        guard let float = float else { return nil }
        return String(format: "%.2f", float)
    }
    
    private func formatInt(_ int: Int?) -> String? {
        guard let int = int else { return nil }
        return String(int)
    }
    
    //    func getRequestStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
    //        var tempString: String
    //        tempString = String()
    //
    //        tempString += Constants.headersTitle.rawValue
    //
    //        if object.requestHeaders?.count > 0 {
    //            for (key, val) in (object.requestHeaders)! {
    //                tempString += "[\(key)] \n\(val)\n\n"
    //            }
    //        } else {
    //            tempString += "Request headers are empty\n\n"
    //        }
    //
    //    #if os(iOS)
    //        tempString += getRequestBodyStringFooter(object)
    //    #endif
    //        return formatNFXString(tempString)
    //    }
    
    //Have to uncomment it later
    //    func getRequestStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
    //        var tempString: String
    //        tempString = String()
    //
    //        tempString += Constants.headersTitle.rawValue
    //
    //        // Create a mutable attributed string to apply styles
    //        let attributedString = NSMutableAttributedString(string: tempString)
    //
    //        if let headers = object.requestHeaders, headers.count > 0 {
    //            for (key, val) in headers {
    //                if let keyString = key as? String, let valString = val as? String {
    //
    //                    // Format key with orange color and no interaction
    //                    let keyText = "[\(keyString)] \n"
    //                    let keyRange = (keyText as NSString).range(of: keyText)
    //                    let keyAttributes: [NSAttributedString.Key: Any] = [
    //                        .foregroundColor: NFXColor.NFXOrangeColor(),
    //                        .font: NFXFont.NFXFont(size: 14)
    //                    ]
    //                    attributedString.append(NSAttributedString(string: keyText, attributes: keyAttributes))
    //
    //                    // Format value with tappable link, black color, and font size 12
    //                    let valueText = "\(valString)\n\n"
    //                    let valueRange = (valueText as NSString).range(of: valString)
    //                    let valueAttributes: [NSAttributedString.Key: Any] = [
    //                        .link: "myApp://\(valString)", // Custom link for tapping
    //                        .foregroundColor: NFXColor.NFXBlackColor(), // Set value text color to black
    //                        .font: NFXFont.NFXFont(size: 12) // Set font size to 12
    //                    ]
    //                    attributedString.append(NSAttributedString(string: valueText, attributes: valueAttributes))
    //                }
    //            }
    //        } else {
    //            let emptyHeaderText = "Request headers are empty\n\n"
    //            attributedString.append(NSAttributedString(string: emptyHeaderText))
    //        }
    //
    //        #if os(iOS)
    //            tempString += getRequestBodyStringFooter(object)
    //        #endif
    //
    //        return attributedString
    //    }
    
    func getRequestStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
        var tempString: String
        tempString = String()
        
        tempString += Constants.headersTitle.rawValue
        
        let attributedString = NSMutableAttributedString(string: tempString)
        
        if let headers = object.requestHeaders, headers.count > 0 {
            for (key, val) in headers {
                guard let keyString = key as? String, let valString = val as? String else { continue }
                
                // Append key
                let keyText = "[\(keyString)] \n"
                let keyAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: NFXColor.NFXOrangeColor(),
                    .font: NFXFont.boldSystemFont(ofSize: 15)//NFXFont(size: 14)
                ]
                attributedString.append(NSAttributedString(string: keyText, attributes: keyAttributes))
                
                // Safely encode valString for URL
                let safeLink = "myApp://" + (valString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
                
                let valueText = "\(valString)\n\n"
                let valueAttributes: [NSAttributedString.Key: Any] = [
                    //.link: safeLink,
                    .foregroundColor: NFXColor.NFXBlackColor(),
                    .font: NFXFont.NFXFont(size: 12)
                ]
                attributedString.append(NSAttributedString(string: valueText, attributes: valueAttributes))
            }
        } else {
            let emptyHeaderText = "Request headers are empty\n\n"
            attributedString.append(NSAttributedString(string: emptyHeaderText))
        }
        
      //  attributedString.append(header: "Request Body", value: object.requestBody)
        
        // Append request body section
        let bodyTitle = "[Request Body]\n" //"//Constants.bodyTitle.rawValue
        //bodyTitle.textColor = NFXColor.NFXGray44Color()
        let bodyContent = object.requestBody.isEmpty ? "Request body is empty\n" : object.requestBody

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXOrangeColor(),
            .font: NFXFont.boldSystemFont(ofSize: 15) //NFXFont(size: 15)
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXBlackColor(),
            .font: NFXFont.NFXFont(size: 12)
        ]

        attributedString.append(NSAttributedString(string: bodyTitle, attributes: titleAttributes))
        attributedString.append(NSAttributedString(string: bodyContent, attributes: bodyAttributes))

        
        
#if os(iOS)
        tempString += getRequestBodyStringFooter(object)
#endif
        
        return attributedString
    }
    
    
    
    //    func getRequestBodyStringFooter(_ object: NFXHTTPModel) -> String {
    //        var tempString = Constants.bodyTitle.rawValue
    //        if (object.requestBodyLength == 0) {
    //            tempString += "Request body is empty\n"
    //        } else if (object.requestBodyLength > 1024) {
    //            tempString += Constants.tooLongToShowTitle.rawValue
    //        } else {
    //            tempString += "\(object.getRequestBody())\n"
    //        }
    //        return tempString
    //    }
    
    func getRequestBodyStringFooter(_ object: NFXHTTPModel) -> String {
        var tempString = Constants.bodyTitle.rawValue
        if !object.requestBody.isEmpty {
            tempString += object.requestBody
        } else {
            tempString += "Request body is empty\n"
        }
        return tempString
    }
    
    
    
    //    func getResponseStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
    //        if (object.noResponse) {
    //            return NSMutableAttributedString(string: "No response")
    //        }
    //
    //        var tempString: String
    //        tempString = String()
    //
    //        tempString += Constants.headersTitle.rawValue
    //
    //        if object.responseHeaders?.count > 0 {
    //            for (key, val) in object.responseHeaders! {
    //                tempString += "[\(key)] \n\(val)\n\n"
    //            }
    //        } else {
    //            tempString += "Response headers are empty\n\n"
    //        }
    //
    //
    //    #if os(iOS)
    //        tempString += getResponseBodyStringFooter(object)
    //    #endif
    //        return formatNFXString(tempString)
    //    }
    
    //Uncomment this one
    func getResponseStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString {
        if object.noResponse {
            return NSAttributedString(string: "No response")
        }
        
        let bodyText: String
        if !object.responseBody.isEmpty {
            bodyText = object.responseBody
        } else {
            bodyText = "Response body is empty"
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXBlackColor(),
            .font: NFXFont.NFXFont(size: 12)
        ]
        
        
        return NSAttributedString(string: bodyText, attributes: attributes)
    }
    
    
    //    func getResponseBodyStringFooter(_ object: NFXHTTPModel) -> String {
    //        var tempString = Constants.bodyTitle.rawValue
    //        if (object.responseBodyLength == 0) {
    //            tempString += "Response body is empty\n"
    //        } else if (object.responseBodyLength > 1024) {
    //            tempString += Constants.tooLongToShowTitle.rawValue
    //        } else {
    //            tempString += "\(object.getResponseBody())\n"
    //        }
    //        return tempString
    //    }
    
    func getResponseBodyStringFooter(_ object: NFXHTTPModel) -> String {
        var tempString = Constants.bodyTitle.rawValue
        if !object.responseBody.isEmpty {
            tempString += object.responseBody
        }
        else {
            tempString += "Response body is empty\n"
        }
        return tempString
    }
    
    
}

extension NSMutableAttributedString {
    func append(header: String, value: String?, valueColor: UIColor = NFXColor.NFXBlackColor()) {
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXGray44Color(),
            .font: NFXFont.NFXFont(size: 14)
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: valueColor,
            .font: NFXFont.NFXFont(size: 12)
        ]
        
        self.append(NSAttributedString(string: "\(header):\n", attributes: headerAttributes))
        self.append(NSAttributedString(string: "\(value ?? "nil")\n\n", attributes: valueAttributes))
    }
}


//extension NSMutableAttributedString {
//    func append(header: String, value: String?) {
//        guard let value = value, !value.isEmpty else { return }
//
//        // Header title styling
//        let headerTitle = "\n\(header):\n"
//        let headerAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: NFXColor.NFXOrangeColor(),
//            .font: NFXFont.NFXFont(size: 14)
//        ]
//        self.append(NSAttributedString(string: headerTitle, attributes: headerAttributes))
//
//        // Body value styling
//        let valueText = "\(value)\n\n"
//        let valueAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: NFXColor.NFXBlackColor(),
//            .font: NFXFont.NFXFont(size: 12)
//        ]
//        self.append(NSAttributedString(string: valueText, attributes: valueAttributes))
//    }
//}
