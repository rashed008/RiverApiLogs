//
//  NFXSettingsController.swift
//  RiverApiLogs
//
//  Created by Md Rashed Pervez on 27/4/25.
//

    
import Foundation

class NFXSettingsController: NFXGenericController {
    // MARK: Properties

    let nfxVersionString = "RiverDebugStream - \(RiverDebugStreamVersion)"
    var nfxURL = "https://www.river.app/" //https://github.com/kasketis/netfox"
    
    var tableData = [HTTPModelShortType]()
    var filters = NFXHTTPModelManager.shared.filters
}
