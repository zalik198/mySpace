//
//  ProgressView.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

class ProgressViewCell: UICollectionViewCell {
    
    //MARK: Initial views, labels and buttons
    lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.text = "Твой прогресс!"
        progressLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        progressLabel.backgroundColor = .white
        progressLabel.textColor = .systemGray2
        progressLabel.numberOfLines = 1
        return progressLabel
    }()
    
    lazy var percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        percentLabel.backgroundColor = .white
        percentLabel.textColor = .systemGray2
        percentLabel.numberOfLines = 1
        return percentLabel
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar )
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.trackTintColor = .systemGray2
        progressBar.progressTintColor = constPurpleColor
        progressBar.backgroundColor = .white
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 3.5
        progressBar.subviews[1].clipsToBounds = true
        return progressBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.addSubviews(progressLabel, percentLabel, progressBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialProgress() {
        progressBar.progress = NotesStore.shared.todayProgress
        percentLabel.text = String(Int(NotesStore.shared.todayProgress * 100)) + "%"
        initialLayout()
    }
    
    //MARK: Initial layout
    func initialLayout() {
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            percentLabel.leadingAnchor.constraint(equalTo: progressLabel.trailingAnchor, constant: 16),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 7)
        ])
    }
}
