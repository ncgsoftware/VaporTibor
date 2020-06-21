import Vapor
import Leaf
import Fluent
//import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver
//import LiquidAwsS3Driver
import FluentPostgresDriver
import ViperKit
import ViewKit

public func configure(_ app: Application) throws {

    try app.databases.use(.postgres(url: Environment.pgUrl), as: .psql)
    
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.routes.defaultMaxBodySize = "10mb"
    app.fileStorages.use(.local(
        publicUrl: Environment.appUrl.absoluteString,
        publicPath: app.directory.publicDirectory,
        workDirectory: "assets"), as: .local)

    /* AWS S# Bucket file storage config
    app.fileStorages.use(awsS3(key: Environment.awsKey,
                               secret: Environment.awsSecret,
                               bucket: "vaportestbucket",
                               region: .uswest1), as: .awsS3)
    */
    
    app.views.use(.leaf)
    if !app.environment.isRelease {
        app.leaf.cache.isEnabled = false
        app.leaf.useViperViews()
    }
    
    app.sessions.use(.fluent)
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(app.sessions.middleware)
    
    
    let modules: [ViperModule] = [
        FrontendModule(),
        AdminModule(),
        BlogModule(),
        UserModule(),
        UtilityModule(),
    ]
    
    try app.viper.use(modules)
}

extension Environment {
    static let pgUrl = URL(string: Self.get("PSQL_CRED")!)!
    static let appUrl = URL(string: Self.get("APP_URL")!)!
    static let awsKey = Self.get("AWS_KEY")!
    static let awsSecret = Self.get("AWS_SECRET")!
}

protocol ViperAdminViewController: AdminViewController where Model: ViperModel {
    associatedtype Module: ViperModule
}

extension ViperAdminViewController {
    
    var listView: String {
        "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List"
    }
    
    var editView: String {
        "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit"
    }
}

extension Fluent.Model where IDValue == UUID {
    var viewIdentifier: String { self.id!.uuidString }
}
