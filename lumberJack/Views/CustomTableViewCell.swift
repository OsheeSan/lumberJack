//
//  CustomTableViewCell.swift
//  lumberJack
//
//  Created by admin on 07.09.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // Создаем два UILabel для отображения счета и имени
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right // Сделаем выравнивание текста справа
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left // Сделаем выравнивание текста слева
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавляем лейблы к ячейке
        contentView.addSubview(scoreLabel)
        contentView.addSubview(nameLabel)
        
        // Настраиваем констрейнты
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Метод для настройки констрейнтов
    private func setupConstraints() {
        // Констрейнты для scoreLabel
        scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        // Констрейнты для nameLabel
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
}
