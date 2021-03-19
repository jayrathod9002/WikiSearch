import 'package:http/http.dart' as http;

class WebApi {


  String BASE_URL = "https://en.wikipedia.org/w/api.php";

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

  /*Future<http.Response> getDetail(String title) async {
    String mainurl = BASE_URL + "?action=parse&page=" + title + "&format=json";
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }*/

  Future<http.Response> getDetailApi(String title) async {
    String mainurl = BASE_URL +
        "?action=query&prop=extracts&format=json&exintro=&titles=" +
        title;
    print("Main Url => " + mainurl);
    var response = await http.get(mainurl);
    print(response.body);
    return response;
  }



}


