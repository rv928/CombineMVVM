//
//  CarListViewController.swift
//  Cars
//
//  Created by Ravi Vora on 25/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import Combine

class CarListViewController: UIViewController {
    
    @IBOutlet weak var carListTableView: UITableView!
    private var bindings = Set<AnyCancellable>()
    private var viewModel = CarListViewModel()
    
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil:
        Bundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(viewModel: CarListViewModel = CarListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setUpCarListTableView()
        setUpBindings()
    }
    
    override func viewDidLayoutSubviews() {
        self.carListTableView.frame = view.bounds
    }
    
    /*
     * This method will setup NavigationBar
     */
    func setupNavigationBar() {
        self.navigationItem.title = "Cars"
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                    .font: UIFont.SFUI(.medium, size: 17.0)]
            navBarAppearance.backgroundColor = UIColor().black25A
            navBarAppearance.shadowColor = nil
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor().black25
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.SFUI(.medium, size: 17.0)]
        }
    }
    
    func setupUI() {
        self.carListTableView.rowHeight = UITableView.automaticDimension
        self.carListTableView.estimatedRowHeight = 100
        self.carListTableView.isHidden = true
    }
    
    func setUpCarListTableView() {
        self.carListTableView.separatorInset = .zero
        self.carListTableView.layoutMargins = .zero
        self.carListTableView.contentInsetAdjustmentBehavior = .never
        self.carListTableView.tableFooterView = UIView(frame: .zero)
        
        self.carListTableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: "CarCell")
        self.carListTableView.accessibilityIdentifier = "tableView--carListTableView"
    }
    
    private func setUpBindings() {
        
        func bindViewModelToView() {
            let viewModelsValueHandler: ([CarCellViewModel]) -> Void = { [weak self] _ in
                self?.carListTableView.reloadData()
                self?.carListTableView.dataSource = self
            }
            
            viewModel.$carsViewModels
                .receive(on: RunLoop.main)
                .sink(receiveValue: viewModelsValueHandler)
                .store(in: &bindings)
            
            let stateValueHandler: (CarListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.startLoading()
                case .finishedLoading:
                    self?.finishLoading()
                case .error(let error):
                    self?.finishLoading()
                    self?.showAlertError(error: error.localizedDescription)
                }
            }
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }
        bindViewModelToView()
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            Tools.shared.showProgressHUD()
        }
        self.carListTableView.isHidden = true
    }
    
    func finishLoading() {
        Tools.shared.hideProgressHUD()
        self.carListTableView.isHidden = false
    }
    
    func showAlertError(error: String?) {
        if error == nil {
            presentAlert(withTitle: APP_NAME, message: SERVER_ERROR)
        } else {
            presentAlert(withTitle: APP_NAME, message: error!)
        }
    }
}

extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.carsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
        dequeuedCell.accessibilityIdentifier = "CarCell\(indexPath.row)"
        guard let carCell = dequeuedCell as? CarCell else {
            fatalError("Could not dequeue a cell")
        }
        carCell.viewModel = viewModel.carsViewModels[indexPath.row]
        return carCell
    }
}
