enum WaitlistStatus {
  none('none'),
  waiting('waiting'),
  accepted('accepted'),
  rejected('rejected');

  final String status;

  const WaitlistStatus(this.status);

  static WaitlistStatus fromName(String status) {
    switch (status) {
      case 'waiting':
        return WaitlistStatus.waiting;
      case 'accepted':
        return WaitlistStatus.accepted;
      case 'rejected':
        return WaitlistStatus.rejected;
      case 'none':
        return WaitlistStatus.none;
      default:
        return WaitlistStatus.none;
    }
  }
}
