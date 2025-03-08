import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as html;
import '../data/department_data.dart';
import '../models/curriculum_model.dart';
import '../processors/curriculum_processor.dart';

class DataService {
  static const String _baseUrl = 'https://www.atilim.edu.tr';

  // Fetch structured curriculum data for a specific department
  Future<Curriculum> fetchStructuredCurriculum({String? departmentCode}) async {
    // Fetch the raw curriculum data
    final rawData = await fetchCurriculum(departmentCode: departmentCode);

    // Process the raw data into a structured Curriculum object
    return CurriculumProcessor.processCurriculumData(
        rawData,
        departmentCode ?? 'compe'
    );
  }

  // Fetch curriculum data for a specific department
  Future<List<Map<String, dynamic>>> fetchCurriculum({String? departmentCode}) async {
    // Default to Computer Engineering if no department code is provided
    String? departmentUrl;

    if (departmentCode != null) {
      departmentUrl = DepartmentData.getDepartmentUrl(departmentCode);
      if (departmentUrl == null) {
        print('⚠️ Invalid department code: $departmentCode. Defaulting to Computer Engineering.');
        departmentUrl = DepartmentData.getDepartmentUrl('compe');
      }
    } else {
      departmentUrl = DepartmentData.getDepartmentUrl('compe');
    }

    print('🔍 Fetching curriculum from URL: $departmentUrl');

    try {
      // Make HTTP request to the curriculum page
      print('📡 Sending HTTP request...');
      final response = await http.get(
        Uri.parse(departmentUrl!),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        },
      );

      print('📥 Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Response successful, parsing HTML...');
        // Parse the HTML
        html.Document document = parse(response.body);

        // Print first 200 characters of HTML to verify content
        print('🔍 HTML preview: ${response.body.substring(0, 200)}...');

        // Extract all tables with class "col-md-12 table"
        List<html.Element> tables = document.querySelectorAll('.col-md-12.table');
        print('📊 Found ${tables.length} tables in the document');

        final List<Map<String, dynamic>> allTables = [];

        // Process each table
        for (int tableIndex = 0; tableIndex < tables.length; tableIndex++) {
          print('📝 Processing table #${tableIndex + 1}');
          var table = tables[tableIndex];
          List<Map<String, String>> tableData = [];

          // Extract table headers
          List<String> headers = [];
          var headerRow = table.querySelector('thead tr');
          if (headerRow != null) {
            headers = headerRow.querySelectorAll('th').map((th) => th.text.trim()).toList();
            print('🏷️ Table headers: $headers');
          } else {
            print('⚠️ No headers found in table #${tableIndex + 1}');
          }

          // Extract rows
          var rows = table.querySelectorAll('tbody tr');
          print('📋 Found ${rows.length} rows in table #${tableIndex + 1}');

          for (var row in rows) {
            Map<String, String> rowData = {};
            var cells = row.querySelectorAll('td');

            for (int i = 0; i < cells.length && i < headers.length; i++) {
              rowData[headers[i]] = cells[i].text.trim();
            }

            print('🔹 Row data: $rowData');
            tableData.add(rowData);
          }

          // Add this table to the results
          final tableResult = {
            'table_index': tableIndex + 1,
            'semester': _getSemesterFromTableIndex(tableIndex),
            'headers': headers,
            'data': tableData,
          };

          print('📑 Table #${tableIndex + 1} processed with ${tableData.length} rows');
          allTables.add(tableResult);
        }

        print('✅ All tables processed successfully. Total: ${allTables.length} tables');
        return allTables;
      } else {
        print('❌ Failed to load the webpage: ${response.statusCode}');
        throw Exception('Failed to load the webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error occurred while fetching curriculum data: $e');
      throw Exception('Error occurred while fetching curriculum data: $e');
    }
  }

  // Fetch detailed course information by course code
  Future<Map<String, dynamic>?> fetchCourseDetails(String courseCode) async {
    print('🔍 Fetching details for course: $courseCode');

    try {
      // Search for the course on the university website
      final searchUrl = '$_baseUrl/tr/search?query=$courseCode';
      print('🔎 Searching for course at URL: $searchUrl');

      final response = await http.get(
        Uri.parse(searchUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        },
      );

      print('📥 Search response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        html.Document document = parse(response.body);

        // Find the course link in search results
        final courseLinks = document.querySelectorAll('.search-results a');
        print('🔗 Found ${courseLinks.length} results in search');

        String? courseLink;

        for (var link in courseLinks) {
          print('🔍 Checking link: ${link.text}');
          if (link.text.contains(courseCode)) {
            courseLink = link.attributes['href'];
            print('✅ Found matching course link: $courseLink');
            break;
          }
        }

        if (courseLink == null) {
          print('⚠️ No course link found for $courseCode');
          return null; // Course not found
        }

        // Fetch the course page
        final fullCourseUrl = '$_baseUrl$courseLink';
        print('📡 Fetching course page: $fullCourseUrl');

        final courseResponse = await http.get(
          Uri.parse(fullCourseUrl),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
          },
        );

        print('📥 Course page response status code: ${courseResponse.statusCode}');

        if (courseResponse.statusCode == 200) {
          html.Document courseDocument = parse(courseResponse.body);

          // Extract course details
          final courseDetails = {
            'courseCode': courseCode,
            'title': _extractText(courseDocument, '.course-title h1'),
            'description': _extractText(courseDocument, '.course-description'),
            'credit': _extractText(courseDocument, '.course-credit'),
            'ects': _extractText(courseDocument, '.course-ects'),
            'prerequisites': _extractText(courseDocument, '.course-prerequisites'),
            'outcomes': _extractListItems(courseDocument, '.course-outcomes li'),
          };

          print('📝 Course details extracted: $courseDetails');
          return courseDetails;
        } else {
          print('❌ Failed to load course page: ${courseResponse.statusCode}');
        }
      } else {
        print('❌ Failed to load search page: ${response.statusCode}');
      }

      print('⚠️ Returning null for course $courseCode');
      return null; // Default return if course isn't found
    } catch (e) {
      print('❌ Error fetching course details: $e');
      return null;
    }
  }

  // Fetch curricula for all departments
  Future<Map<String, List<Map<String, dynamic>>>> fetchAllCurricula() async {
    print('🔍 Fetching curricula for all departments');

    Map<String, List<Map<String, dynamic>>> allCurricula = {};
    List<String> departmentCodes = DepartmentData.getAllDepartmentCodes();

    for (String code in departmentCodes) {
      try {
        print('📡 Processing department: $code');
        List<Map<String, dynamic>> curriculum = await fetchCurriculum(departmentCode: code);
        allCurricula[code] = curriculum;
        print('✅ Successfully fetched curriculum for $code');
      } catch (e) {
        print('❌ Error fetching curriculum for $code: $e');
        // Continue with next department even if one fails
      }
    }

    print('✅ Completed fetching all curricula. Total departments processed: ${allCurricula.length}');
    return allCurricula;
  }

  // Fetch curricula for all departments as structured Curriculum objects
  Future<Map<String, Curriculum>> fetchAllStructuredCurricula() async {
    print('🔍 Fetching structured curricula for all departments');

    Map<String, Curriculum> allCurricula = {};
    List<String> departmentCodes = DepartmentData.getAllDepartmentCodes();

    for (String code in departmentCodes) {
      try {
        print('📡 Processing department: $code');
        Curriculum curriculum = await fetchStructuredCurriculum(departmentCode: code);
        allCurricula[code] = curriculum;
        print('✅ Successfully fetched curriculum for $code');
      } catch (e) {
        print('❌ Error fetching curriculum for $code: $e');
        // Continue with next department even if one fails
      }
    }

    print('✅ Completed fetching all structured curricula. Total departments processed: ${allCurricula.length}');
    return allCurricula;
  }

  // Helper methods
  String _getSemesterFromTableIndex(int tableIndex) {
    final year = (tableIndex ~/ 2) + 1;
    final term = tableIndex % 2 == 0 ? 'Fall' : 'Spring';
    return 'Year $year - $term';
  }

  String _extractText(html.Document document, String selector) {
    final element = document.querySelector(selector);
    final text = element?.text.trim() ?? '';
    print('📄 Extracted text for selector "$selector": $text');
    return text;
  }

  List<String> _extractListItems(html.Document document, String selector) {
    final elements = document.querySelectorAll(selector);
    final items = elements.map((e) => e.text.trim()).toList();
    print('📋 Extracted ${items.length} list items for selector "$selector"');
    return items;
  }
}