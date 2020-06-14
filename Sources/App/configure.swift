import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver
import FluentPostgresDriver


public func configure(_ app: Application) throws {

    //app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    try app.databases.use(.postgres(url: Environment.pgUrl), as: .psql)
    
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.routes.defaultMaxBodySize = "10mb"
    app.fileStorages.use(.local(
        publicUrl: "http://localhost:8080",
        publicPath: app.directory.publicDirectory,
        workDirectory: "assets"), as: .local)

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    let workingDirectory = app.directory.workingDirectory
    app.leaf.configuration.rootDirectory = "/"
    app.leaf.files = ModularViewFiles(workingDirectory: workingDirectory, fileio: app.fileio)

    
    app.sessions.use(.fluent)
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(app.sessions.middleware)
    
    
    let modules: [Module] = [
        FrontendModule(),
        AdminModule(),
        BlogModule(),
        UserModule(),
        UtilityModule(),
    ]
    
    for module in modules {
        try module.configure(app)
    }
}

extension Environment {
    static let pgUrl = URL(string: Self.get("PSQL_CRED")!)!
}
