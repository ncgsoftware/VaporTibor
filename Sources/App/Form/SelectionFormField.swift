import Foundation

struct SelectionFormField: Encodable {
    var value: String = ""
    var error: String?
    var options: [FormFieldOption] = []
}

struct FormFieldOption: Encodable {
    public let key: String
    public let label: String
    
    public init(key: String, label: String) {
        self.key = key
        self.label = label
    }
}

protocol FormFieldOptionRepresentable {
    var formFieldOption: FormFieldOption { get }
}
