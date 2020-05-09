import Vapor

struct BlogRouter : RouteCollection {
    let controller = BlogFrontEndController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("blog", use: self.controller.blogView)
        routes.get(.anything, use: self.controller.postView)
    }
}
