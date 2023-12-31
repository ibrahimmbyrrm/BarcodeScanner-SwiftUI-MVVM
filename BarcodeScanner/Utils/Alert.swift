//
//  Alert.swift
//  BarcodeScanner
//
//  Created by İbrahim Bayram on 13.09.2023.
//

import Foundation
import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    let title : String
    let message : String
    let dismissButton : Alert.Button
}
struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input", message: "Something is wrong with camera. We are unable to capture the input.", dismissButton: .default(Text("OK")))
    static let invalidScannedType = AlertItem(title: "Invalid Scanned Value", message: "Tthe value scanned is not valid. This app scans EAN-8 and EAN-13.", dismissButton: .default(Text("OK")))
}
