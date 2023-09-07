//
//  RecordsViewController.swift
//  lumberJack
//
//  Created by admin on 07.09.2023.
//

import UIKit

class RecordsViewController: UIViewController {
    
    var data: [ScoreRecord] = []
    
    // Создайте переменные для изображения и таблицы
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "leaderboard"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = RecordManager.shared.getScoreRecords().reversed()
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let hookView = UIView()
        hookView.backgroundColor = .white
        hookView.translatesAutoresizingMaskIntoConstraints = false
        hookView.clipsToBounds = true
        hookView.layer.cornerRadius = 3
        view.addSubview(hookView)
        NSLayoutConstraint.activate([
            hookView.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
            hookView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            hookView.heightAnchor.constraint(equalToConstant: 6),
            hookView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(logoImageView)
        view.addSubview(tableView)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.clipsToBounds  = true
        tableView.layer.cornerRadius = 20
        setupConstraints()
    }
    
    func setupConstraints() {
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        // Здесь вы можете настроить текст в лейблах в соответствии с вашими данными
        cell.scoreLabel.text = "Score: \(data[indexPath.row].score)"
        cell.nameLabel.text = "\(data[indexPath.row].name)"
        
        return cell
    }
    
    
    
}
