//
//  ExpandableView.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//

import UIKit

protocol ExpandableViewDelegate: AnyObject {
    func didToggleExpand()
}


class ExpandableView: UIView {
    
    weak var delegate: ExpandableViewDelegate?
    private var detailsStackView = UIStackView()
    
    let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profit & Loss ▲", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 12
        
        translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(toggleButton)
        addSubview(detailsStackView)
        
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 12
        detailsStackView.isHidden = true
        
        NSLayoutConstraint.activate([
            toggleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            toggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            toggleButton.topAnchor.constraint(equalTo: topAnchor),
            toggleButton.heightAnchor.constraint(equalToConstant: 30),
            
            detailsStackView.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: 10),
            detailsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            detailsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        toggleButton.addTarget(self, action: #selector(togglePressed), for: .touchUpInside)
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(togglePressed))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func togglePressed() {
        delegate?.didToggleExpand()
    }
    
    func updateExpandedState(isExpanded: Bool) {
        detailsStackView.isHidden = !isExpanded
        heightConstraint.constant = isExpanded ? 180 : 30
        toggleButton.setTitle(isExpanded ? "Profit & Loss ▼" : "Profit & Loss ▲ ", for: .normal)
    }
    
    func setDetails(_ details: [(String, String, UIColor)]) {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (label, value, color) in details {
            let titleLabel = UILabel()
            titleLabel.text = label
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.textColor = color
            valueLabel.font = UIFont.systemFont(ofSize: 14)
            
            let rowStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            rowStack.axis = .horizontal
            rowStack.distribution = .equalSpacing
            detailsStackView.addArrangedSubview(rowStack)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
