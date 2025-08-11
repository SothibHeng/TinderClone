//
//  AgeRangeCell.swift
//  DatingApp
//
//  Created by Universe on 11/8/25.
//

import UIKit

class AgeRangeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return .init(width: 80, height: 0)
    }
}

class AgeRangeCell: UITableViewCell {
    
    let minSliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minSliderLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min: 18"
        return label
    }()
    
    let maxSliderLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max: 100"
        return label
    }()
    
    let verticalPadding: CGFloat = 16
    let horizontalPadding: CGFloat = 24
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        let minStackView = UIStackView(arrangedSubviews: [
            minSliderLabel, minSliderView
        ])
        
        let maxStackView = UIStackView(arrangedSubviews: [
            maxSliderLabel, maxSliderView
        ])
    
        let overallStatckView = UIStackView(arrangedSubviews: [
            minStackView, maxStackView
        ], spacing: 16)
        
        contentView.addSubview(overallStatckView)
        overallStatckView.anchors(
            top: contentView.topAnchor,
            topConstant: verticalPadding,
            leading: contentView.leadingAnchor,
            leadingConstant: horizontalPadding,
            trailing: contentView.trailingAnchor,
            trailingConstant: horizontalPadding,
            bottom: contentView.bottomAnchor,
            bottomConstant: verticalPadding
        )

        
        overallStatckView.axis = .vertical
        overallStatckView.distribution = .fillEqually
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
