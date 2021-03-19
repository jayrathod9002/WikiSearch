import 'package:http/http.dart' as http;

class WebApi {
  //https://en.wikipedia.org/w/api.php ?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10

  String BASE_URL = "https://en.wikipedia.org/w/api.php";

  String url =
      "?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=random&gpslimit=10";

  Future<http.Response> getList(int pageNumber, String search) async {
    String mainurl = BASE_URL +
        "?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&"
            "pilimit=" +
        pageNumber.toString() +
        "&wbptterms=description&gpssearch=" +
        search +
        "&gpslimit=10";
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }

  Future<http.Response> getDetail(String title) async {
    String mainurl = BASE_URL + "?action=parse&page=" + title + "&format=json";
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }

  Future<http.Response> getDetailApi(String title) async {
    String mainurl = BASE_URL +
        "?action=query&prop=extracts&format=json&exintro=&titles=" +
        title;
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }

//https://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=Sachin%20Tendulkar

}

/*
{
    "parse": {
        "title": "Sachin Tendulkar",
        "pageid": 57570,
        "revid": 1012385942,
        "text": {
          "*":"test"
        },
}
 */
