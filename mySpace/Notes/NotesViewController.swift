//
//  ViewController.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

class NotesViewController: UIViewController {
    
   // let habit: Habit?

//    //MARK: init habit
//    init(_ habit: Habit) {
//        self.habit = habit
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
        
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: add button in tabBar
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(buttonTap))
        
        NotesViewController.collectionView.dataSource = self
        NotesViewController.collectionView.delegate = self
        
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        view.addSubview(NotesViewController.collectionView)
        
        NotesViewController.collectionView.register(ProgressViewCell.self, forCellWithReuseIdentifier: "habitProgress")
        NotesViewController.collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: "habitViewCell")
        
        initialLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сегодня"
    }
    
    //MARK: Initial layout
    func initialLayout() {
        NSLayoutConstraint.activate([NotesViewController.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     NotesViewController.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     NotesViewController.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     NotesViewController.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                                    ])
    }
    
    //MARK: tap addButton
    @objc func buttonTap() {
        self.navigationController?.pushViewController(NoteViewController(nil), animated: false)
        //NotesViewController().navigationItem.title = "Создать"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

//MARK: Extension HabitsViewController
extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitProgress", for: indexPath) as? ProgressViewCell else { return UICollectionViewCell() }
            cell.initialProgress()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitViewCell", for: indexPath) as? NotesCollectionViewCell else { return UICollectionViewCell() }
            cell.initialCell(habit: HabitsStore.shared.habits[indexPath.item - 1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 60)
        } else {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.item == 0) {
            guard let item = collectionView.cellForItem(at: indexPath) as? NotesCollectionViewCell else { return }
            if let habit = item.habit {
                navigationController?.pushViewController(NoteViewController(habit), animated: true)
                navigationController?.navigationBar.prefersLargeTitles = false
                
            }
        }
    }
    
}




