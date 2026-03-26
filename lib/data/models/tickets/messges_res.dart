class TicketsResponce {
  bool? success;
  int? statuscode;
  String? message;
  List<Message>? data;

  TicketsResponce({this.success, this.statuscode, this.message, this.data});

  TicketsResponce.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Message>[];
      json['data'].forEach((v) {
        data!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? sId;
  String? category;
  String? subject;
  String? status;
  String? createdAt;
  List<Messages>? messages;

  Message({
    this.sId,
    this.category,
    this.subject,
    this.status,
    this.createdAt,
    this.messages,
  });

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    subject = json['subject'];
    status = json['status'];
    createdAt = json['createdAt'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['category'] = category;
    data['subject'] = subject;
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? sender;
  String? message;

  Messages({this.sender, this.message});

  Messages.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['message'] = message;
    return data;
  }
}
