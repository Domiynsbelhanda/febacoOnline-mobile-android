class Transfer {
  final String? transferDate;
  final String? type;
  final String? status;
  final String? notes;

  Transfer({
    this.transferDate,
    this.type,
    this.status,
    this.notes,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      transferDate: json['transfer_date'],
      type: json['type'],
      status: json['status'],
      notes: json['notes'],
    );
  }
}
