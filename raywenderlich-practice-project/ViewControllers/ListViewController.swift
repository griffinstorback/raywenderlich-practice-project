//
//  ListViewController.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    // pass in network manager and view model in init (dependency injection)
    let networkManager: NetworkManagerProtocol
    let viewModel: ListViewModel
    var cancellables = Set<AnyCancellable>()
    
    var dataSource: UICollectionViewDiffableDataSource<String, Item>?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let layoutItem = NSCollectionLayoutItem(layoutSize: cellSize)
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellSize, subitem: layoutItem, count: 1)
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        layoutGroup.interItemSpacing = .fixed(20)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
        
        // setup header
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }())
    
    let loadingIndicator = UIActivityIndicatorView()

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared, viewModel: ListViewModel = ListViewModel()) {
        self.networkManager = networkManager
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Library"
        navigationItem.largeTitleDisplayMode = .always

        setupViews()
        layoutViews()
        setupPublishers()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        
        // start spinning loading indicator right away to indicate network request started.
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
    }
    
    private func setupCollectionView() {        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        dataSource = UICollectionViewDiffableDataSource<String, Item>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as! ListCollectionViewCell
            
            cell.updateData(item: item)
            
            // load image async for the cell
            self.viewModel.getImage(fromURL: item.attributes.artworkImageURL) { image, error in
                guard let image = image else {
                    return
                }
                cell.setImage(image, error: error)
            }
            
            return cell
        }
        
        // header setup
        collectionView.register(ListViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListViewHeaderView.reuseIdentifier)
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListViewHeaderView.reuseIdentifier, for: indexPath) as? ListViewHeaderView
            header?.delegate = self
            return header
        }
    }
    
    private func layoutViews() {
        
        // collection view sits under segmented control, stretches to top of view (segmented control hovers over it)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        // add the loading indicator to middle of tableview
        collectionView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([loadingIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
         loadingIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)])
    }
    
    private func setupPublishers() {
        viewModel.items.sink { items in
            DispatchQueue.main.async {
                self.reloadCollectionViewData(items)
                print("items count \(items.count)")
            }
        }.store(in: &cancellables)
    }
    
    func reloadCollectionViewData(_ items: [Item]) {
        loadingIndicator.stopAnimating()
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Item>()
        snapshot.appendSections(["section"])
        snapshot.appendItems(items, toSection: "section")
        dataSource?.apply(snapshot)
    }
    
    func showErrorAlert(for error: Error, callback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: callback)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController: ListViewHeaderDelegate {
    func segmentedControlValueChanged(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            viewModel.displayingTypes = .both
        case 1:
            viewModel.displayingTypes = .articles
        case 2:
            viewModel.displayingTypes = .videos
        default:
            break
        }
    }
}
