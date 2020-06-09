//
//  ViewController.swift
//  AudioPlayerDemo
//
//  Created by Mohammad Kiani on 2020-06-08.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playBtn: UIBarButtonItem!
    
    var isPlaying = false
    
    // we need to create an instance of AVAudioPlayer
    var player = AVAudioPlayer()
    
    // we need to access to the audio file path
    let path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            scrubber.maximumValue = Float(player.duration)
        } catch {
            print(error)
        }
        
    }

    @IBAction func playAudio(_ sender: UIBarButtonItem) {
        if isPlaying {
            playBtn.image = UIImage(systemName: "play.fill")
            player.pause()
            isPlaying = false
            timer.invalidate()
        } else {
            playBtn.image = UIImage(systemName: "pause.fill")
            player.play()
            isPlaying = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
//        if scrubber.value == scrubber.minimumValue {
//            isPlaying = false
//            playBtn.image = UIImage(systemName: "play.fill")
//        }
    }
    
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrubber.value)
        if isPlaying {
            player.play()
        }
    }
    
}

