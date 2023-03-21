import Foundation
import SwiftyJSON

public protocol JSONAdapterObject {
    associatedtype ModelType
    static func parse(json: JSON) -> ModelType
}
