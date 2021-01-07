class Alarm{
  final String id;
  final String hour;
  final String min;
  final String alarmId;
  final String createTime;
  final String editTime;

  Alarm({this.id, this.hour, this.min, this.alarmId, this.createTime, this.editTime});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'hour' : hour,
      'min' : min,
      'alarmId' : alarmId,
      'createTime' : createTime,
      'editTime' : editTime,
    };
  }

  @override
  String toString(){
    return 'Alarm{id: $id, hour : $hour, min : $min, alarmId : $alarmId, createTime : $createTime, editTime : $editTime}';
  }
}