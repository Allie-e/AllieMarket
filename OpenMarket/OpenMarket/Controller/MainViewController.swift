import UIKit

extension Notification.Name {
    static let updateView = Notification.Name("updateView")
}

class MainViewController: UIViewController {
    private enum Section: CaseIterable {
        case product
    }
    
    private enum ViewMode {
        static let list = 0
        static let grid = 1
    }
    
    let api: APIManageable = APIManager()
    
    // MARK: - Properties
    private var segmentedControl: MarketSegmentedControl!
    private var listCollectionView: UICollectionView!
    private var gridCollectionView: UICollectionView!
    
    private var productList = [ProductInformation]() {
        didSet {
            applyListSnapShot()
            applyGridSnapShot()
        }
    }
    
    private var listDataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpNavigationBar()
        setUpGridCollectionView()
        setUpListCollectionView()
        getProductData()
        setUpListCell()
        setUpGridCell()
        applyListSnapShot(animatingDifferences: false)
        applyGridSnapShot(animatingDifferences: false)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductList), name: .updateView, object: nil)
        listCollectionView.delegate = self
        gridCollectionView.delegate = self
    }
    
    private func setUpSegmentedControl() {
        segmentedControl = MarketSegmentedControl(items: ["LIST","GRID"])
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
    }
    
    private func setUpNavigationBar() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AccessoryImage.plus, style: .plain, target: self, action: #selector(showProductRegisterView))
    }
    
    private func setUpListCollectionView() {
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setListCollectionViewLayout())
            view.addSubview(listCollectionView)
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpGridCollectionView() {
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setGridCollectionViewLayout())
        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func getProductData() {
        api.requestProductList(pageNumber: 1, itemsPerPage: 800) { [weak self] result in
            switch result {
            case .success(let data):
                self?.productList = data.pages
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func updateProductList() {
        getProductData()
    }
    
    // MARK: - List Cell
    private func setUpListCell() {
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCollectionViewCell")
        
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: listCollectionView, cellProvider: { (collectionView, indexPath, product) -> ListCollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as? ListCollectionViewCell else {
                return ListCollectionViewCell()
            }
            cell.configureCell(with: product)
            
            return cell
        })
    }
    
    private func applyListSnapShot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(productList)
        listDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setListCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(view.frame.height * 0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Grid Cell
    private func setUpGridCell() {
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "GridCollectionViewCell")
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: gridCollectionView, cellProvider: { (collectionView, indexPath, product) -> GridCollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as? GridCollectionViewCell else {
                return GridCollectionViewCell()
            }
            cell.configureCell(with: product)
            return cell
        })
    }
    
    private func applyGridSnapShot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(productList)
        gridDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setGridCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(view.frame.height / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func showProductDetailView(with id: Int) {
        let detailViewController = ProductDetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        detailViewController.getProductId(id)
    }
    
    // MARK: - @objc Method
    @objc func changeView(_ sender: MarketSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
        }
    }
    
    @objc func showProductRegisterView() {
        let navigationController = UINavigationController(rootViewController: ProductRegisterViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productId = productList[indexPath.item].id
        showProductDetailView(with: productId)
    }
}
