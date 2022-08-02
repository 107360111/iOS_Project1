class MapAPI : Codable{
    var results : results
}
class results : Codable{
    var content : [content]
}
class content : Codable{
    var lat : Double
    var lng : Double
    var name : String
    var vicinity : String
    var photo : String
    var landscape : [String]
    var star : Int
}
