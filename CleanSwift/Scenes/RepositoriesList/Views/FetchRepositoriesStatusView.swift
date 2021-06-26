//
//  FetchRepositoriesStatusView.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import UIKit

class FetchRepositoriesStatusView: UIView {
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0)
        addSubview(label)
        return label
    }()
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0)
        addSubview(label)
        return label
    }()
    private lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "loader")
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        [errorLabel, emptyLabel, loadingImageView].forEach { view in
            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
        [errorLabel, emptyLabel].forEach { view in
            NSLayoutConstraint.activate([
                view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
                view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24)
            ])
        }
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    func update(status: RepositoriesList.FetchRepositoriesStatus) {
        updateHiddenViewsProperty(for: status)
        
        switch status {
        case .emptyRequest:
            emptyLabel.text = "Начните поиск"
        case .emptyResponse:
            emptyLabel.text = """
                Упс...
                Нечего не найдено
                """
        case .error(let error):
            errorLabel.text = """
                Ошибка
                
                \(error.localizedDescription)
                """
        default:
            break
        }
        
        if case .loading = status {
            loadingImageView.startRotating()
        } else {
            loadingImageView.stopRotating()
        }
    }
    
    private func updateHiddenViewsProperty(for status: RepositoriesList.FetchRepositoriesStatus) {
        var selfIsHidden = false
        var errorLabelIsHidden = true
        var emptyLabelIsHidden = true
        var loadingImageIsHidden = true
        
        switch status {
        case .success:
            selfIsHidden = true
        case .loading:
            loadingImageIsHidden = false
        case .emptyRequest:
            emptyLabelIsHidden = false
        case .emptyResponse:
            emptyLabelIsHidden = false
        case .error:
            errorLabelIsHidden = false
        }
        
        isHidden = selfIsHidden
        errorLabel.isHidden = errorLabelIsHidden
        emptyLabel.isHidden = emptyLabelIsHidden
        loadingImageView.isHidden = loadingImageIsHidden
    }
}
