//
//  StoryboardInitializable.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

public protocol StoryboardInitializable {
    /// The name of the storyboard resource file without the filename extension.
    static var storyboardName: String { get }
    
    /// The bundle that contains the storyboard file. Default is `nil`.
    static var storyboardBundle: Bundle? { get }
    
    /// An identifier string that uniquely identifies the view controller in the storyboard file.
    static var storyboardIdentifier: String { get }
    
    /// Returns a view controller instance corresponding to the `storyboardIdentifier`.
    static func makeFromStoryboard() -> Self
}

// MARK: - Public (Default implementation)
public extension StoryboardInitializable {
    
    static var storyboardBundle: Bundle? {
        guard let callSiteClass = Self.self as? AnyClass else {
            fatalError()
        }
        
        return Bundle(for: callSiteClass)
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No view controller with identifier `\(storyboardIdentifier)` in storyboard `\(storyboardName)`")
        }
        
        return viewController
    }
}
