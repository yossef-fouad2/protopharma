import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';

class DrugsRepository {
  final FirebaseFirestore _firestore;
  
  // List of all loaded drugs across pages
  final List<DrugModel> drugs = [];
  
  // Pagination tracking variables
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;

  DrugsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Getters to inspect the state from outside
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  /// Fetches a page of drugs from Firestore.
  /// 
  /// Set [isRefresh] to true to start fetching from the first page again.
  Future<List<DrugModel>> getDrugs({int pageSize = 20, bool isRefresh = false}) async {
    // If already loading, ignore duplicate calls
    if (_isLoading) return [];

    if (isRefresh) {
      _lastDocument = null;
      _hasMore = true;
      drugs.clear();
    }

    // If there is no more data, return empty list
    if (!_hasMore) return [];

    _isLoading = true;

    try {
      // 1. Start with the ordered query
      Query query = _firestore
          .collection('drugs')
          .orderBy('commercialNameEn');

      // 2. Apply startAfterDocument cursor first (essential for fake_cloud_firestore sequence matching)
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      // 3. Apply limit last
      query = query.limit(pageSize);

      final querySnapshot = await query.get();

      // If we fetched fewer items than requested, we reached the end
      if (querySnapshot.docs.length < pageSize) {
        _hasMore = false;
      }

      // Save the last document as the cursor for the next page
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      // Map to models
      final newDrugs = querySnapshot.docs.map((doc) {
        return DrugModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      drugs.addAll(newDrugs);
      return newDrugs;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
