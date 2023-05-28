import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../service/secure_storage_service.dart';

final storageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
