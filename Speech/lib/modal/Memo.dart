
class Memo {
  String folderName;
  String? content = null;
  String dateTime = "";

  Memo(this.folderName, this.content, this.dateTime);

  Map<String, dynamic> toMap(){
    return{
      'folderName' : folderName,
      'content' : content,
      'dateTime': dateTime
    };
  }

}