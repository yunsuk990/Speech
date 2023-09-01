
class Memo {
  int? id;
  String folderName;
  String? content = null;
  String dateTime = "";

  Memo(this.id,this.folderName, this.content, this.dateTime);

  Map<String, dynamic> toMap(){
    return{
      'folderName' : folderName,
      'content' : content,
      'dateTime': dateTime
    };
  }

}