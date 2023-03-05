//
//  FeedbackService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 05.03.2023.
//

import UIKit

final class FeedbackService {

    enum FeedbackEvent {
        case notificationSuccess
        case notificationWarning
        case notificationError
        case selectionChanged
        case impactOccured
    }

    static let shared = FeedbackService()

    private init() {}

    /// Performs a taptic feedback
    /// - Parameter event: required type of ``FeedbackEvent``
    func makeFeedback(event: FeedbackEvent) {
        switch event {
        case .notificationSuccess:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .notificationWarning:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        case .notificationError:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        case .selectionChanged:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        default:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

