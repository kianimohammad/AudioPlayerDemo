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
    var path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add tap gesture to the volume slider
        let gr = UITapGestureRecognizer(target: self, action: #selector(sliderTapped))
        volumeSlider.addGestureRecognizer(gr)
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            scrubber.maximumValue = Float(player.duration)
        } catch {
            print(error)
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            let audioArray = ["boing", "knife", "shoot", "bach", "wah", "explosion", "hit", "swish",
            "warble"]
            
            let randomNumber = Int.random(in: 0..<audioArray.count)
            path = Bundle.main.path(forResource: audioArray[randomNumber], ofType: "mp3")
            
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
                scrubber.maximumValue = Float(player.duration)
            } catch {
                print(error)
            }
        }
    }
    
    @objc func sliderTapped(_ g: UIGestureRecognizer) {
        
        let s: UISlider? = (g.view as? UISlider)
        if (s?.isHighlighted)! {
            return
        }

        // tap on thumb, let slider deal with it
        let pt: CGPoint = g.location(in: s)
        let percentage = pt.x / (s?.bounds.size.width)!
        let delta = Float(percentage) * Float((s?.maximumValue)! - (s?.minimumValue)!)
        let value = (s?.minimumValue)! + delta
        s?.setValue(Float(value), animated: true)
        player.volume = s!.value
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
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func stopAudio(_ sender: UIBarButtonItem) {
        player.stop()
        timer.invalidate()
        player.currentTime = 0
        playBtn.image = UIImage(systemName: "play.fill")
        isPlaying = false
    }
    
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
        if scrubber.value == scrubber.minimumValue {
            isPlaying = false
            playBtn.image = UIImage(systemName: "play.fill")
        }
    }
    
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrubber.value)
        if isPlaying {
            player.play()
        }
    }
    
}

