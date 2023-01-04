//
//  ProgressView.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit
import SnapKit

class ProgressViewCell: UICollectionViewCell {
    
    //MARK: Initial views, labels and buttons
    lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.text = "Твой прогресс!"
        progressLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        progressLabel.backgroundColor = .white
        progressLabel.textColor = .systemGray2
        progressLabel.numberOfLines = 1
        return progressLabel
    }()
    
    lazy var percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        percentLabel.backgroundColor = .white
        percentLabel.textColor = .systemGray2
        percentLabel.numberOfLines = 1
        return percentLabel
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar )
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
    
    //MARK: Initial layout SnapKit
    func initialLayout() {
        progressLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(16)
        }
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(progressLabel.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
            make.height.equalTo(7)
        }
        
    }
}
