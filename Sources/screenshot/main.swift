import AppKit
import SwiftCLI

func getID(app: String, title: String?) -> CGWindowID? {
    if let info = CGWindowListCopyWindowInfo([CGWindowListOption.optionOnScreenOnly, CGWindowListOption.excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] {
        for dict in info {
            if let a = dict["kCGWindowOwnerName"] as? String,
                let t = dict["kCGWindowName"] as? String {
                if app == a && (title == nil ? true : title! == t) {
                    return dict["kCGWindowNumber"] as? CGWindowID
                }
            }
        }
    }
    return nil
}

func extensionFromImageString(_ type: String?) -> String {
    if let str = type {
        if str == "bmp" || str == "gif" || str == "jpeg" || str == "tiff" || str == "png" {
            return str
        } else if str == "jpeg2000" {
            return "jp2"
        } else {
            return "png"
        }
    } else {
        return "png"
    }
}

func defaultName(app: String, title: String?, type: String?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd-HH-mm"
    let dateString = formatter.string(from: Date())

    if let t = title {
        return "\(app)-\(t)-\(dateString).\(extensionFromImageString(type))"
    } else {
        return "\(app)-\(dateString).\(extensionFromImageString(type))"
    }
}

func imageTypeFromString(_ s: String?) -> NSBitmapImageRep.FileType {
    if s != nil {
        switch s! {
        case "bmp":
            return NSBitmapImageRep.FileType.bmp
        case "gif":
            return NSBitmapImageRep.FileType.gif
        case "jpeg":
            return NSBitmapImageRep.FileType.jpeg
        case "jpeg2000":
            return NSBitmapImageRep.FileType.jpeg2000
        case "tiff":
            return NSBitmapImageRep.FileType.tiff
        case "png": fallthrough
        default:
            return NSBitmapImageRep.FileType.png
        }
    }
    return NSBitmapImageRep.FileType.png
}

func takeScreenshot(id: CGWindowID, file: String, withShadows: Bool, type: String?) {
    // compare with python version: what if window minimized / below other window / on different display?
    var options = CGWindowImageOption.bestResolution
    if !withShadows {
        options.insert(CGWindowImageOption.boundsIgnoreFraming)
    }
    if let img = CGWindowListCreateImage(CGRect.null, CGWindowListOption.optionIncludingWindow, id, options) {
        let bitmapRep = NSBitmapImageRep(cgImage: img)

        let imageData = bitmapRep.representation(using: imageTypeFromString(type), properties: [:])!

        do {
            let output = URL(fileURLWithPath: NSString(string: file).expandingTildeInPath)
            try imageData.write(to: output, options: .atomic)
        } catch {
            print("Saving screenshot to \(file) failed:\n\(error)")
        }
    }
}

final class MainCommand: Command {
    let name = ""
    let shortDescription = "Take a screenshot of the specified <app>lication"
    let app = Parameter()
    let shadow = Flag("-s", "--shadow", description: "Capture the shadow as well")
    // let all = Flag("-a", "--all", description: "Capture all matching windows")
    let title = Key<String>("-t", "--title", description: "Window title")
    let type = Key<String>("-f", "--format", description: "Output format (bmp, gif, jpeg, jpeg2000, png, tiff) [Default: png]")
    let file = Key<String>("-o", "--out-file", description: "Output file [Required]")

    func execute() throws {
        if let id = getID(app: app.value, title: title.value) {
            let output = file.value ?? defaultName(app: app.value, title: title.value, type: type.value)
            takeScreenshot(id: id, file: output, withShadows: shadow.value, type: type.value)
        } else {
            if title.value == nil {
                print("Could not find a window by '\(app.value)'")
            } else {
                print("Could not find a window by '\(app.value)' titled '\(title.value!)'")
            }
        }
    }
}

let cli = CLI(
    singleCommand: MainCommand()
)

cli.goAndExit()
