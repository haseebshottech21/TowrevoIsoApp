/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CompanyDetailModel : Codable {
	let code : Int?
	let message : String?
	let data : CompanyDetail?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case message = "message"
		case data = "data"
	}
}

struct CompanyImage : Codable {
    let id : Int?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
    }
}

struct CompanyDetail : Codable {
    let company_name : String?
    let mobile : String?
    let email : String?
    let company_profile_image : String?
    let user_id : String?
    let description : String?
    let image : [CompanyImage]?

    enum CodingKeys: String, CodingKey {

        case company_name = "company_name"
        case mobile = "mobile"
        case email = "email"
        case company_profile_image = "company_profile_image"
        case user_id = "user_id"
        case description = "description"
        case image = "image"
    }
}
