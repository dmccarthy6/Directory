
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import UIKit

final class FullDirectoryViewController: UIViewController {
    
    //MARK: - Properties
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerTableViewCell(cellClass: PersonCell.self)
        return tableView
    }()
    lazy private var errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.numberOfLines = 0
        label.backgroundColor = .secondarySystemBackground
        label.font = .preferredFont(for: .body, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    let modelController = ModelController()
    let imageLoader = ImageLoader()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //Perform API Request
        makeNetworkCall()
    }
    
    
    //MARK: - Helpers
    private func setupView() {
        view.addSubview(activityIndicator())
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        navigationItem.title = "Employee Directory"
    }
    
    func makeNetworkCall() {
        activityIndicator().startAnimating()
        modelController.getNetowrkData { [unowned self] (error) in
            if let apiError = error {
                if apiError == .httpRequestFailed {
                    Alerts.showAlert(title: "Http Error", message: "Check your internet connection. Could not connect to server")
                }
                else {
                    self.handleErrorFetchingLabel()
                    Alerts.showAlert(title: "JSON Error", message: "JSON data is corrupted. Please try again.")
                }
            }
            if self.modelController.directoryData.count < 1 {
                self.handleNoDataErrorLabel(data: self.modelController.directoryData)
            }
            self.tableView.reloadData()
        }
        activityIndicator().stopAnimating()
    }
    
    //MARK - UI Methods
    //Create activity indicator
    private func activityIndicator() -> UIActivityIndicatorView {
        let indicator = ActivityIndicator.displayActivityIndicator(with: view.centerXAnchor, yAnchor: view.centerYAnchor, inView: view)
        return indicator
    }
    //Handle No Data OR Malformed data error labels.
    private func handleNoDataErrorLabel(data: [Contact]?) {
        if let contactData = data {
            if contactData.count == 0 {
                self.errorLabel.text = ErrorLabelText.noData.text
                self.errorLabel.isHidden = false
            }
        }
    }
    
    private func handleErrorFetchingLabel() {
        self.errorLabel.text = ErrorLabelText.errorFetchingData.text
        self.errorLabel.isHidden = false
    }
}

//MARK: - UITableView Data Source Methods
extension FullDirectoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.directoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PersonCell = tableView.dequeueReusableCell(for: indexPath)
        
        let data = modelController.directoryData[indexPath.row]
        let thumbnailImageURL = data.photoSmall
        
        cell.configure(employeeName: data.fullName, employeeTeam: data.team)

        let token = modelController.loadImageFor(cell: cell, url: thumbnailImageURL, uuid: data.uuid) { (apiError) in
            DispatchQueue.main.async {
                Alerts.showAlert(title: "Image Alert", message: "Error loading images: \(APIError.imageFailedToLoad)")
            }
        }
        cell.onReuse = {
            if let token = token {
                self.imageLoader.cancelLoad(for: token, uuid: data.uuid)
            }
        }
        return cell
    }
    
}

//MARK: - UITableView Delegate Methods
extension FullDirectoryViewController: UITableViewDelegate {
    
    
    
}
