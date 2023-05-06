import Foundation

struct APIEndpoints {
    
    static func getTrendingRepositories(
        requestQuery: TrendingRepositoriesRequestQuery
    ) -> Endpoint<TrendingRepositoriesPageDto> {

        let responseDecoder = JSONResponseDecoder()
        responseDecoder.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return Endpoint(
            path: "search/repositories",
            method: .get,
            queryParametersEncodable: requestQuery,
            responseDecoder: responseDecoder
        )
    }
    
    static func getImage(
        path: String,
        requestQuery: ImagesRequestQuery
    ) -> Endpoint<Data> {

        Endpoint(
            path: path,
            method: .get,
            queryParametersEncodable: requestQuery,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
