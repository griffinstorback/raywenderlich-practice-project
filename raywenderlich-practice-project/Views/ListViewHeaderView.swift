//
//  ListViewHeaderView.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-11.
//

import UIKit

protocol ListViewHeaderDelegate: NSObjectProtocol {
    func segmentedControlValueChanged(selectedIndex: Int)
}

class ListViewHeaderView: UICollectionReusableView {
    
    static var reuseIdentifier: String = "ListViewHeaderViewReuseID"
    
    weak var delegate: ListViewHeaderDelegate?
    
    let typesShowingSegmentedControl = UISegmentedControl(items: ["All", "Articles", "Videos"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        typesShowingSegmentedControl.selectedSegmentIndex = 0
        typesShowingSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func layoutViews() {
        addSubview(typesShowingSegmentedControl)
        typesShowingSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([typesShowingSegmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                     //typesShowingSegmentedControl.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor),
                                     typesShowingSegmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                                     //typesShowingSegmentedControl.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                                     typesShowingSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    @objc func segmentedControlValueChanged() {
        delegate?.segmentedControlValueChanged(selectedIndex: typesShowingSegmentedControl.selectedSegmentIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
