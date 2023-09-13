//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by İbrahim Bayram on 13.09.2023.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    @State private var scannedCode = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(maxWidth: .infinity,maxHeight: 300)
                
                Spacer()
                    .frame(height: 60)
                
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red : .green)
                    .padding()
                Button {
                    isShowingAlert = true
                } label: {
                    Text("Tap me")
                }

                
            }
            .navigationTitle("Barcode Scanner")
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Test Title"), message: Text("Test Message"), dismissButton: .cancel(Text("OK"), action: {
                    isShowingAlert = false
                }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
