//
//  AvatarGroupView.swift
//  AvatarGroup
//
//  Created by Meng Li on 2019/05/23.
//  Copyright © 2018 XFLAG. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit

open class AvatarGroupView: UIView {
    
    public enum Alignment {
        case left
        case right
        case center
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.alignment = .center
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var containerViews: [UIView] = []
    
    private lazy var imageViews: [UIImageView] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        addSubview(stackView)
    }
    
    private func createConstraints() {
        stackView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            if reverse {
                $0.trailing.equalToSuperview()
            } else {
                $0.leading.equalToSuperview()
            }
        }
    }
    
    private var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(scaleX: reverse ? -1 : 1, y: 1)
    }
    
    @IBInspectable
    public var spacing: CGFloat = 0 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    @IBInspectable
    public var reverse: Bool = false {
        didSet {
            transform = cgAffineTransform
            containerViews.forEach { $0.transform = cgAffineTransform }
            createConstraints()
        }
    }

    public var count: Int {
        return containerViews.count
    }
    
    public func add(image: UIImage?) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.layer.cornerRadius = 23
        imageView.layer.masksToBounds = true
        imageViews.append(imageView)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.addSubview(imageView)
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true
        containerView.transform = cgAffineTransform
        containerViews.append(containerView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.addArrangedSubview(containerView)
    }

    public func remove(at index: Int) {
        guard 0...index ~= index else {
            return
        }
        stackView.removeArrangedSubview(containerViews[index])
        containerViews.remove(at: index)
        imageViews.remove(at: index)
    }
    
}
