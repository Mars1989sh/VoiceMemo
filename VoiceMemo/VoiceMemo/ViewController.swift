//
//  ViewController.swift
//  VoiceMemo
//
//  Created by Mars Zhang on 2017/8/27.
//  Copyright © 2017年 Mars Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var url:URL?
    
    let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 44100),
        AVFormatIDKey: NSNumber(value: kAudioFormatAppleIMA4),
        AVLinearPCMBitDepthKey: NSNumber(value: 16),
        AVNumberOfChannelsKey: NSNumber(value: 1),
        AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue)
    ];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func directoryURL() -> URL? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh:mm:ss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        return soundURL
    }
    
    
    func beginRecord() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        } catch let err{
            print("设置失败:\(err.localizedDescription)")
        }
        do {
            url = directoryURL()
            audioRecorder = try AVAudioRecorder(url: url!, settings: recordSetting)
            audioRecorder!.prepareToRecord()
            audioRecorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    func stopRecord() {
        if let recorder = self.audioRecorder {
            recorder.stop()
            print("结束录音")
        }else {
            print("没有初始化")
        }
    }
    
    func play() {
        do {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayback)
            } catch let err{
                print("设置失败:\(err.localizedDescription)")
            }
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder!.url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = 0
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    func pause() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder!.url)
            audioPlayer?.pause()
        } catch let err {
            print("暂停失败:\(err.localizedDescription)")
        }
    }
    

    @IBAction func recordUpInsideAction(_ sender: Any) {
        
        if audioRecorder != nil {
            if (audioRecorder?.isRecording)!{
                playButton.isHidden = false
                stopRecord()
            } else {
                playButton.isHidden = true
                beginRecord()
            }
        } else {
            playButton.isHidden = true
            beginRecord()
        }
    }

    @IBAction func playVoice(_ sender: Any) {
        if audioPlayer != nil {
            if (audioPlayer?.isPlaying == true){
                pause()
            }else{
                play()
            }
        } else {
            play()
        }
    }
}

