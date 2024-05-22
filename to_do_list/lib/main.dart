import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()  {


// local saving


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const myapp(),
    );
  }
}





class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}





class _myappState extends State<myapp> {
  final textController = TextEditingController();


  late List<String> todo ;
  late List<String> checked ;
  bool ischeck = false;
  late SharedPreferences pref ;

PrefIntilaztion()async{
  pref= await SharedPreferences.getInstance();
setState(() {
  todo = pref.getStringList('todo')??[''];
  checked= pref.getStringList('checked')??[];
});
}



@override
  void initState() {
PrefIntilaztion();
super.initState();
  }

    @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black54,
          title: const Text(
            "To Do List",
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 23,
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

          Expanded(
            child: ListView.builder(
                itemCount: todo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.deepPurpleAccent)),
                    title: Text(todo[index]),
                    tileColor: Colors.deepPurple,
                    leading: Checkbox(
                      value: convetStringToBoll(index, checked),
                      onChanged: (value) {
                        setState(() {
                          checked[index]= convertBoolToString(value!);
                        });
                      },
                    ),
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Are sure about deleting"),
                              backgroundColor: Colors.deepPurpleAccent,
                              actions: [
                                Column(
                                  children: [
                                    Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              DeleteList(index);
                                              save();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Text('delete')),
                                    )
                                  ],
                                )
                              ],
                            );
                          });
                    },
                  );
                }),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Add task",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        backgroundColor: Colors.deepPurpleAccent,
                        actions: [
                          TextField(
                            autofocus: true,
                            controller: textController,
                          ),
                          ElevatedButton (
                              onPressed: ()  {
                                setState(()  {
                                  getText(textController.text);
                                  textController.clear();
                                  save();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("Submit"))
                        ],
                      );
                    });
              });
            },
            child: const Icon(Icons.add),
          )
        ]));
  }


  void getText(String text) {
    todo.add(text);
    checked.add(false.toString());}


  void DeleteList(index) {
    todo.removeAt(index);
  }

  save(){
    pref.setStringList('todo', todo);
    pref.setStringList('checked', checked);
  }

}

bool convetStringToBoll(index,List<String>checked){
  if(checked[index]=='true'){
    return true;
  }
  else{
    return false;
  }

}

String convertBoolToString(bool value){
  if(value == true){
    return 'true';
  }
  else{
    return 'false';
  }
}
