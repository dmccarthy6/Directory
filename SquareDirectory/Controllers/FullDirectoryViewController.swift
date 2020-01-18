
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200//UITableView.automaticDimension
        
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
    private var employeeData = [Contact]()
    private let directoryAPI = GetDirectoryData()
    private let imageAPI = FetchImages()
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //Perform API Request
        performDirectoryRequest()
    }
    
    
    //MARK: - Helpers
    private func setupView() {
        view.addSubview(activityIndicator())
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        navigationItem.title = "Employee Directory"
    }
    
    //Create activity indicator
    private func activityIndicator() -> UIActivityIndicatorView {
        let indicator = ActivityIndicator.displayActivityIndicator(with: view.centerXAnchor,
                                                                   yAnchor: view.centerYAnchor,
                                                                   inView: view)
        indicator.backgroundColor = .darkGray
        return indicator
    }
   
    //Perform Fetch of employees from directory
    private func performDirectoryRequest() {
        activityIndicator().startAnimating()
        directoryAPI.fetchDirectoryNames(from: .validData) { [unowned self] (result) in
            switch result {
            case .success(let contact):
                guard let contactResults = contact else { return }
                self.handleNoDataErrorLabel(data: contactResults.employees)
                self.employeeData = self.sortedDataByTeam(directoryEmployees: contactResults)
                self.activityIndicator().stopAnimating()
                self.tableView.reloadData()
                
            case .failure(let error):
                /* Showing Error Label Here, if Data isn't fetched label shows on UI*/
                self.activityIndicator().stopAnimating()
                self.handleErrorFetchingLabel()
                print(error)
            }
        }
    }
    
    //Sort data by team
    func sortedDataByTeam(directoryEmployees: EmployeesResult) -> [Contact] {
        guard let employeeDataArray = directoryEmployees.employees else { return employeeData }
        let sortedEmployeeArray = employeeDataArray.sorted(by: { $0.team < $1.team })
        return sortedEmployeeArray
    }
    
    //Handle Error Labels
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
        return employeeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PersonCell = tableView.dequeueReusableCell(for: indexPath)
        
        let data = employeeData[indexPath.row]
        
        //TO-DO: Is this the right place for this image async call? This feels expensive and like there's a better place for it, but where?
        imageAPI.getImage(from: data.photoSmall) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    Alerts.showAlert(title: "Error", message: "Error fetching thumbnail image \(error)")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    cell.setImage(image)
                }
            }
        }
        
        cell.configure(employeeName: data.fullName, employeeTeam: data.team)
        return cell
    }
    
}

//MARK: - UITableView Delegate Methods
extension FullDirectoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
