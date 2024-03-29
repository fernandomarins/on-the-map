//
//  TableViewController.swift
//  On The Map
//
//  Created by Fernando Marins on 02/12/21.
//

import UIKit
import SnapKit

final class TableViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let cellId = "cellID"
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        addViews()
        addConstraints()
        setupBarButtons()
        getData()
        addNotification()
    }
    
    private func addViews() {
        view.addSubview(contentView)
        contentView.addSubview(tableView)
    }
    
    private func addConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private methods
    
    private func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddLocationView))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    @objc private func refresh() {
        getData()
    }
    
    @objc private func logout() {
        interactor.logout()
    }
    
    @objc private func presentAddLocationView() {
        interactor.presentAddLocation()
    }
    
    private func getData() {
        interactor.getAllLocations { [weak self] sucess in
            if sucess != nil {
                self?.reloadTableView()
            }
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: Notification.Name("update"),
                                               object: nil)
    }
    
    // MARK: - TableView delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentList.allStudents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if StudentList.allStudents[indexPath.row].mediaURL == "" || StudentList.allStudents[indexPath.row].mediaURL == nil  {
            return 60
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.locationLabel.text = StudentList.allStudents[indexPath.row].firstName
        cell.linkLabel.text = StudentList.allStudents[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let toOpen = StudentList.allStudents[indexPath.row].mediaURL {
            guard UIApplication.shared.canOpenURL(URL(string: toOpen) ?? URL(fileURLWithPath: "")) else {
                showAlert(self, "The link is not valid")
                return
            }
            interactor.openLink(toOpen)
        }
    }
}
