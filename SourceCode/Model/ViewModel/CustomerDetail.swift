/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerDetailModel : Codable {
	let code : Int?
	let message : String?
	let data : CustomerDetail?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case message = "message"
		case data = "data"
	}
}
struct CustomerDetailPlace : Codable {
    let address : String?
    let latitude : String?
    let longitude : String?

    enum CodingKeys: String, CodingKey {

        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
struct CustomerDetailImage : Codable {
    let id : Int?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
    }
}

struct CustomerDetail : Codable {
    let user_name : String?
    let mobile : String?
    let email : String?
    let date : String?
    let about : String?
    let user_id : String?
    let profile_image : String?
    let place : CustomerDetailPlace?
    let image : [CustomerDetailImage]?

    enum CodingKeys: String, CodingKey {

        case user_name = "user_name"
        case mobile = "mobile"
        case email = "email"
        case date = "date"
        case about = "about"
        case user_id = "user_id"
        case profile_image = "profile_image"
        case place = "place"
        case image = "image"
    }
}
