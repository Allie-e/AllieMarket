import UIKit

class MarketSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setUpUI(items: items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI(items: [Any]?) {
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 2
        selectedSegmentTintColor = UIColor.systemBlue
        selectedSegmentIndex = 0
        setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
