// The Swift Programming Language
// https://docs.swift.org/swift-book
import Combine

@propertyWrapper
public class CanSubscribe<Value> {
    private let subject: CurrentValueSubject<Value, Never>
    public private(set) var subscriberCount = 0
    
    public var wrappedValue: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }
    public var projectedValue: CanSubscribe<Value> { self }
    public lazy var publisher: AnyPublisher<Value, Never> = {
        subject
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.subscriberCount += 1
                },
                receiveCompletion: { [weak self] _ in
                    guard let self = self else { return }
                    self.subscriberCount = max(0, self.subscriberCount - 1)
                },
                receiveCancel: { [weak self] in
                    guard let self = self else { return }
                    self.subscriberCount = max(0, self.subscriberCount - 1)
                }
            )
            .eraseToAnyPublisher()
    }()
    
    public init(wrappedValue initial: Value) {
        subject = .init(initial)
    }
}
import Combine

@propertyWrapper
public final class CanSubscribeWithError<Value, Failure: Error> {
    private let subject: CurrentValueSubject<Value, Failure>
    public private(set) var subscriberCount = 0

    public var wrappedValue: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }

    public var projectedValue: CanSubscribeWithError<Value, Failure> { self }

    public lazy var publisher: AnyPublisher<Value, Failure> = {
        subject
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.subscriberCount += 1
                },
                receiveCompletion: { [weak self] _ in
                    guard let self = self else { return }
                    self.subscriberCount = max(0, self.subscriberCount - 1)
                },
                receiveCancel: { [weak self] in
                    guard let self = self else { return }
                    self.subscriberCount = max(0, self.subscriberCount - 1)
                }
            )
            .eraseToAnyPublisher()
    }()

    public init(wrappedValue initial: Value) {
        subject = .init(initial)
    }

    public func sendError(_ error: Failure) {
        subject.send(completion: .failure(error))
    }

    public func sendFinished() {
        subject.send(completion: .finished)
    }
}
