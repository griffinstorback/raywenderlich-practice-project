//
//  ListTableViewCell.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ListCollectionViewCellReuseID"
    
    let mainContainerView = UIView()
    
    let nameAndImageStack = UIStackView()
    let nameLabel = UILabel()
    let imageView = UIImageView()
    
    let descriptionLabel = UILabel()
    
    let metaInfoStack = UIStackView()
    let releaseDateLabel = UILabel()
    let contentTypeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupShadow()
        layoutViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        nameAndImageStack.axis = .horizontal
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.numberOfLines = 0
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        descriptionLabel.numberOfLines = 0
        
        metaInfoStack.axis = .horizontal
    }
    
    private func layoutViews() {
        addSubview(mainContainerView)
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mainContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                     mainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                                     mainContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                                     mainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)])
        
        mainContainerView.addSubview(nameAndImageStack)
        nameAndImageStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([nameAndImageStack.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
                                     nameAndImageStack.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
                                     nameAndImageStack.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor)])
        nameAndImageStack.addArrangedSubview(nameLabel)
        
        nameAndImageStack.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalToConstant: 60),
                                     imageView.heightAnchor.constraint(equalToConstant: 60)])
        
        mainContainerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([descriptionLabel.topAnchor.constraint(equalTo: nameAndImageStack.bottomAnchor),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
                                     descriptionLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor)])
        
        mainContainerView.addSubview(metaInfoStack)
        metaInfoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([metaInfoStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
                                     metaInfoStack.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
                                     metaInfoStack.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
                                     metaInfoStack.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)])
        
        metaInfoStack.addArrangedSubview(releaseDateLabel)
        metaInfoStack.addArrangedSubview(contentTypeLabel)
        contentTypeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupShadow() {
        //backgroundView = UIView()
        mainContainerView.clipsToBounds = true
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(item: Item) {
        nameLabel.text = item.attributes.name
        descriptionLabel.text = item.attributes.descriptionPlainText
        releaseDateLabel.text = item.attributes.releaseDate
        contentTypeLabel.text = item.attributes.contentType
    }
    
    func setImage(_ image: UIImage, error: APIError?) {
        /*guard let image = image, error != nil else {
            return
        }*/
        
        imageView.image = image
    }
}
