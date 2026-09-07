enum IdentityVerificationScreenType {
  intro,
  prepare,
  capture,
  processing,
  success,
  fail,
  error;

  static IdentityVerificationScreenType? from(String name) {
    switch (name) {
      case 'intro':
        return IdentityVerificationScreenType.intro;
      case 'prepare':
        return IdentityVerificationScreenType.prepare;
      case 'capture':
        return IdentityVerificationScreenType.capture;
      case 'processing':
        return IdentityVerificationScreenType.processing;
      case 'success':
        return IdentityVerificationScreenType.success;
      case 'fail':
        return IdentityVerificationScreenType.fail;
      case 'error':
        return IdentityVerificationScreenType.error;
      default:
        return null;
    }
  }
}
