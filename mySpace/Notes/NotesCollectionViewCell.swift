//
//  NotesCollectionViewCell.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit?
    
    //MARK: Initial views, labels and buttons
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .systemGray2
        dateLabel.numberOfLines = 1
        return dateLabel
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        countLabel.textColor = .systemGray
        countLabel.numberOfLines = 1
        return countLabel
    }()
    
    lazy var checkMark: UIButton = {
        let checkMark = UIButton()
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        checkMark.layer.cornerRadius = 19
        checkMark.setTitleColor(.white, for: .normal)
        checkMark.addTarget(self, action: #selector(tapCheck), for: .touchUpInside)
        return checkMark
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(nameLabel, dateLabel, countLabel, checkMark)
    }
    
    //MARK: Initial edit habit on tap habitCollection
    func initialCell(habit: Habit) {
        self.habit = habit
        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        dateLabel.text = habit.dateString
        countLabel.text = "Счётчик: " + String(habit.trackDates.count)
        if habit.isAlreadyTakenToday {
            checkMark.backgroundColor = habit.color
            checkMark.layer.borderWidth = 1
            checkMark.layer.borderColor = habit.color.cgColor
            checkMark.setTitle("✓", for: .normal)
            checkMark.isUserInteractionEnabled = false
        } else {
            checkMark.backgroundColor = .white
            checkMark.layer.borderWidth = 1
            checkMark.layer.borderColor = habit.color.cgColor
            checkMark.backgroundColor = .white
            checkMark.setTitle("", for: .normal)
            checkMark.isUserInteractionEnabled = true
        }
        initialLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Initial layout
    func initialLayout() {
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     
                                     dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                                     dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     
                                     checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     checkMark.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 40),
                                     checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
                                     checkMark.widthAnchor.constraint(equalToConstant: 38),
                                     checkMark.heightAnchor.constraint(equalToConstant: 38),
                                     
                                     countLabel.topAnchor.constraint(equalTo: checkMark.bottomAnchor, constant: 9),
                                     countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     countLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: 72)
                                    ])
    }
    
    @objc func tapCheck() {
        if let trackHabit = habit {
            HabitsStore.shared.track(trackHabit)
            NotesViewController.collectionView.reloadData()
        }
    }
}

