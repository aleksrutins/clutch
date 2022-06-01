import Foundation
// https://stackoverflow.com/a/39490511
extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}