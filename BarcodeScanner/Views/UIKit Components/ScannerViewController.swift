//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by İbrahim Bayram on 13.09.2023.
//

import UIKit
import AVFoundation

enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}

protocol ScannerVCDelegate : AnyObject {
    func didFind(barcode : String)
    func didSurface(error : AlertItem)
}

final class ScannerViewController : UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    weak var scannerDelegate : ScannerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSessions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer else {
            scannerDelegate?.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    init(scannerDelegate : ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupCaptureSessions() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        let videoInput : AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            scannerDelegate?.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else {
            scannerDelegate?.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean8,.ean13]
        }else {
            scannerDelegate?.didSurface(error: AlertContext.invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
    }
    
}

extension ScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: AlertContext.invalidScannedType)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: AlertContext.invalidScannedType)
            return
        }
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: AlertContext.invalidScannedType)
            return
        }
        scannerDelegate?.didFind(barcode: barcode)
    }
}
