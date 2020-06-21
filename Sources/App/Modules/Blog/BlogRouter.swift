import Vapor
import ViperKit


struct BlogRouter : ViperRouter {
    let frontendController = BlogFrontEndController()
    let postAdminController = BlogPostAdminController()
    let categoryAdminController = BlogCategoryAdminController()
    
    func boot(routes: RoutesBuilder, app: Application) throws {
        routes.get("blog", use: self.frontendController.blogView)
        routes.get(.anything, use: self.frontendController.postView)
        
        
        // Admin Section
        let protected = routes.grouped([
            UserModelSessionAuthenticator(),
            UserModel.redirectMiddleware(path: "/")
        ])
        
        let blog = protected.grouped("admin", "blog")
        
        
        self.postAdminController.setupRoutes(routes: blog, on: "posts")
        self.categoryAdminController.setupRoutes(routes: blog, on: "categories")
        
        
        let blogApi = routes.grouped("api", "blog")
        let categories = blogApi.grouped("categories")
        let categoryApiController = BlogCategoryApiController()
        categoryApiController.setupListRoute(routes: categories)
        categoryApiController.setupGetRoute(routes: categories)
        categoryApiController.setupCreateRoute(routes: categories)
        categoryApiController.setupUpdateRoute(routes: categories)
        categoryApiController.setupPatchRoute(routes: categories)
        categoryApiController.setupDeleteRoute(routes: categories)
        
        //API
        let postsApiController = BlogPostApiController()
        postsApiController.setupRoutes(routes: blogApi, on: "posts")
        
    }
}
