//
//  ViewController.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//


import UIKit

class ViewController: UIViewController, UITableViewDataSource, ExpandableViewDelegate {
    private let tableView = UITableView()
    private let expandableView = ExpandableView()
    private var viewModel: StocksViewModel?
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
//        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        setupExpandableView()
        setupTableView()
        viewModel = StocksViewModel(delegate: self)
        viewModel?.fetchStockList()
        tableView.isHidden = true
    }
    
    private func setupExpandableView() {
        expandableView.delegate = self
        view.addSubview(expandableView)
        
        NSLayoutConstraint.activate([
            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        updateExpandableViewContent()
    }

    private func updateExpandableViewContent() {
        expandableView.setDetails([
            ("Current value*", "\(viewModel?.currentValue() ?? 0.0)", .black),
            ("Total investment*", "\(viewModel?.totalInvestment() ?? 0.0)", .black),
            ("Today’s Profit & Loss*", "\(viewModel?.todayChange() ?? 0.0)", viewModel?.todayChangeColor() ?? .black),
            ("Profit & Loss*", "\(viewModel?.totalPnL() ?? 0.0)", viewModel?.totalPnLColour() ?? .black)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: expandableView.topAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
    }
    
    
    // MARK: - ExpandableViewDelegate
    func didToggleExpand() {
        viewModel?.toggleExpand()
        UIView.animate(withDuration: 0.3) {
            guard let viewModel = self.viewModel else { return }
            self.expandableView.updateExpandedState(isExpanded: viewModel.isExpanded)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.stockCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell {
            let row = indexPath.row
            
            cell.configure(
                stockName: viewModel.stockNameAtIndex(row),
                ltp: viewModel.stockLTPAtIndex(row),
                qty: viewModel.stockQuantityAtIndex(row),
                pnl: viewModel.stockPnLAtIndex(row).0
            )
            cell.changepnlLabelColor(to: viewModel.stockPnLAtIndex(row).1)
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: StocksViewModelDelegate {
    func didUpdateStocks() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.updateExpandableViewContent()
//            self?.activityIndicator.stopAnimating()
        }
    }
}
