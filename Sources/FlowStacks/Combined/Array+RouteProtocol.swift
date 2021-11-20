import Foundation

public extension Array where Element: RouteProtocol {
  
  /// Pushes a new screen via a push navigation.
  /// This should only be called if the most recently presented screen is embedded in a `NavigationView`.
  /// - Parameter screen: The screen to push.
  mutating func push(_ screen: Element.Screen) {
    append(.push(screen))
  }
  
  /// Presents a new screen via a sheet presentation.
  /// - Parameter screen: The screen to push.
  mutating func presentSheet(_ screen: Element.Screen, embedInNavigationView: Bool = false) {
    append(.sheet(screen, embedInNavigationView: embedInNavigationView))
  }
  
  /// Presents a new screen via a full-screen cover presentation.
  /// - Parameter screen: The screen to push.
  mutating func presentCover(_ screen: Element.Screen, embedInNavigationView: Bool = false) {
    append(.cover(screen, embedInNavigationView: embedInNavigationView))
  }
}

// MARK: - Go back

public extension Array where Element: RouteProtocol {
  
  /// Goes back a given number of screens off the stack
  /// - Parameter count: The number of screens to go back. Defaults to 1.
  mutating func goBack(count: Int = 1) {
    self = dropLast(count)
  }
  
  /// Goes back to a given index in the array of screens. The resulting screen count
  /// will be index + 1.
  /// - Parameter index: The index that should become top of the stack.
  mutating func goBackTo(index: Int) {
    self = Array(prefix(index + 1))
  }
  
  /// Goes back to the root screen (index 0). The resulting screen count
  /// will be 1.
  mutating func goBackToRoot() {
    goBackTo(index: 0)
  }
  
  /// Goes back to the topmost (most recently shown) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged.
  /// - Parameter condition: The predicate indicating which screen to go back to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func goBackTo(where condition: (Element) -> Bool) -> Bool {
    guard let index = lastIndex(where: condition) else {
      return false
    }
    goBackTo(index: index)
    return true
  }
  
  /// Goes back to the topmost (most recently shown) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged.
  /// - Parameter condition: The predicate indicating which screen to go back to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func goBackTo(where condition: (Element.Screen) -> Bool) -> Bool {
    return goBackTo(where: { condition($0.screen) })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen: Equatable {
  
  /// Goes back to the topmost (most recently shown) screen in the stack
  /// equal to the given screen. If no screens are found,
  /// the screens array will be unchanged.
  /// - Parameter screen: The predicate indicating which screen to go back to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func goBackTo(_ screen: Element.Screen) -> Bool {
    goBackTo(where: { $0 == screen })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen:  Identifiable {
  
  /// Goes back to the topmost (most recently shown) identifiable screen in the stack
  /// with the given ID. If no screens are found, the screens array will be unchanged.
  /// - Parameter id: The id of the screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func goBackTo(id: Element.Screen.ID) -> Bool {
    goBackTo(where: { $0.id == id })
  }
  
  /// Goes back to the topmost (most recently shown) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged.
  /// - Parameter screen: The screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func goBackTo(_ screen: Element.Screen) -> Bool {
    goBackTo(id: screen.id)
  }
}

/// Avoids an ambiguity when `Screen` is both `Identifiable` and `Equatable`.
public extension Array where Element: RouteProtocol, Element.Screen: Identifiable & Equatable {
  
  /// Goes back to the topmost (most recently shown) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged.
  /// - Parameter screen: The screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func goBackTo(_ screen: Element.Screen) -> Bool {
    goBackTo(id: screen.id)
  }
}

// MARK: - Pop

public extension Array where Element: RouteProtocol {
  
  /// Pops a given number of screens off the stack. Only screens that have been pushed will
  /// be popped.
  /// - Parameter count: The number of screens to go back. Defaults to 1.
  mutating func pop(count: Int = 1) {
    assert(self.suffix(count).allSatisfy({ !$0.isPresented }))
    self = dropLast(count)
  }
  
  /// Pops to a given index in the array of screens. The resulting screen count
  /// will be index + 1. Only screens that have been pushed will
  /// be popped.
  /// - Parameter index: The index that should become top of the stack.
  mutating func popTo(index: Int) {
    let popCount = count - (index + 1)
    pop(count: popCount)
  }
  
  /// Pops to the root screen (index 0). The resulting screen count
  /// will be 1. Only screens that have been pushed will
  /// be popped.
  mutating func popToRoot() {
    popTo(index: 0)
  }
  
  /// Pops to the topmost (most recently pushed) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged. Only screens that have been pushed will
  /// be popped.
  /// - Parameter condition: The predicate indicating which screen to pop to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func popTo(where condition: (Element) -> Bool) -> Bool {
    guard let index = lastIndex(where: condition) else {
      return false
    }
    popTo(index: index)
    return true
  }
  
  /// Pops to the topmost (most recently pushed) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged. Only screens that have been pushed will
  /// be popped.
  /// - Parameter condition: The predicate indicating which screen to pop to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func popTo(where condition: (Element.Screen) -> Bool) -> Bool {
    return popTo(where: { condition($0.screen) })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen: Equatable {
  
  /// Pops to the topmost (most recently pushed) screen in the stack
  /// equal to the given screen. If no screens are found,
  /// the screens array will be unchanged. Only screens that have been pushed will
  /// be popped.
  /// - Parameter screen: The predicate indicating which screen to go back to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func popTo(_ screen: Element.Screen) -> Bool {
    popTo(where: { $0 == screen })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen:  Identifiable {
  
  /// Pops to the topmost (most recently pushed) identifiable screen in the stack
  /// with the given ID. If no screens are found, the screens array will be unchanged.
  /// Only screens that have been pushed will
  /// be popped.
  /// - Parameter id: The id of the screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func popTo(id: Element.Screen.ID) -> Bool {
    popTo(where: { $0.id == id })
  }
  
  /// Pops to the topmost (most recently pushed) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged. Only screens that have been pushed will
  /// be popped.
  /// - Parameter screen: The screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func popTo(_ screen: Element.Screen) -> Bool {
    popTo(id: screen.id)
  }
}

/// Avoids an ambiguity when `Screen` is both `Identifiable` and `Equatable`.
public extension Array where Element: RouteProtocol, Element.Screen: Identifiable & Equatable {
  
  /// Pops to the topmost (most recently pushed) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged. Only screens that have been pushed will
  /// be popped.
  /// - Parameter screen: The screen to pop to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func popTo(_ screen: Element.Screen) -> Bool {
    popTo(id: screen.id)
  }
}

// MARK: - Dismiss

public extension Array where Element: RouteProtocol {
  
  /// Dismisses a given number of screens off the stack. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter count: The number of screens to go back. Defaults to 1.
  mutating func dismiss(count: Int = 1) {
    assert(self.suffix(count).allSatisfy({ $0.isPresented }))
    self = dropLast(count)
  }
  
  /// Dismisses to a given index in the array of screens. The resulting screen count
  /// will be index + 1. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter index: The index that should become top of the stack.
  mutating func dismissTo(index: Int) {
    let dismissCount = count - (index + 1)
    dismiss(count: dismissCount)
  }
  
  /// Dismisses to the root screen (index 0). The resulting screen count
  /// will be 1. Only screens that have been presented will
  /// be dismissed.
  mutating func dismissToRoot() {
    dismissTo(index: 0)
  }
  
  /// Dismisses to the topmost (most recently presented) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter condition: The predicate indicating which screen to dismiss to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func dismissTo(where condition: (Element) -> Bool) -> Bool {
    guard let index = lastIndex(where: condition) else {
      return false
    }
    dismissTo(index: index)
    return true
  }
  
  /// Dismisses to the topmost (most recently presented) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter condition: The predicate indicating which screen to dismiss to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  mutating func dismissTo(where condition: (Element.Screen) -> Bool) -> Bool {
    return dismissTo(where: { condition($0.screen) })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen: Equatable {
  
  /// Dismisses to the topmost (most recently presented) screen in the stack
  /// equal to the given screen. If no screens are found,
  /// the screens array will be unchanged. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter screen: The predicate indicating which screen to go back to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func dismissTo(_ screen: Element.Screen) -> Bool {
    dismissTo(where: { $0 == screen })
  }
}

public extension Array where Element: RouteProtocol, Element.Screen:  Identifiable {
  
  /// Dismisses to the topmost (most recently presented) identifiable screen in the stack
  /// with the given ID. If no screens are found, the screens array will be unchanged.
  /// Only screens that have been presented will
  /// be dismissed.
  /// - Parameter id: The id of the screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func dismissTo(id: Element.Screen.ID) -> Bool {
    dismissTo(where: { $0.id == id })
  }
  
  /// Dismisses to the topmost (most recently presented) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter screen: The screen to goBack to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func dismissTo(_ screen: Element.Screen) -> Bool {
    dismissTo(id: screen.id)
  }
}

/// Avoids an ambiguity when `Screen` is both `Identifiable` and `Equatable`.
public extension Array where Element: RouteProtocol, Element.Screen: Identifiable & Equatable {
  
  /// Dismisses to the topmost (most recently presented) identifiable screen in the stack
  /// matching the given screen. If no screens are found, the screens array
  /// will be unchanged. Only screens that have been presented will
  /// be dismissed.
  /// - Parameter screen: The screen to dismiss to.
  /// - Returns: A `Bool` indicating whether a matching screen was found.
  @discardableResult
  mutating func dismissTo(_ screen: Element.Screen) -> Bool {
    dismissTo(id: screen.id)
  }
}