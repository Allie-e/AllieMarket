import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    
    @IBOutlet weak var segment: SegmentedControl!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    var productList = [ProductInformation](){
        didSet {
            applyListSnapShot()
            applyGridSnapShot()
        }
    }
    
    private var listDataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCollectionView.collectionViewLayout = setListCollectionView()
        gridCollectionView.collectionViewLayout = setGridCollectionView()
        
        setSegmentedControl()
        getData()
        setUpListCell()
        setUpGridCell()
        applyListSnapShot(animatingDifferences: false)
        applyGridSnapShot(animatingDifferences: false)
    }
    
    func setSegmentedControl() {
        self.navigationItem.titleView = segment
        segment.setUpUI()
    }
    
    @IBAction func changeView(_ sender: SegmentedControl) {
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
    
    func getData() {
        let api = APIManager()
        api.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - List Cell
    func setUpListCell() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, ProductInformation> { cell, indexpath, product in
            
            cell.configCell(with: product)
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: listCollectionView, cellProvider: { (collectionView, indexPath, product) -> ListCollectionViewCell in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
            
            return cell
        })
    }
    
    func applyListSnapShot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(productList)
        listDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setListCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(view.frame.height * 0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Grid Cell
    func setUpGridCell() {
        let cellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, ProductInformation> { cell, indexpath, product in
      
            cell.configCell(with: product)
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: gridCollectionView, cellProvider: { (collectionView, indexPath, product) -> GridCollectionViewCell in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
            
            return cell
        })
    }
    
    func applyGridSnapShot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(productList)
        gridDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setGridCollectionView() -> UICollectionViewLayout {
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
}
