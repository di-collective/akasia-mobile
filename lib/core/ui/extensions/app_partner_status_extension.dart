enum AppPartnerStatus {
  connected,
  disconnected,
}

extension AppPartnerStatusExtension on AppPartnerStatus {
  static AppPartnerStatus toAppPartnerStatus(bool? status) {
    switch (status) {
      case true:
        return AppPartnerStatus.connected;
      case false:
        return AppPartnerStatus.disconnected;
      default:
        return AppPartnerStatus.disconnected;
    }
  }

  static AppPartnerStatus toggle(AppPartnerStatus? status) {
    switch (status) {
      case AppPartnerStatus.connected:
        return AppPartnerStatus.disconnected;
      case AppPartnerStatus.disconnected:
        return AppPartnerStatus.connected;
      default:
        return AppPartnerStatus.disconnected;
    }
  }
}
