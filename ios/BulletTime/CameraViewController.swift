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
    
    let sessionQueue: DispatchQueue = DispatchQueue(label: "session queue", attributes: [])
    let session = AVCaptureSession()
    let movieFileOutput = AVCaptureMovieFileOutput()

    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoInput: AVCaptureDeviceInput!
    var videoDevice: AVCaptureDevice!
    var cameraLayer: AVCaptureVideoPreviewLayer!

    let videoPath = FileManager.sharedInstance.absolutePath("temp.mp4")
    
    var completion: ((_ url: URL, _ error: NSError?) -> ())?
    var startTime: Float64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recLabel.isHidden = true

        previewLayer = AVCaptureVideoPreviewLayer(session: self.session)

        
        Async.custom(queue: sessionQueue) {
            self.session.sessionPreset = AVCaptureSessionPreset1280x720
            self.videoDevice = AVCaptureDevice.backCamera()
            self.videoInput = try! AVCaptureDeviceInput(device: self.videoDevice)
            self.session.addInput(self.videoInput)
            self.session.addOutput(self.movieFileOutput)
            
            var bestFormat: AVCaptureDeviceFormat?
            let formats = self.videoDevice.formats!
            for format in formats {
                for range in (format as AnyObject).videoSupportedFrameRateRanges {
                    if (range as AnyObject).maxFrameRate >= 240 {
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
            self.previewView.layer.insertSublayer(self.previewLayer, at: 0)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Async.custom(queue: sessionQueue) {
            self.session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Async.custom(queue: sessionQueue) {
            self.session.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
//        updateOrientation()
    }
    
    
    fileprivate func updateOrientation() {
        let connection = movieFileOutput.connection(withMediaType: AVMediaTypeVideo)
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = interfaceToVideoOrientation()
            previewLayer.connection.videoOrientation = interfaceToVideoOrientation()
        }
    }
    
    fileprivate func interfaceToVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft;
        case .landscapeRight:
            return .landscapeRight;
        default:
            return .portrait;
        }
    }

    
    func startRecording() {
//        recLabel.hidden = false
        let url = URL(fileURLWithPath: videoPath)
        FileManager.sharedInstance.removeFileAtPath(videoPath)
        movieFileOutput.startRecording(toOutputFileURL: url, recordingDelegate: self)
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stopRecording() {
//        recLabel.hidden = true
        movieFileOutput.stopRecording()
    }
    
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        if error == nil {
            completion?(outputFileURL, nil)
        } else {
            completion?(outputFileURL, error as NSError?)
        }
    }
}
