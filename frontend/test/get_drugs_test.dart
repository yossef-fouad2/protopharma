import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';

void main() {
  test('get drugs with pagination', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    final db = AppDatabase();

    // Seed mock data using camelCase keys (matching the actual Firestore structure)
    await fakeFirestore.collection('drugs').add({
      'commercialNameEn': 'Amoxicillin',
      'scientificName': 'Amoxicillin',
      'manufacturer': 'Pharco',
      'drugClass': 'Antibiotic',
      'route': 'Oral',
      'priceEGP': 45.0,
    });
    
    await fakeFirestore.collection('drugs').add({
      'commercialNameEn': 'Aspirin',
      'scientificName': 'Acetylsalicylic acid',
      'manufacturer': 'Bayer',
      'drugClass': 'NSAID',
      'route': 'Oral',
      'priceEGP': 10.0,
    });

    await fakeFirestore.collection('drugs').add({
      'commercialNameEn': 'Panadol',
      'scientificName': 'Paracetamol',
      'manufacturer': 'GSK',
      'drugClass': 'Analgesic',
      'route': 'Oral',
      'priceEGP': 15.0,
    });

    final repository = DrugsRepository(firestore: fakeFirestore, db: db);

    // --- TEST PAGE 1 (Size: 2) ---
    final page1 = await repository.getDrugs(pageSize: 2);
    expect(page1.length, 2);
    expect(page1[0].commercialNameEn, 'Amoxicillin');
    expect(page1[1].commercialNameEn, 'Aspirin');
    expect(repository.hasMore, true);
    expect(repository.drugs.length, 2);

    // --- TEST PAGE 2 (Size: 2) ---
    final page2 = await repository.getDrugs(pageSize: 2);
    expect(page2.length, 1);
    expect(page2[0].commercialNameEn, 'Panadol');
    expect(repository.hasMore, false);
    expect(repository.drugs.length, 3);

    // --- TEST PAGE 3 (Size: 2) ---
    final page3 = await repository.getDrugs(pageSize: 2);
    expect(page3.length, 0);
    expect(repository.hasMore, false);
  });
}
