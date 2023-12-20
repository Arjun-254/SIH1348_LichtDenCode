class HetanshApiTrainData2 {
  List<String?>? Type;
  List<String?>? Zone;
  List<String?>? From;
  List<String?>? PFfrom;
  List<String?>? Dep;
  List<String?>? AvgDelay;
  List<String?>? To;
  List<String?>? PFto;
  List<String?>? Arr;

  HetanshApiTrainData2({
    this.Type,
    this.Zone,
    this.From,
    this.PFfrom,
    this.Dep,
    this.AvgDelay,
    this.To,
    this.PFto,
    this.Arr,
  });
  HetanshApiTrainData2.fromJson(Map<String, dynamic> json) {
    if (json['Type'] != null && (json['Type'] is List)) {
      final v = json['Type'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      Type = arr0;
    }
    if (json['Zone'] != null && (json['Zone'] is List)) {
      final v = json['Zone'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      Zone = arr0;
    }
    if (json['From'] != null && (json['From'] is List)) {
      final v = json['From'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      From = arr0;
    }
    if (json['PFfrom'] != null && (json['PFfrom'] is List)) {
      final v = json['PFfrom'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      PFfrom = arr0;
    }
    if (json['Dep'] != null && (json['Dep'] is List)) {
      final v = json['Dep'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      Dep = arr0;
    }
    if (json['AvgDelay'] != null && (json['AvgDelay'] is List)) {
      final v = json['AvgDelay'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      AvgDelay = arr0;
    }
    if (json['To'] != null && (json['To'] is List)) {
      final v = json['To'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      To = arr0;
    }
    if (json['PFto'] != null && (json['PFto'] is List)) {
      final v = json['PFto'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      PFto = arr0;
    }
    if (json['Arr'] != null && (json['Arr'] is List)) {
      final v = json['Arr'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      Arr = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (Type != null) {
      final v = Type;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['Type'] = arr0;
    }
    if (Zone != null) {
      final v = Zone;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['Zone'] = arr0;
    }
    if (From != null) {
      final v = From;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['From'] = arr0;
    }
    if (PFfrom != null) {
      final v = PFfrom;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['PFfrom'] = arr0;
    }
    if (Dep != null) {
      final v = Dep;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['Dep'] = arr0;
    }
    if (AvgDelay != null) {
      final v = AvgDelay;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['AvgDelay'] = arr0;
    }
    if (To != null) {
      final v = To;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['To'] = arr0;
    }
    if (PFto != null) {
      final v = PFto;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['PFto'] = arr0;
    }
    if (Arr != null) {
      final v = Arr;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['Arr'] = arr0;
    }
    return data;
  }
}

class HetanshApiTrainData1 {
  List<String?>? trainName;
  List<String?>? trainNo;
  List<String?>? totalVotes;
  List<String?>? cleanliness;
  List<String?>? punctuality;
  List<String?>? food;
  List<String?>? ticket;
  List<String?>? safety;

  HetanshApiTrainData1({
    this.trainName,
    this.trainNo,
    this.totalVotes,
    this.cleanliness,
    this.punctuality,
    this.food,
    this.ticket,
    this.safety,
  });
  HetanshApiTrainData1.fromJson(Map<String, dynamic> json) {
    if (json['train_name'] != null && (json['train_name'] is List)) {
      final v = json['train_name'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      trainName = arr0;
    }
    if (json['train_no'] != null && (json['train_no'] is List)) {
      final v = json['train_no'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      trainNo = arr0;
    }
    if (json['total_votes'] != null && (json['total_votes'] is List)) {
      final v = json['total_votes'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      totalVotes = arr0;
    }
    if (json['cleanliness'] != null && (json['cleanliness'] is List)) {
      final v = json['cleanliness'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      cleanliness = arr0;
    }
    if (json['punctuality'] != null && (json['punctuality'] is List)) {
      final v = json['punctuality'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      punctuality = arr0;
    }
    if (json['food'] != null && (json['food'] is List)) {
      final v = json['food'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      food = arr0;
    }
    if (json['ticket'] != null && (json['ticket'] is List)) {
      final v = json['ticket'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      ticket = arr0;
    }
    if (json['safety'] != null && (json['safety'] is List)) {
      final v = json['safety'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      safety = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (trainName != null) {
      final v = trainName;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['train_name'] = arr0;
    }
    if (trainNo != null) {
      final v = trainNo;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['train_no'] = arr0;
    }
    if (totalVotes != null) {
      final v = totalVotes;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['total_votes'] = arr0;
    }
    if (cleanliness != null) {
      final v = cleanliness;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['cleanliness'] = arr0;
    }
    if (punctuality != null) {
      final v = punctuality;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['punctuality'] = arr0;
    }
    if (food != null) {
      final v = food;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['food'] = arr0;
    }
    if (ticket != null) {
      final v = ticket;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['ticket'] = arr0;
    }
    if (safety != null) {
      final v = safety;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['safety'] = arr0;
    }
    return data;
  }
}

class HetanshApi {
  HetanshApiTrainData1? trainData1;
  HetanshApiTrainData2? trainData2;

  HetanshApi({
    this.trainData1,
    this.trainData2,
  });
  HetanshApi.fromJson(Map<String, dynamic> json) {
    trainData1 = (json['train_data1'] != null && (json['train_data1'] is Map))
        ? HetanshApiTrainData1.fromJson(json['train_data1'])
        : null;
    trainData2 = (json['train_data2'] != null && (json['train_data2'] is Map))
        ? HetanshApiTrainData2.fromJson(json['train_data2'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (trainData1 != null) {
      data['train_data1'] = trainData1!.toJson();
    }
    if (trainData2 != null) {
      data['train_data2'] = trainData2!.toJson();
    }
    return data;
  }
}
