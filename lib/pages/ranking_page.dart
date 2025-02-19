import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ecoward/components/ranking_tile.dart';
import 'package:ecoward/components/skeletonRankingTile.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  bool isCompanyRanking = true;
  bool _isLoading = true;
  List<dynamic> _CompanyRanking = [];
  List<dynamic> _GlobalRanking = [];
  late UserProvider pUser;

  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRanking();
    });
  }

  Future<void> _getRanking() async {
    Response res = await HttpService().makeGetRequestWithToken(getRanking);

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final List<dynamic> CompanyRanking = responseData['CompanyRanking'];
      final List<dynamic> GlobalRanking = responseData['GlobalRanking'];
inspect(responseData['CompanyRanking']);
      setState(() {
        _CompanyRanking = CompanyRanking;
        _GlobalRanking = GlobalRanking;
        _isLoading = false; // End of request loading
      });
    } else {
      setState(() {
        _isLoading = false; // End of loading even in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCompanyRanking = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isCompanyRanking
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Entreprise',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCompanyRanking = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isCompanyRanking
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'National',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    itemCount: 10, // Show 5 skeleton items while loading
                    itemBuilder: (context, index) {
                      return SkeletonRankingTile();
                    },
                  )
                : ListView.builder(
                    itemCount: isCompanyRanking
                        ? _CompanyRanking.length
                        : _GlobalRanking.length,
                    itemBuilder: (context, index) {
                      final item = isCompanyRanking
                          ? _CompanyRanking[index]
                          : _GlobalRanking[index];
                      return RankingTile(
                        me: item['id'] == pUser.user.id,
                        name: item['name'] ?? 'Anonyme',
                        points: item['points'] ?? 0,
                        rank: index + 1,
                        avatarUrl: item['profile_photo_path'] ?? '',
                      );
                    },
                  ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
