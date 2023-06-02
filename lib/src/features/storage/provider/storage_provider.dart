import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/secure_storage_service.dart';

final storageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
