//
//  NFXInfoController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//
    
//import Foundation
//
//class NFXInfoController: NFXGenericController {
//    
//    func generateInfoString(_ ipAddress: String) -> NSAttributedString {
//        var tempString: String
//        tempString = String()
//        
//        tempString += "[App name] \n\(NFXDebugInfo.getNFXAppName())\n\n"
//        
//        tempString += "[App version] \n\(NFXDebugInfo.getNFXAppVersionNumber()) (build \(NFXDebugInfo.getNFXAppBuildNumber()))\n\n"
//        
//        tempString += "[App bundle identifier] \n\(NFXDebugInfo.getNFXBundleIdentifier())\n\n"
//
//        tempString += "[Device OS] \niOS \(NFXDebugInfo.getNFXOSVersion())\n\n"
//
//        tempString += "[Device type] \n\(NFXDebugInfo.getNFXDeviceType())\n\n"
//
//        tempString += "[Device screen resolution] \n\(NFXDebugInfo.getNFXDeviceScreenResolution())\n\n"
//        
//        tempString += "[Device IP address] \n\(ipAddress)\n\n"
//
//        return formatNFXString(tempString)
//    }
//}


import Foundation

class NFXInfoController: NFXGenericController {
    
    func generateInfoString(_ ipAddress: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXOrangeColor(),
            .font: NFXFont.NFXFontBold(size: 15)
        ]
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NFXColor.NFXBlackColor(),
            .font: NFXFont.NFXFontBold(size: 12)
        ]
        
        func append(title: String, value: String) {
            attributedString.append(NSAttributedString(string: "[\(title)]\n", attributes: titleAttributes))
            attributedString.append(NSAttributedString(string: "\(value)\n\n", attributes: valueAttributes))
        }

        append(title: "App name", value: NFXDebugInfo.getNFXAppName())
        append(title: "App version", value: "\(NFXDebugInfo.getNFXAppVersionNumber()) (build \(NFXDebugInfo.getNFXAppBuildNumber()))")
        append(title: "App bundle identifier", value: NFXDebugInfo.getNFXBundleIdentifier())
        append(title: "Device OS", value: "iOS \(NFXDebugInfo.getNFXOSVersion())")
        append(title: "Device type", value: NFXDebugInfo.getNFXDeviceType())
        append(title: "Device screen resolution", value: NFXDebugInfo.getNFXDeviceScreenResolution())
        append(title: "Device IP address", value: ipAddress)

        return attributedString
    }
}
