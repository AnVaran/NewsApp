//
//  TopAlignTextInLabel.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

class TopAlignedLabel: UILabel {
   override func drawText(in rect: CGRect) {
       if let stringText = text {
           let stringTextAsNSString = stringText as NSString
           let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                           options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                           attributes: [NSAttributedString.Key.font: font as Any],
                                                                           context: nil).size
           super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
       } else {
           super.drawText(in: rect)
       }
   }
   override func prepareForInterfaceBuilder() {
       super.prepareForInterfaceBuilder()
       layer.borderWidth = 1
       layer.borderColor = UIColor.black.cgColor
   }
}
