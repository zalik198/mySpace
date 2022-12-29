//
//  NotesCollectionViewCell.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    var note: Note?
    
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
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .systemGray
        dateLabel.numberOfLines = 1
        return dateLabel
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
        contentView.addSubviews(nameLabel, dateLabel, checkMark)
    }
    
    //MARK: Initial edit note on tap noteCollection
    func initialCell(note: Note) {
        self.note = note
        nameLabel.text = note.name
        nameLabel.textColor = note.color
        dateLabel.text = note.dateString
        if note.isAlreadyTakenToday {
            checkMark.backgroundColor = note.color
            checkMark.layer.borderWidth = 1
            checkMark.layer.borderColor = note.color.cgColor
            checkMark.setTitle("✓", for: .normal)
            checkMark.isUserInteractionEnabled = false
        } else {
            checkMark.backgroundColor = .white
            checkMark.layer.borderWidth = 1
            checkMark.layer.borderColor = note.color.cgColor
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
                                     
                                     checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     checkMark.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 40),
                                     checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
                                     checkMark.widthAnchor.constraint(equalToConstant: 38),
                                     checkMark.heightAnchor.constraint(equalToConstant: 38),
                                     
                                     dateLabel.topAnchor.constraint(equalTo: checkMark.bottomAnchor, constant: 9),
                                     dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     dateLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: 72)
                                    ])
    }
    
    @objc func tapCheck() {
        if let trackNote = note {
            NotesStore.shared.track(trackNote)
            NotesViewController().collectionView.reloadData()
        }
    }
}

