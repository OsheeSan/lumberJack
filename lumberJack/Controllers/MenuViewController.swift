//
//  MenuViewController.swift
//  lumberJack
//
//  Created by admin on 05.09.2023.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    var logoImageView: UIImageView!
    
    var playMenuView: UIView!
    
    var playButton: UIButton!
    var instructionButton: UIButton!
    var leaderboardButton: UIButton!
    var backgroundImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
        setupBackground()
        setupLogo()
        setupButtons()
    }
    
    func playBackgroundMusic() {
        if  backgroundMusicPlayer == nil {
            if let musicURL = Bundle.main.url(forResource: "background", withExtension: "mp3") {
                do {
                    backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                    backgroundMusicPlayer.numberOfLoops = -1  // Loop indefinitely
                    backgroundMusicPlayer.volume = 0.5 // Adjust the volume as needed
                    backgroundMusicPlayer.play()
                } catch {
                    print("Error playing background music: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.frame = view.frame
        backgroundImageView.image = UIImage(named: "backgroundMenu")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        let jack = UIImageView()
        jack.image = UIImage(named: "jackMenu")
        jack.contentMode = .scaleAspectFill
        jack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(jack)
        
        NSLayoutConstraint.activate([
            jack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            jack.heightAnchor.constraint(equalTo: jack.widthAnchor),
            jack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            jack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.safeAreaLayoutGuide.layoutFrame.height/4)
        ])
        
        
        let citateTable = UIImageView()
        citateTable.image = UIImage(named: "citateTable")
        citateTable.contentMode = .scaleAspectFill
        citateTable.translatesAutoresizingMaskIntoConstraints = false
        citateTable.isUserInteractionEnabled = true
        view.addSubview(citateTable)
        
        NSLayoutConstraint.activate([
            citateTable.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            citateTable.heightAnchor.constraint(equalTo: citateTable.widthAnchor, multiplier: 0.5),
            citateTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            citateTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let textView = UITextView()
        textView.text = citates.randomElement()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        citateTable.addSubview(textView)
        textView.font = UIFont(name: "AvenirNext-Bold", size: 12)
        textView.textColor = .yellow
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalTo: citateTable.widthAnchor, multiplier: 0.8),
            textView.centerXAnchor.constraint(equalTo: citateTable.centerXAnchor),
            textView.topAnchor.constraint(equalTo: citateTable.topAnchor, constant: 25),
            textView.bottomAnchor.constraint(equalTo: citateTable.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupLogo()  {
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height/2)
        ])
    }
    
    private func setupButtons(){
        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFill
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
        ])
        leaderboardButton = UIButton(type: .custom)
        leaderboardButton.setImage(UIImage(named: "leaderboardButton"), for: .normal)
        leaderboardButton.imageView?.contentMode = .scaleAspectFill
        leaderboardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderboardButton.addTarget(self, action: #selector(leaderboard), for: .touchUpInside)
        view.addSubview(leaderboardButton)
        NSLayoutConstraint.activate([
            leaderboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            leaderboardButton.heightAnchor.constraint(equalTo: leaderboardButton.widthAnchor),
            leaderboardButton.topAnchor.constraint(equalTo: playButton.bottomAnchor,constant: 20)
        ])
    }
    
    @objc private func play() {
        performSegue(withIdentifier: "play", sender: playButton)
    }
    
    @objc private func leaderboard() {
        let vc = RecordsViewController()
        self.present(vc, animated: true)
    }
    
    var citates: [String] = ["The woods are full of life.", "A hint of wood can make a difference.", "When wood burns, it means it's of good quality.", "Woodworking is the perfect pastime for patient people.", "A wood is more alive than you think.", "Wood has different shades, and the darkest resembles a heart.", "Just like most things in life, wood is a product of nature.", "Woods will teach you real-life lessons.", "Woodcutting offers fast results.", "A heart of wood is solid and unbreakable.", "Wood burns for you to stay warm.", "When putting effort in cutting wood, the supply fades fast.", "Wood is man's best friend.", "Wood can be more useful than a lot of people.", "Woodworking allows you to let off steam.", "A wooden world is prettier than a rocky one.", "No one can deny the beauty of wood.", "New problems require new wood.", "Wood is valuable - never waste it.", "Woods are refreshing and faithful.", "There are a lot of intriguing activities you can do with wood.", "If not accompanied with sense, wood is just wood.", "Find your roots.", "Woods accepts all kinds of talents, good and bad ones. So, keep trying.", "Wood always takes part in amazing sceneries."]
}

