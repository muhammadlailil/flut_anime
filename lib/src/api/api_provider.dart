import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pertama/src/utils/dio_logging_interceptors.dart';

import 'api_exceptions.dart';

class ApiProvider {
  final Dio _dio = new Dio();
  final String _baseUrl = 'http://167.71.210.98:7474/anime';

  ApiProvider() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(DioLoggingInterceptors(_dio));
  }
  Future<dynamic> getAllAnime(int page) async {
    var responseJson;
    try {
      final response = await _dio.get('?page=${page}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getSearchAnime(String search) async {
    var responseJson;
    try {
      final response = await _dio.get('/search?filter=${search}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAnimeByName(String name) async {
    var responseJson;
    try {
      final response = await _dio.get(name);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

}

dynamic _returnResponse(Response<dynamic> response) {
  switch (response.statusCode) {
    case 200:
      Map<String, dynamic> responseJson = response.data;
      return responseJson;
    case 400:
      throw BadRequestException(response.data);
    case 401:
    case 403:
      throw UnauthorisedException(response.data);
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
