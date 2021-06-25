//
//  RepositoryTableViewCell.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    private lazy var namelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "Основной язык:"
        addSubview(label)
        return label
    }()
    
    private lazy var languageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.init(rawValue: 250), for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.gray
        addSubview(label)
        return label
    }()
    
    private lazy var rightArrowIcon: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.image = #imageLiteral(resourceName: "rightArrow")
        addSubview(label)
        return label
    }()
    
    private(set) var id: Int = -1
    
    static let reuseIdentifier = "RepositoryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            namelabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            namelabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            namelabel.rightAnchor.constraint(lessThanOrEqualTo: rightArrowIcon.leftAnchor, constant: -10),
            namelabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: rightArrowIcon.leftAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: languageLabel.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            languageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            languageLabel.rightAnchor.constraint(equalTo: languageDescriptionLabel.leftAnchor, constant: -10),
            languageLabel.centerYAnchor.constraint(equalTo: languageDescriptionLabel.centerYAnchor),
            languageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            languageDescriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: rightArrowIcon.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightArrowIcon.heightAnchor.constraint(equalToConstant: 24),
            rightArrowIcon.widthAnchor.constraint(equalToConstant: 24),
            rightArrowIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            rightArrowIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(with repository: Repository) {
        namelabel.text = repository.name
        descriptionLabel.text = repository.description
        languageDescriptionLabel.text = repository.mainLanguage
        id = repository.id
    }
    
    override func prepareForReuse() {
        namelabel.text = ""
        descriptionLabel.text = ""
        languageDescriptionLabel.text = ""
        id = -1
    }
}

extension RepositoryTableViewCell {
    struct Repository {
        let name: String
        let description: String
        let mainLanguage: String
        let id: Int
    }
}
