import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/ServerSide/function.dart';

class ChartBWEMP extends StatefulWidget {
  final String Emailof;
  final String Sendername;
  final String Recivername;
  final String name;

  ChartBWEMP(
      {Key? key,
      required this.Emailof,
      required this.Sendername,
      required this.Recivername,
      required this.name})
      : super(key: key);

  @override
  State<ChartBWEMP> createState() => _ChartBWEMPState();
}

class _ChartBWEMPState extends State<ChartBWEMP> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: Chart()
                    .GetConversation(widget.Sendername, widget.Recivername),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error has come: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No messages yet.'));
                  }

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages =
                      snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = messages[index].data();
                      bool isCurrentUser =
                          data['senderId'] == widget.Sendername;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blueAccent
                                : Colors
                                    .purpleAccent, //Colors.blueAccent, Colors.purpleAccent
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCurrentUser
                                    ? widget.Sendername
                                    : widget.Recivername,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(data['message'] ?? 'No message'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) {
                        Chart().ConversionBWEmployee(
                          '${widget.Sendername}${widget.Recivername}',
                          _textEditingController.text,
                          widget.Sendername,
                          widget.Recivername,
                        );

                        _textEditingController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
