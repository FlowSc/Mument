//
//  UIView_extension.swift
//  Mytom
//
//  Created by TJ Enjoy on 2018. 7. 23..
//  Copyright © 2018년 TJ Enjoy. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    
    func setBorder(color:UIColor, width:CGFloat, cornerRadius:CGFloat = 0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
    }
    
    func addUnderBar() {
        
        let underBar = UIView()
        underBar.backgroundColor = .black
        
        self.addSubview(underBar)
        underBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(4)
            make.height.equalTo(2)
        }
        
        
    }
    
    func addSubview(_ views:[UIView]) {
        
        for v in views {
            
            self.addSubview(v)
            
        }
    }
    
    func rotatedBy(_ rotate: CGFloat) {
        var transform = self.transform
        transform = transform.rotated(by: rotate)
        self.transform = transform
    }
    
    func scaledBy(_ scale: CGFloat) {
        var transform: CGAffineTransform = self.transform
        transform = transform.scaledBy(x: 1, y: scale)
        self.transform = transform
    }
    
    
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func shadow() {
        
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.init(width: 5, height: 5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 7.0
        layer.masksToBounds =  false
        
    }
    
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
    func addSubviewsAtOnce(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func setLayersInSuperView(itemSet: ([AnyObject], CGFloat)...) {
        for item in itemSet {
            for i in item.0 {
                i.layer.zPosition = item.1
            }
        }
    }

        
    var safeArea: ConstraintBasicAttributesDSL {
        
        #if swift(>=3.2)
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
            
        }
        return self.snp
        #else
        return self.snp
        #endif
    }
    
    
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

}


open class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map { $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath)! : $0 }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
            let collectionView = self.collectionView else {
                // should never happen
                return nil
        }
        
        let sectionInset = evaluatedSectionInsetForSection(at: indexPath.section)
        
        guard indexPath.item != 0 else {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        guard let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame else {
            // should never happen
            return nil
        }
        
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        guard previousFrame.intersects(CGRect(x: sectionInset.left, y: currentItemAttributes.frame.origin.y, width: collectionView.frame.width - sectionInset.left - sectionInset.right, height: currentItemAttributes.frame.size.height)) else {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, insetForSectionAt: index) ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIFont {
    
    static func NotoSans(_ font:NotoSansFontSize, size:CGFloat) -> UIFont {
        
        print(font.rawValue)
        print("~~~")
  
        return UIFont.init(name: font.rawValue, size: size)!
        
    }
    
    static func AmericanTypeWriter(_ weight:AmericanTypeWriterFontSize, size:CGFloat) -> UIFont {
        
        return UIFont.init(name: weight.rawValue, size: size)!
    }
}



class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        // Constants
        let leftPadding: CGFloat = 8
        let interItemSpacing = minimumInteritemSpacing
        
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                
                currentRow += 1
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}

enum NotoSansFontSize:String {
    
    case bold = "NotoSans-Bold"
    case regular = "NotoSans-Regular"
    case medium = "NotoSans-Medium"
    case thin = "NotoSans-Light"
    
}

enum AmericanTypeWriterFontSize:String {
    
    case bold = "AmericanTypewriter-Bold"
    case regular = "AmericanTypewriter"
    case light = "AmericanTypewriter-Light"
    
}
