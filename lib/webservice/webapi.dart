import 'package:http/http.dart' as http;

class WebApi {
  //https://en.wikipedia.org/w/api.php ?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10

  String BASE_URL = "https://en.wikipedia.org/w/api.php";
  String url =
      "?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10";

  Future<http.Response> getList() async {
    String mainurl = BASE_URL + url;
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }
}
