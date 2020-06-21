import Vapor
import Fluent

struct BlogCategoryAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias EditForm = BlogCategoryEditForm
    typealias Model = BlogCategoryModel

}
