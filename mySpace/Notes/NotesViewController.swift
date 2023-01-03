//
//  ViewController.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit
import SnapKit

class NotesViewController: UIViewController {
    
    //MARK: Initial views, labels and buttons
    static let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInsetReference = .fromContentInset
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    static let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: add button in tabBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(buttonTap))
        viewColors()
        NotesViewController.collectionView.dataSource = self
        NotesViewController.collectionView.delegate = self
        view.addSubview(NotesViewController.collectionView)
        NotesViewController.collectionView.register(ProgressViewCell.self, forCellWithReuseIdentifier: "noteProgress")
        NotesViewController.collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: "noteViewCell")
        initialLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: - Current date format to normal date
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd.MM.yy"
        navigationItem.title = "Сегодня \(dateformat.string(from: currentDate))"
    }
    
    func viewColors() {
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
    }
    
    //MARK: Initial layout
    func initialLayout() {
        NotesViewController.collectionView.snp.makeConstraints { make in
            make.top.bottom.width.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: tap addButton
    @objc func buttonTap() {
        self.navigationController?.pushViewController(NoteViewController(nil), animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

//MARK: Extension NotessViewController
extension NotesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NotesStore.shared.notes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteProgress", for: indexPath) as? ProgressViewCell else { return UICollectionViewCell() }
            cell.initialProgress()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteViewCell", for: indexPath) as? NotesCollectionViewCell else { return UICollectionViewCell() }
            let sortCell = NotesStore.shared.notes.sorted { $0.date > $1.date }
            cell.initialCell(note: sortCell[indexPath.item - 1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.item == 0) {
            guard let item = collectionView.cellForItem(at: indexPath) as? NotesCollectionViewCell else { return }
            if let note = item.note {
                navigationController?.pushViewController(NoteViewController(note), animated: false)
                navigationController?.navigationBar.prefersLargeTitles = false
            }
        }
    }
}

extension NotesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 60)
        } else {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 130)
        }
    }
}




