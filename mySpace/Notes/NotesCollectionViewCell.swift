//
//  NotesCollectionViewCell.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit
import SnapKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    var note: Note?
    
    //MARK: Initial views, labels and buttons
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.numberOfLines = 1
        return nameLabel
    }()
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textLabel.numberOfLines = 2
        return textLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .systemGray
        dateLabel.numberOfLines = 1
        return dateLabel
    }()
    
    lazy var checkMark: UIButton = {
        let checkMark = UIButton()
        checkMark.layer.cornerRadius = 19
        checkMark.setTitleColor(.white, for: .normal)
        checkMark.addTarget(self, action: #selector(tapCheck), for: .touchUpInside)
        return checkMark
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(nameLabel, textLabel, dateLabel, checkMark)
    }
    
    //MARK: Initial edit note on tap noteCollection
    func initialCell(note: Note) {
        self.note = note
        nameLabel.text = note.name
        textLabel.text = note.text
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
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(16)
            make.width.equalTo(215)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(20)
            make.width.equalTo(215)
            
        }
        checkMark.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(textLabel.snp.trailing).offset(40)
            make.trailing.equalTo(contentView).inset(26)
            make.height.width.equalTo(38)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(20)
            //make.trailing.equalTo(checkMark.snp.leading).offset(72)
        }
    }
    
    @objc func tapCheck() {
        if let trackNote = note {
            NotesStore.shared.track(trackNote)
            NotesViewController.collectionView.reloadData()
        }
    }
}

