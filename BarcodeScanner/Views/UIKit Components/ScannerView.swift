//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by İbrahim Bayram on 13.09.2023.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode : String
    @Binding var alertItem : AlertItem?
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        ScannerViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
 
    final class Coordinator : NSObject, ScannerVCDelegate {
        
        private let scannerView : ScannerView
        
        init(scannerView : ScannerView) {
            self.scannerView = scannerView
        }

        func didFind(barcode: String) {
            print(barcode)
            scannerView.scannedCode = barcode
        }
        func didSurface(error: AlertItem) {
            scannerView.alertItem = error
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(scannedCode: .constant("123456"), alertItem: .constant(AlertContext.invalidDeviceInput))
    }
}
