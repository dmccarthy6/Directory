
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
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .darkGray
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
        label.textColor = .systemGray
        label.font = .preferredFont(for: .headline, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var onReuse: () -> Void = {}
    
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        thumbNailPhotoIV.image = nil
    }
    
    //MARK: - Helpers
    private func setupCell() {
        contentView.addSubview(thumbNailPhotoIV)
        contentView.addSubview(employeeNameLabel)
        contentView.addSubview(employeeTeamLabel)
        
        let guide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            //Layout Photo
            thumbNailPhotoIV.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            thumbNailPhotoIV.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            thumbNailPhotoIV.widthAnchor.constraint(equalToConstant: 55),
            thumbNailPhotoIV.heightAnchor.constraint(equalTo: thumbNailPhotoIV.widthAnchor),
            
            //Layout Employee Name
            employeeNameLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            employeeNameLabel.bottomAnchor.constraint(equalTo: employeeTeamLabel.topAnchor),
            employeeNameLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            employeeNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: thumbNailPhotoIV.trailingAnchor,multiplier: 2),
            
            //Layout Employee Team
            employeeTeamLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            employeeTeamLabel.leadingAnchor.constraint(equalTo: employeeNameLabel.leadingAnchor),
            employeeTeamLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
        
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
    }
    
}
