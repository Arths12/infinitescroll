import 'package:flutter/material.dart';
import 'package:listbuilder/api/apiservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService =
      ApiService(apiUrl: 'https://dummyjson.com/users');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scroll with Pagination',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Infinite Scroll with Pagination'),
        ),
        body: InfiniteScrollPage(apiService: apiService),
      ),
    );
  }
}

class InfiniteScrollPage extends StatefulWidget {
  final ApiService apiService;

  InfiniteScrollPage({required this.apiService});

  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _perPage = 10;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final newData = await widget.apiService.fetchData(
      limit: _perPage,
      page: _currentPage,
    );

    setState(() {
      _data.addAll(newData);
      _isLoading = false;
      _hasReachedMax = newData.length < _perPage;

      _perPage += 10;
      _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _data.length + (_hasReachedMax ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == _data.length) {
            return _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink();
          } else if (index < _data.length) {
            final item = _data[index];
            return ListTile(
              title: Text(item['firstName']),
              subtitle: Text(item['email']),
              trailing: Text('$index'),
            );
          } else {
            return Center(
              child: Text("Data sudah ditampilkan semua"),
            );
          }
        },
      ),
    );
  }
}
