//
//  ViewController.swift
//  AGVolumeControlView
//
//  Created by liptugamichael@gmail.com on 06/09/2017.
//  Copyright (c) 2017 liptugamichael@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation.AVFAudio
import AGVolumeControlView

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeControl: AGVolumeControl!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate var levelTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonDidTouch(_ sender: Any) {
        self.startPlay()
    }
    
    @IBAction func stopButtonDidTouch(_ sender: Any) {
        self.stopPlay()
    }
}

extension ViewController
{
    fileprivate func setupViewController()
    {
        self.volumeControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        self.configureButton(button: self.playButton, imageName: "playButton")
        self.configureButton(button: self.stopButton, imageName: "stopButton")
    }
    
    fileprivate func configureButton (button : UIButton, imageName : String)
    {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.init(red: 117.0/255.0, green: 250.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }
    
    func valueChanged() {
        self.audioPlayer?.volume = Float(self.volumeControl.volumeSliderProgressValue())
    }
    
    fileprivate func startPlay ()
    {
        guard let audioPath2 = Bundle.main.path(forResource: "YDOM", ofType: "mp3") else {
            return
        }
        do {
            self.audioPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: audioPath2))
            self.audioPlayer?.isMeteringEnabled = true
            self.audioPlayer?.volume = Float(self.volumeControl.volumeSliderProgressValue())
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
            self.configureLevelTimer()
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }
    }
    
    fileprivate func stopPlay()
    {
        self.audioPlayer?.stop()
        self.levelTimer?.invalidate()
        self.levelTimer = nil
    }
    
    fileprivate func configureLevelTimer ()
    {
        self.levelTimer = Timer.scheduledTimer(
            timeInterval: Double(0.005),
            target: self,
            selector: #selector(self.levelTimerListener),
            userInfo: nil,
            repeats: true
        )
    }
    
    func levelTimerListener ()
    {
        self.audioPlayer?.updateMeters()
        var level : CGFloat!
        let minDecibels: CGFloat = -80
        if let decibels = self.audioPlayer?.averagePower(forChannel: 0)
        {
            if decibels < Float(minDecibels)
            {
                level = 0
            }
            else if decibels >= 0
            {
                level = 1
            }
            else
            {
                let root: Float = 2
                let minAmp = powf(10, 0.05 * Float(minDecibels))
                let inverseAmpRange: Float = 1 / (1 - minAmp)
                let amp = powf(10, 0.05 * decibels)
                let adjAmp: Float = (amp - minAmp) * inverseAmpRange
                level = CGFloat(powf(adjAmp, 1/root))
            }
            
            self.volumeControl.updateDecibelsLevel(decibelsLevel: level)
        }
    }
}
