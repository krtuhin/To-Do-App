import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_flutter/data/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDoDatabase db = ToDoDatabase();

  //reference of box
  final _myBox = Hive.box("myBox");
  final TextEditingController _control = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    //if this is first time opening the app then load default data
    if (_myBox.get("NAME") == null) {
      db.createInitialData();
    } else {
      // there already exist data
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title:
            const Text("TO DO", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: ListView.builder(
        itemCount: db.nameList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Card(
              color: Colors.yellow,
              clipBehavior: Clip.antiAlias,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          db.nameList.removeAt(index);
                          db.valueList.removeAt(index);
                        });
                        db.updateDatabase();
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: db.valueList[index],
                        activeColor: Colors.black,
                        onChanged: (value) {
                          db.valueList[index] = value!;
                          setState(() {
                            value = !value!;
                          });
                          db.updateDatabase();
                        },
                      ),
                      const SizedBox(width: 30),
                      Text(
                        db.nameList[index].toString(),
                        style: TextStyle(
                          decorationColor: Colors.black,
                          decorationStyle: TextDecorationStyle.double,
                          decoration: db.valueList[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.yellow[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: SizedBox(
                  height: 115,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        key: _formkey,
                        controller: _control,
                        decoration: InputDecoration(
                          hintText: "Add a new task",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.yellow),
                          ),
                        ),
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Task shouldn't be empty";
                        //   } else{
                        //     return null;
                        //   }
                        // },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  _control.clear();
                                });
                              },
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  db.nameList.add(_control.text);
                                  db.valueList.add(false);
                                  Navigator.pop(context);
                                  _control.clear();
                                });
                                db.updateDatabase();
                              },
                              child: const Text("Save"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
