class Performance {
  final String? date;
  final String? event;
  final String? score;
  final String? position;
  final String? observation;

  Performance({
    this.date,
    this.event,
    this.score,
    this.position,
    this.observation,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      date: json['date'],
      event: json['event'],
      score: json['score'],
      position: json['position'],
      observation: json['observation'],
    );
  }
}
