//
//  SaveImageToDeviceService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import SwiftUI
import UIKit

class SaveImageToDeviceService {
    func save(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
