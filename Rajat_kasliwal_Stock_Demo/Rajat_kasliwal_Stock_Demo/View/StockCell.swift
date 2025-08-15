//
//  StockCell.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//


import UIKit

class StockCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()

    private let ltpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    private let ltpLabelValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private let qtyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    private let qtyLabelValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()

    private let pnlLabelValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    func changepnlLabelColor(to color: UIColor) {
        pnlLabelValue.textColor = color
    }
    
    private let topRow = UIStackView()
    private let bottomRow = UIStackView()
    private let mainStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure stack views
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.distribution = .fill
        topRow.addArrangedSubview(nameLabel)
        topRow.addArrangedSubview(UIView()) // spacer
        topRow.addArrangedSubview(ltpLabel)
        topRow.addArrangedSubview(ltpLabelValue)
        

        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        bottomRow.distribution = .fill
        bottomRow.addArrangedSubview(qtyLabel)
        bottomRow.addArrangedSubview(qtyLabelValue)
        bottomRow.addArrangedSubview(UIView()) // spacer
        bottomRow.addArrangedSubview(pnlLabel)
        bottomRow.addArrangedSubview(pnlLabelValue)

        
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(topRow)
        mainStack.addArrangedSubview(bottomRow)

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(stockName: String, ltp: String, qty: String, pnl: String) {
        nameLabel.text = stockName
        ltpLabel.text = "LTP: "
        ltpLabelValue.text = "\(ltp)"
        qtyLabel.text = "NET QTY: "
        qtyLabelValue.text = "\(qty)"
        pnlLabel.text = "P&L: "
        pnlLabelValue.text = "\(pnl)"

        if let pnlValue = Double(pnl.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "")) {
            pnlLabelValue.textColor = pnlValue < 0 ? .red : .systemGreen
        }
    }
}
