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
    @IBOutlet weak var recLabel: UILabel!
    
    let sessionQueue: dispatch_queue_t = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)
    let session = AVCaptureSession()
    let movieFileOutput = AVCaptureMovieFileOutput()

    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoInput: AVCaptureDeviceInput!
    var videoDevice: AVCaptureDevice!
    var cameraLayer: AVCaptureVideoPreviewLayer!

    let videoPath = FileManager.sharedInstance.absolutePath("temp.mp4")
    
    var completion: ((url: NSURL, error: NSError?) -> ())?
    var startTime: Float64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recLabel.hidden = true

        previewLayer = AVCaptureVideoPreviewLayer(session: self.session)

        
        Async.customQueue(sessionQueue) {
            self.session.sessionPreset = AVCaptureSessionPreset1280x720
            self.videoDevice = AVCaptureDevice.backCamera()
            self.videoInput = try! AVCaptureDeviceInput(device: self.videoDevice)
            self.session.addInput(self.videoInput)
            self.session.addOutput(self.movieFileOutput)
            
            var bestFormat: AVCaptureDeviceFormat?
            let formats = self.videoDevice.formats
            for format in formats {
                for range in format.videoSupportedFrameRateRanges {
                    if range.maxFrameRate >= 240 {
                        bestFormat = format as? AVCaptureDeviceFormat
                    }
                }
            }
            if let format = bestFormat {
                let fps = CMTimeMake(1, 240)
                try! self.videoDevice.lockForConfiguration()
                self.videoDevice.activeFormat = format
                self.videoDevice.activeVideoMaxFrameDuration = fps
                self.videoDevice.activeVideoMinFrameDuration = fps
                self.videoDevice.unlockForConfiguration()
            }

        }.main {
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.previewView.layer.insertSublayer(self.previewLayer, atIndex: 0)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Async.customQueue(sessionQueue) {
            self.session.startRunning()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Async.customQueue(sessionQueue) {
            self.session.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
//        updateOrientation()
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
//        recLabel.hidden = false
        let url = NSURL(fileURLWithPath: videoPath)
        FileManager.sharedInstance.removeFileAtPath(videoPath)
        movieFileOutput.startRecordingToOutputFileURL(url, recordingDelegate: self)
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stopRecording() {
//        recLabel.hidden = true
        movieFileOutput.stopRecording()
    }
    
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        if error == nil {
            completion?(url: outputFileURL, error: nil)
        } else {
            completion?(url: outputFileURL, error: error)
        }
    }
}
