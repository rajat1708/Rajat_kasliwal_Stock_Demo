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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupExpandableView()
        setupTableView()
        viewModel = StocksViewModel(delegate: self)
        viewModel?.fetchStockList()
        tableView.isHidden = true
    }
    
    private func setupExpandableView() {
        expandableView.delegate = self
        expandableView.backgroundColor = .systemGray6
        view.addSubview(expandableView)
        
        NSLayoutConstraint.activate([
            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        updateExpandableViewContent()
    }
    
    private func updateExpandableViewContent() {
        guard let viewModel = viewModel else { return }
        expandableView.setDetails([
            ("Current value*", viewModel.currentValue(), .black),
            ("Total investment*", viewModel.totalInvestment() , .black),
            ("Today’s Profit & Loss*", viewModel.todayChange() , viewModel.todayChangeColor()),
            ("Profit & Loss*", viewModel.totalPnL() , viewModel.totalPnLColour())
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
        }
    }
}
