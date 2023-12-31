import 'package:flutter/material.dart';
import 'package:planner/Page/mainPage.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/openTaskBoard.dart';
import 'package:planner/userSession.dart';

class NewTask extends StatefulWidget {
  String nameBoard;
  int color;
  int taskBoardID;
  NewTask(
      {super.key,
      required this.nameBoard,
      required this.color,
      required this.taskBoardID});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  List<Color> colorsList = [
    const Color(0xFFD7423D),
    const Color(0xFFFFE066),
    const Color(0xFFFFBA59),
    const Color(0xFFFF8C8C),
    const Color(0xFFFF99E5),
    const Color(0xFFC3A6FF),
    const Color(0xFF9FBCF5),
    const Color(0xFF8CE2FF),
    const Color(0xFF87F5B5),
    const Color(0xFFBCF593),
    const Color(0xFFE2F587),
    const Color(0xFFD9BCAD),
    Colors.grey.shade50
  ];

  TextEditingController nomeController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late String nome;
  bool nomeVazio = true;
  late String startTime;
  bool startTimeVazio = true;
  late String endTime;
  bool endTimeVazio = true;
  late String date;
  bool dateVazio = true;
  late String note = "";

  final db = DatabaseHelper();

  String getDateDisplay() {
    if (dateVazio) {
      return "  Data: Não selecionada ainda.";
    }
    return "  Data: $date";
  }

  String getStartDateDisplay() {
    if (startTimeVazio) {
      return "  Horário inicial: Não selecionado ainda.";
    }
    return "  Horário inicial: $startTime";
  }

  String getEndDateDisplay() {
    if (endTimeVazio) {
      return "  Horário final: Não selecionado ainda.";
    }
    return "  Horário final: $endTime";
  }

  void updateDate(DateTime? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      dateVazio = false;
      date = dt.toString().split(' ')[0];
    });
  }

  void updateStart(TimeOfDay? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      startTimeVazio = false;
      startTime = dt.toString().split('(')[1].replaceAll(')', '');
    });
  }

  void updateEnd(TimeOfDay? dt) {
    if (dt == null) {
      return;
    }
    setState(() {
      endTimeVazio = false;
      endTime = dt.toString().split('(')[1].replaceAll(')', '');
    });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((value) => updateDate(value));
  }

  void _showStartPicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => updateStart(value));
  }

  void _showEndPicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => updateEnd(value));
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorsList[widget.color],
          title: const Text(
            "Nova Tarefa",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OpenTaskBoard(
                            name: widget.nameBoard,
                            color: widget.color,
                            taskBoardID: widget.taskBoardID,
                          )));
            },
          ),
          centerTitle: true,
        ),
        body: Container(
            //color: colorsList[selectColorIndex],
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  //NOME DA TAREFA
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nome da tarefa",
                    ),
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    controller: nomeController,
                    onChanged: (String value) {
                      nome = value;
                      //print(nome);
                      setState(() {
                        nomeVazio = value.isEmpty;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //PICK DATE
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        color: colorsList[widget.color],
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Escolher Data",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getDateDisplay(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //PICK START TIME
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showStartPicker();
                        },
                        color: colorsList[widget.color],
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Horário Inicial",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getStartDateDisplay(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //PICK END TIME
                  Center(
                    child: SizedBox(
                      width: 335,
                      child: MaterialButton(
                        onPressed: () {
                          _showEndPicker();
                        },
                        color: colorsList[widget.color],
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Horário final",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getEndDateDisplay(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //WRITE NOTE
                  const Text(
                    "  Nota sobre tarefa:",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12))),
                    style: const TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                    controller: noteController,
                    onChanged: (String value) {
                      note = value;
                    },
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  //CRIAR TAREFA
                  Center(
                    child: ElevatedButton(
                        onPressed: (nomeVazio ||
                                endTimeVazio ||
                                startTimeVazio ||
                                dateVazio)
                            ? null
                            : () {
                                int userID = UserSession.getID();
                                db.insertTask(
                                    nome,
                                    note,
                                    0,
                                    startTime,
                                    endTime,
                                    date,
                                    widget.taskBoardID,
                                    userID); //toda atividade inicia marcada como incompleta
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()));
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Tarefa criada!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                    elevation: 4,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              },
                        child: const Text("CRIAR TAREFA")),
                  )
                ],
              ),
            )));
  }
}
