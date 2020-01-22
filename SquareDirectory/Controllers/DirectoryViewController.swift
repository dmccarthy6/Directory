
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController {
    
    //MARK: - Properties
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerTableViewCell(cellClass: PersonCell.self)
        return tableView
    }()
    lazy private var errorLabel: UILabel = {
        let label = UILabel(frame: view.frame)
        label.numberOfLines = 0
        label.backgroundColor = .secondarySystemBackground
        label.font = .preferredFont(for: .body, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let modelController = ModelController()
    private var activityView: UIActivityIndicatorView?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupLayout()
        makeDirectoryNetworkCall()
    }
    
    
    //MARK: - Helpers
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        startAnimatingActivityIndicatorView()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        navigationItem.title = "Employee Directory"
    }
    
    private func makeDirectoryNetworkCall() {
        self.modelController.getDirectoryEmployees(from: .validData) { (error) in
            /* Dispatching to main queue since data is passed in from asyncronous source and I'm using data to update the UI so it needs to be on Main Queue. */
            DispatchQueue.main.async {
                if let error = error {
                    if error == .httpRequestFailed {
                        Alerts.showAlert(title: "Error", message: "Failed to connect to server. Check your internet connection and try again.")
                    }
                    else {
                        self.setErrorLabelText(error: .errorFetchingData)
                    }
                }
                if self.modelController.directoryData.count == 0 {
                    self.setErrorLabelText(error: .noData)
                }
                self.stopAnimatingActivityIndicatorView()
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK - UI Methods
    //Creating Activity Indicator
    private func startAnimatingActivityIndicatorView() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = view.center
        activityView?.color = .systemGray
        tableView.addSubview(self.activityView!)
        activityView?.startAnimating()
    }
    
    private func stopAnimatingActivityIndicatorView() {
        if let activityIndicator = activityView {
            activityIndicator.stopAnimating()
        }
    }
    
    /* If there is an 'error' in the network call and the data is malformed, or the data is Nil, this error label method will be called, it unhides the label created above and sets the appropriate text based on the error provided by the API. */
    private func setErrorLabelText(error: ErrorLabelText) {
        switch error {
        case .errorFetchingData:    self.errorLabel.text = error.text
        case .noData:              self.errorLabel.text = error.text
        }
        errorLabel.isHidden = false
    }
}

//MARK: - UITableView Data Source Methods
extension DirectoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.directoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PersonCell = tableView.dequeueReusableCell(for: indexPath)
        let data = modelController.directoryData[indexPath.row]
        let currentEmployeeUUID = data.uuid
        let thumbnailImageURL = data.photoSmall
        
        cell.configure(employeeName: data.fullName, employeeTeam: data.team)
        
        let token = modelController.loadImageFor(url: thumbnailImageURL, uuid: currentEmployeeUUID) { (image, apiError) in
            DispatchQueue.main.async {
                if let image = image {
                    cell.setImage(image)
                }
            }
        }
        
        cell.onReuse = {
            if let token = token {
                self.modelController.cancelImageLoad(token: token, uuid: currentEmployeeUUID)
            }
        }
        return cell
    }
}

//MARK: - UITableView Delegate Methods
extension DirectoryViewController: UITableViewDelegate {
    
}
