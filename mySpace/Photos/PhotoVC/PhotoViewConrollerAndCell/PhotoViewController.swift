//
//  PhotosViewController.swift
//  mySpace
//
//  Created by Shom on 27.12.2022.
//

import UIKit
import SnapKit

protocol PhotoViewInputProtocol: AnyObject {
    func display(_ detail: [Result])
}

protocol PhotoViewOutputProtocol: AnyObject {
    var router: PhotoRouterInputProtocol! { get }
    
    init(view: PhotoViewInputProtocol)
    func viewDidLoad()
}

class PhotoViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    private var photo: [Result] = []
    
    var presenter: PhotoViewOutputProtocol!
    private let configurator: PhotoConfiguratorInputProtocol = PhotoConfigurator()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.viewDidLoad()
        setupUI()
        initialLayout()
    }
    
    // MARK: Initial layout SnapKit
    func initialLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.width.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupUI() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Фотографии"
        self.view.backgroundColor = .white
        networkManager.fetchPhotos()
        view.addSubviews(collectionView)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: Extension CollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = networkManager.results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.id, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: imageURLString)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.results.count
    }
}

//MARK: - Extension CollectionView Delegate
extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        let config: DetailConfiguratorInputProtocol = DetailConfigurator()
        config.configure(with: vc, and: networkManager.results[indexPath.row])
        presenter.router.openDetailViewController(with: vc)
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width/2 - 12, height: view.frame.size.width/2)
    }
}

//MARK: - Extension PhotoViewInputProtocol
extension PhotoViewController: PhotoViewInputProtocol {
    func display(_ photo: [Result]) {
        self.photo = photo
        //collectionView.reloadData()
    }
}


