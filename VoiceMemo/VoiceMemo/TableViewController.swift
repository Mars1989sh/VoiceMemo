//
//  TableViewController.swift
//  VoiceMemo
//
//  Created by Mars Zhang on 2017/8/27.
//  Copyright © 2017年 Mars Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class TableViewController: UITableViewController {
    
    var childrenPath:[String]?
    var audioPlayer:AVAudioPlayer?
    var playIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        childrenPath = fileManager.subpaths(atPath: basePath!)
        print(childrenPath!)
        
        if (childrenPath == nil) {
            self.title = "没有录音文件"
        } else {
            if(childrenPath?.count==0){
                self.title = "没有录音文件"
            } else {
                childrenPath = childrenPath?.sorted(by: >)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func audioPlay(url:URL) {
        do {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayback)
            } catch let err{
                print("设置失败:\(err.localizedDescription)")
            }
            audioPlayer = try AVAudioPlayer(contentsOf:url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.delegate = self
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    func audioPause(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:url)
            audioPlayer?.pause()
        } catch let err {
            print("暂停失败:\(err.localizedDescription)")
        }
    }
    
    
    func directoryURL(index:Int) -> URL? {
        let recordingName = childrenPath?[index]
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName!)
        return soundURL
    }
    
    func startVoice (index: Int){
        print("play \(index)")
        let oldPlayIndex = playIndex
        playIndex = index
        let url = directoryURL(index: index)
        audioPlay(url: url!)
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        if oldPlayIndex != nil {
            let indexPath = IndexPath(row: oldPlayIndex!, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        self.title = "播放中..."
    }
    
    func endVoice (index: Int){
        if (index == playIndex) {
            let url = directoryURL(index: index)
            audioPause(url: url!)
            self.playIndex = nil
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.title = ""
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return childrenPath?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell

        // Configure the cell...       
        cell.delegate = self
        cell.playButton.tag = indexPath.row
        cell.titleLabel.text = childrenPath?[indexPath.row] ?? ""
        cell.statusView.isHidden = (playIndex == indexPath.row ? false:true)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        endVoice(index: indexPath.row)
    }
}



extension  TableViewController: TableViewCellDelegate {
    func playVoice(index: Int) {
        startVoice(index: index)
    }
}

extension  TableViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (playIndex != nil) {
            endVoice(index: playIndex!)
        }
    }
}
