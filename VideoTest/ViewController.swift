//
//  ViewController.swift
//  VideoTest
//
//  Created by Hsu Hao Chun on 2021/6/7.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var player:AVPlayer?
    var playerItem:AVPlayerItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let filepath = Bundle.main.path(forResource: "123", ofType: "mp4")
//        let asset = AVAsset(url: filepath)
        
        let asset = AVAsset.init(url: URL.init(fileURLWithPath: filepath!, isDirectory: true))
        let reader = try! AVAssetReader(asset: asset)

        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)

        reader.add(trackReaderOutput)
        reader.startReading()

        plackTrack(track: videoTrack)
        
        var numFrames = 0
        var keyFrames = 0

        while true {
            if let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
                // NB: not every sample buffer corresponds to a frame!
                print (sampleBuffer)
                if CMSampleBufferGetNumSamples(sampleBuffer) > 0 {
                    numFrames += 1
                    if let attachmentArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, createIfNecessary: false) as? NSArray {
                        let attachment = attachmentArray[0] as! NSDictionary
                        // print("attach on frame \(frame): \(attachment)")
                        if let depends = attachment[kCMSampleAttachmentKey_DependsOnOthers] as? NSNumber {
                            if !depends.boolValue {
                                keyFrames += 1
                            }
                        }
                    }
                }
            } else {
                break
            }
            
            
        }
        
        print("\(keyFrames) on \(numFrames)")
        // Do any additional setup after loading the view.
    }
    
    func plackTrack(track:AVAssetTrack?){
            guard let asset = track?.asset else{
                return
            }
            playerItem = AVPlayerItem.init(asset: asset)
            player = AVPlayer.init(playerItem: playerItem!)
            let playerlayer = AVPlayerLayer.init(player: player!)
            playerlayer.frame = view.bounds
            self.view.layer.addSublayer(playerlayer)
            player?.play()
        }


}

