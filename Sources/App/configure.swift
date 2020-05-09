import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

public func configure(_ app: Application) throws {

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease

    let modules: [Module] = [
        FrontendModule(),
        BlogModule(),
    ]
    
    for module in modules {
        try module.configure(app)
    }
}
