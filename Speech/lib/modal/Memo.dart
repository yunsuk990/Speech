
class Memo {
  int? id;
  String? title;
  String folderName;
  String? content = null;
  String dateTime;

  Memo(this.id,this.title,this.folderName, this.content, this.dateTime);

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'folderName' : folderName,
      'content' : content,
      'dateTime': dateTime
    };
  }

}