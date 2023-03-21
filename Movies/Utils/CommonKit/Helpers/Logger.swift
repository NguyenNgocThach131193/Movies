import UIKit

public class Logger {
    public static var turnOnLog = true

    public class func log( message: @autoclosure () -> Any, file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Logger.abstractLog(file: file, function, line, logType: "LOG 👉", message: "\(message())")
    }

    public class func error( message: @autoclosure () -> Any, file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Logger.abstractLog(file: file, function, line, logType: "ERROR ➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎➡︎🚫", message: "\(message())")
    }

    public class func debug( message: @autoclosure () -> Any, file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Logger.abstractLog(file: file, function, line, logType: "DEBUG 🚩", message: "\(message())")
    }

    public class func success( message: @autoclosure () -> Any, file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Logger.abstractLog(file: file, function, line, logType: "SUCCESS 👍", message: "\(message())")
    }

    static func abstractLog(file: String, _ function: String, _ line: Int, logType: String, message: String) {

        guard Logger.turnOnLog else { return }

        var destination = ""
        if let unwrap = file.components(separatedBy: "/").last?.components(separatedBy: "."), let unwrapObj = unwrap.first {
            destination = unwrapObj
        }

        var str = ""
        str += "📝 \(destination)"
        str += " - \(function) - \(line) ➢ "
        str += "\(logType) : "
        str += "\(message)"
        print(str)
    }
}
