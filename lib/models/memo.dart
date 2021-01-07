class Memo{
  final String id;
  final String title;
  final String author;
  final String text;
  final String image;
  final String createTime;
  final String editTime;

  Memo({this.id, this.title, this.author, this.text, this.image, this.createTime, this.editTime});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'author' : author,
      'text' : text,
      'image' : image,
      'createTime' : createTime,
      'editTime' : editTime,
    };
  }

  @override
  String toString(){
    return 'Memo{id: $id, title : $title, author : $author, text : $text, image : $image, createTime : $createTime, editTime : $editTime}';
  }
}