import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/Custom/todo_card.dart';
import 'package:test/pages/add_to_do.dart';
import 'package:test/pages/sign_up_page.dart';
import 'package:test/pages/view_data.dart';
import 'package:test/service/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();

  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("ToDo").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("images/dog.jpg"),
          ),
          SizedBox(
            width: 25,
          ),
        ],
        bottom: const PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Monthday 17",
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AddToDoPage()));
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ]),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: InkWell(
                onTap: () async {
                  await authClass.logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignUpPage()),
                      (route) => false);
                },
                child: Icon(
                  Icons.logout,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              label: "")
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  switch (document["Category"]) {
                    case "Food":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                      break;
                    case "Work Out":
                      iconData = Icons.alarm;
                      iconColor = Colors.yellow;
                      break;
                    case "Work":
                      iconData = Icons.local_activity;
                      iconColor = Colors.blue;
                      break;
                    case "Design":
                      iconData = Icons.audiotrack;
                      iconColor = Colors.yellow;
                      break;
                    default:
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ViewData(
                                    document: document,
                                    id: snapshot.data?.docs[index].id,
                                  )));
                    },
                    child: TodoCard(
                        title: document["title"] == null
                            ? "No title"
                            : document["title"],
                        iconColor: iconColor,
                        iconData: iconData,
                        time: "12 pm",
                        check: true,
                        iconBgColor: Colors.white),
                  );
                });
          }),
    );
  }
}

   
// IconButton(
//               onPressed: () async {

//               icon: Icon(Icons.logout)),