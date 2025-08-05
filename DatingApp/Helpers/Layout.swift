//
//  Exstensions.swift
//  DatingApp
//
//  Created by Universe on 28/7/25.
//

import UIKit

extension UIView {

    func fillInSuperView() {
            guard let superview = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
    
    func fillSuperViewWithConstants(
            top: NSLayoutYAxisAnchor? = nil,
            leading: NSLayoutXAxisAnchor? = nil,
            trailing: NSLayoutXAxisAnchor? = nil,
            bottom: NSLayoutYAxisAnchor? = nil,
            topConstant: CGFloat = 0,
            leadingConstant: CGFloat = 0,
            trailingConstant: CGFloat = 0,
            bottomConstant: CGFloat = 0
        ) {
            guard superview != nil else {
                print("No superview found.")
                return
            }

            translatesAutoresizingMaskIntoConstraints = false
            var constraints: [NSLayoutConstraint] = []

            if let top = top {
                constraints.append(topAnchor.constraint(equalTo: top, constant: topConstant))
            }
            if let leading = leading {
                constraints.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
            }
            if let trailing = trailing {
                constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
            }
            if let bottom = bottom {
                constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
            }

            NSLayoutConstraint.activate(constraints)
        }
    
    
    func anchors(top: NSLayoutYAxisAnchor? = nil,
                         topConstant: CGFloat = 0,
                         leading: NSLayoutXAxisAnchor? = nil,
                         leadingConstant: CGFloat = 0,
                         trailing: NSLayoutXAxisAnchor? = nil,
                         trailingConstant: CGFloat = 0,
                         bottom: NSLayoutYAxisAnchor? = nil,
                         bottomConstant: CGFloat = 0) {
            
               translatesAutoresizingMaskIntoConstraints = false
               
               if let top = top {
                   topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
               }
               if let leading = leading {
                   leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
               }
               if let trailing = trailing {
                   trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant).isActive = true
               }
               if let bottom = bottom {
                   bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
               }
           }
    
    func horizontalInSuperView() {
            guard let superview = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
        
    func verticalInSuperView() {
            guard let superview = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
    
    func horizontalInSuperViewWithConstant(leading: CGFloat, trailing: CGFloat) {
            guard let superview = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing)
            ])
        }
    
    func verticalInSuperViewWithConstant(top: CGFloat, bottom: CGFloat) {
            guard let superview = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom)
            ])
        }
    
    func centerInSuperView() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func centerXInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }
    
    func centerYInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func centerInSuperViewWithSize(size: CGSize) {
        guard let superview = superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
}
