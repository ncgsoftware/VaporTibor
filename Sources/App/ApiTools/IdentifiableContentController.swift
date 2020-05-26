
import Vapor
import Fluent


protocol IdentifiableContentCeontroller: ContentController {
    
    var idParamKey: String { get }
    var idPathComponent: PathComponent { get }
    
    func find( _ req: Request) throws -> EventLoopFuture<Model>
}


extension IdentifiableContentCeontroller {
    var idParamKey: String { "id" }
    var idPathComponent: PathComponent { .init(stringLiteral: ":" + self.idParamKey) }
}


extension IdentifiableContentCeontroller where Model.IDValue == UUID {
    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let rawValue = req.parameters.get(self.idParamKey),
            let id = UUID(uuidString: rawValue)
        else {
            throw Abort(.badRequest)
        }
        
        return Model.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
}
