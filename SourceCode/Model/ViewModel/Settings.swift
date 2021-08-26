/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SettingsModel : Codable {
	let code : Int?
	let message : String?
	let data : [Settings]?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case message = "message"
		case data = "data"
	}
}
struct Settings : Codable {
    let email : String?
    let website_name : String?
    let copyright : String?
    let mobile : String?
    let facebook_link : String?
    let twitter_link : String?
    let instagram_link : String?
    let playstore_Link : String?
    let applestore_Link : String?
    let website_Logo : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case website_name = "website_name"
        case copyright = "copyright"
        case mobile = "mobile"
        case facebook_link = "facebook_link"
        case twitter_link = "twitter_link"
        case instagram_link = "instagram_link"
        case playstore_Link = "playstore_Link"
        case applestore_Link = "applestore_Link"
        case website_Logo = "website_Logo"
    }

}
