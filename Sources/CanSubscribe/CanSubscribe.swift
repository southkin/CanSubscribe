// The Swift Programming Language
// https://docs.swift.org/swift-book
import Combine

@propertyWrapper
public class CanSubscribe<Value> {
    private let subject: CurrentValueSubject<Value, Never>
    
    public var wrappedValue: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }
    
    public var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }
    
    public init(wrappedValue initial: Value) {
        subject = .init(initial)
    }
}
