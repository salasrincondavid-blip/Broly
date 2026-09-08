class StoreHelper {
  static const Map<String, String> _storeMap = {
    '1': 'Steam',
    '2': 'GamersGate',
    '3': 'GreenManGaming',
    '4': 'Amazon',
    '5': 'GameStop',
    '6': 'Direct2Drive',
    '7': 'GOG',
    '8': 'Origin',
    '11': 'Humble Store',
    '13': 'Ubisoft Connect',
    '15': 'Fanatical',
    '25': 'Epic Games Store',
    '27': 'Gamesplanet',
    '28': 'Gamesload',
    '29': '2Game',
    '30': 'IndieGala',
    '31': 'Blizzard Shop',
    '33': 'DLGamer',
    '34': 'Noctre',
    '35': 'DreamGame',
  };

  /// Devuelve el nombre legible de la tienda según su storeID en CheapShark.
  static String getStoreName(String storeID) {
    return _storeMap[storeID] ?? 'Tienda Digital (ID: $storeID)';
  }
}
