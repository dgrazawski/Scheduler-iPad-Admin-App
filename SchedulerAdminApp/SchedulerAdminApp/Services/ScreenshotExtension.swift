//
//  ScreenshotExtension.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func screenShot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let size = controller.view.intrinsicContentSize
        view!.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        view!.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        controller.view.layoutIfNeeded()
        return renderer.image { _ in
            view!.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
