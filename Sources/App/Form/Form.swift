import Vapor
import Fluent

protocol Form: Encodable {
    associatedtype Model: Fluent.Model
    
    var id: String? { get set }
    
    init()
    
    init(req: Request) throws
    
    func read(from model: Model)
    func write(to model: Model)
    func validate(req: Request) -> EventLoopFuture<Bool>
}
