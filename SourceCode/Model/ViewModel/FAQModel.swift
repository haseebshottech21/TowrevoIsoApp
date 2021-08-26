

import Foundation
struct FAQModell : Codable {
    let code : Int?
    let message : String?
    let data : [[FAQModel]]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case data = "data"
    }
}
struct FAQModel : Codable {
    let question : String?
    let answer : String?
    var isExpanded : String?
    

    enum CodingKeys: String, CodingKey {

        case question = "Question"
        case answer = "Answer"
        case isExpanded = "isExpanded"
        
    }
}


//struct FAQModel : Codable {
//
//    let code : Int
//    let message : String?
//    let total_count : Int?
//    let data : [FAQData]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case code = "code"
//        case message = "message"
//        case total_count = "total_count"
//        case data = "data"
//    }
//}

//struct FAQData : Codable {
//    
//    let id : String?
//    let title : String?
//    let description : String?
//    var isExpanded : String = "0"
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case title = "title"
//        case description = "description"
//    }
//}



class ReportTripModel: Codable
{
    let code : Int
    let message : String?
    let result : [ReportViewModel]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case result = "data"
    }
}

struct ReportViewModel : Codable {
    
    let id : String?
    let title : String?
    let description : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description  = "description"

    }
}
