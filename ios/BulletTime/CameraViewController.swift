//
//  CameraViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/29/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import AVFoundation
import Async

class CameraViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var movieFileOutput: AVCaptureMovieFileOutput!
    var videoInput: AVCaptureDeviceInput!
    var videoDevice: AVCaptureDevice!

    let videoPath = FileManager.sharedInstance.absolutePath("temp.mp4")
    var cameraLayer: AVCaptureVideoPreviewLayer!
    
    var completion: ((url: NSURL, error: NSError?) -> ())?
    var endTime: Float64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        videoDevice = AVCaptureDevice.backCamera()
        videoInput = try! AVCaptureDeviceInput(device: videoDevice)
        session.addInput(videoInput)
        
        movieFileOutput = AVCaptureMovieFileOutput()
        session.addOutput(movieFileOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.insertSublayer(previewLayer, atIndex: 0)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        updateOrientation()
    }
    
    
    private func updateOrientation() {
        let connection = movieFileOutput.connectionWithMediaType(AVMediaTypeVideo)
        if connection.supportsVideoOrientation {
            connection.videoOrientation = interfaceToVideoOrientation()
            previewLayer.connection.videoOrientation = interfaceToVideoOrientation()
        }
    }
    
    private func interfaceToVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIApplication.sharedApplication().statusBarOrientation {
        case .Portrait:
            return .Portrait
        case .PortraitUpsideDown:
            return .PortraitUpsideDown
        case .LandscapeLeft:
            return .LandscapeLeft;
        case .LandscapeRight:
            return .LandscapeRight;
        default:
            return .Portrait;
        }
    }

    
    func startRecording() {
        let url = NSURL(fileURLWithPath: videoPath)
        FileManager.sharedInstance.removeFileAtPath(videoPath)
        movieFileOutput.startRecordingToOutputFileURL(url, recordingDelegate: self)
    }
    
    func stopRecording() {
        movieFileOutput.stopRecording()
    }
    
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        endTime = CFAbsoluteTimeGetCurrent()
        if error == nil {
            completion?(url: outputFileURL, error: nil)
        } else {
            completion?(url: outputFileURL, error: error)
        }
    }
}
