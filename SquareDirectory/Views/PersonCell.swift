
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import UIKit

final class PersonCell: UITableViewCell {
    
    //MARK: - Properties
    private let thumbNailPhotoIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let employeeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .preferredFont(for: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let employeeTeamLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = .preferredFont(for: .headline, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var heightConstraint: NSLayoutConstraint!
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    private func setupCell() {
        contentView.addSubview(thumbNailPhotoIV)
        contentView.addSubview(employeeNameLabel)
        contentView.addSubview(employeeTeamLabel)
        
        NSLayoutConstraint.activate([
            //Layout Photo
            thumbNailPhotoIV.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            thumbNailPhotoIV.widthAnchor.constraint(equalToConstant: 45),
            thumbNailPhotoIV.heightAnchor.constraint(equalTo: thumbNailPhotoIV.widthAnchor),
            thumbNailPhotoIV.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            thumbNailPhotoIV.trailingAnchor.constraint(equalToSystemSpacingAfter: employeeNameLabel.leadingAnchor,
//                                                       multiplier: 2),

            //Layout Employee Name
            employeeNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            employeeNameLabel.bottomAnchor.constraint(equalTo: employeeTeamLabel.topAnchor), //
            employeeNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: thumbNailPhotoIV.trailingAnchor,
                                                       multiplier: 2),
//            employeeNameLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: safeAreaLayoutGuide.trailingAnchor,
//                                                        multiplier: 10),
//            employeeNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            employeeNameLabel.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
            employeeNameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            
            //Layout Employee Team
            employeeTeamLabel.topAnchor.constraint(equalTo: employeeNameLabel.bottomAnchor),
            employeeTeamLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            employeeTeamLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: thumbNailPhotoIV.trailingAnchor,
                                                       multiplier: 2),
            employeeTeamLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            employeeTeamLabel.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
            employeeTeamLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width)
        ])
        
        
        //TO-DO: Fix or remove, tryign to get the cell height to be dynamic.
        let height: CGFloat = 200
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    //MARK: - Interface Methods
    
    func configure(employeeName: String, employeeTeam: String) {
        employeeNameLabel.text = employeeName
        employeeTeamLabel.text = employeeTeam
    }
    
    func setImage(_ image: UIImage?) {
        if let image = image {
            let imageRadius = thumbNailPhotoIV.frame.width / 2
            self.thumbNailPhotoIV.layer.cornerRadius = imageRadius
            self.thumbNailPhotoIV.layer.masksToBounds = true
            self.thumbNailPhotoIV.image = image
        }
        else {
            thumbNailPhotoIV.image = UIImage(systemName: "person.crop.circle.fill")
            thumbNailPhotoIV.tintColor = .lightGray
        }
    }
    
    
}
