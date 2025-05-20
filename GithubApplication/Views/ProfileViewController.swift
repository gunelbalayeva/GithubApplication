//
//  ProfileViewController.swift
//  GithubApplication
//
//  Created by User on 16.05.25.

import Foundation
import UIKit
import SnapKit
class ProfileViewController: UIViewController {
    private let viewModel = DIContainer.shared.makeProfileViewModel()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.systemBrown.cgColor
        tf.backgroundColor = UIColor(named: "textFieldColor")
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16, weight: .medium)
        tf.layer.cornerRadius = 5
        tf.clipsToBounds = true
        tf.attributedPlaceholder = NSAttributedString(
            string: "Write username",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ])
        return tf
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Search", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "searchColor")
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        return btn
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "a73e811d-e538-48ce-ba53-fea25fbf9238")
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 50
        imageview.clipsToBounds = true
        imageview.layer.borderWidth = 2
        imageview.layer.borderColor = UIColor.white.cgColor
        return imageview
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Gunel Balayeva"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var statsContainerView: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0 followers"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 following"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var publicReposLabel: UILabel = {
        let label = UILabel()
        label.text = "0 public repos"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")
        configureUI()
        setupConstraints()
        bindViewModel()
    }
}

// Methods
extension ProfileViewController{
    
    @objc
    func didTapSearch() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty else { return }
        print("Searching for:", username)
        viewModel.fetchUser(username: username)
    }
    
    private func configureUI() {
        [usernameTextField, searchButton,
         profileImageView, usernameLabel,
         bioLabel, statsContainerView]
            .forEach { view.addSubview($0) }
        [followersLabel, followingLabel, publicReposLabel]
            .forEach { statsContainerView.addSubview($0) }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let u = self?.viewModel.user else { return }
            self?.usernameLabel.text = u.login
            self?.bioLabel.text = u.bio ?? ""
            self?.followersLabel.text = "\(u.followers) followers"
            self?.followingLabel.text = "\(u.following) following"
            self?.publicReposLabel.text = "\(u.public_repos) public repos"
            
            URLSession.shared.dataTask(with: u.avatar_url) { data,_,_ in
                if let d = data {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = UIImage(data: d)
                    }
                }
            }.resume()
        }
    }
}

// Constraints
extension ProfileViewController {
    private func setupConstraints() {
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        followersLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
        
        followingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(followersLabel.snp.trailing).offset(10)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
        
        publicReposLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(followingLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
    }
}
