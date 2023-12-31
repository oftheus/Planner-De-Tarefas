import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/Views/updateTask.dart';
import 'package:planner/Widgets/taskboardWidget.dart';

class TaskExpander extends StatefulWidget {
  //bool expand;
  final bool expand;
  final Function(int index) onDelete;
  final Function(int index) onEdit;
  final Function(int index) onCompleted;
  final int id;
  String title;
  String note;
  DateTime date;
  String startTime;
  String endTime;
  final int isCompleted;
  final int color;
  final int icon;
  final int indexListTask;

  TaskExpander({
    Key? key,
    required this.expand,
    required this.onDelete,
    required this.onEdit,
    required this.onCompleted,
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isCompleted,
    required this.color,
    required this.icon,
    required this.indexListTask,
  }) : super(key: key);

  @override
  State<TaskExpander> createState() => _TaskExpanderState();
}

class _TaskExpanderState extends State<TaskExpander> {
  late Color color2;
  late Color color1;
  final db = DatabaseHelper();

  @override
  initState() {
    super.initState();
    color1 = colorsList[widget.color];
    color2 = modifyColor(colorsList[widget.color], -120);
  }

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

  void editWidget() async {
    //botão edit task chama essa função

    //Esta função chama (usando push, não push named) o código para atualizar uma tarefa
    //como não é o push named, o código do updateTask usa o 'Navigator.pop' para voltar para esta página
    //com o contexto que ela estava no momento em que o botão foi apertado
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateTask(
                taskId: widget.id,
                color: widget.color,
                endTime: widget.endTime,
                date: toUpdateFormat(widget.date),
                startTime: widget.startTime,
                nome: widget.title,
                note: widget.note)));

    //depois, carrega denova os dados do banco de dados
    List<Map<String, dynamic>> rawQuery = await db.getTaskDataById(widget.id);
    Map<String, dynamic> updatedData = rawQuery[0];
    widget.title = updatedData['name'];
    widget.note = updatedData['note'];
    widget.endTime = updatedData['endTime'];
    widget.startTime = updatedData['startTime'];
    String date = updatedData['date'];
    int year = int.parse(date.split('-')[0]);
    int month = int.parse(date.split('-')[1]);
    int day = int.parse(date.split('-')[2]);
    DateTime dt = DateTime(year, month, day);
    widget.date = dt;
    setState(() {});
    
  }

  String toUpdateFormat(DateTime dt) {
    //função converte de volta do dateTime para o formato que a classe updateTask usa
    //print('DT');
    //print(dt);
    return dt.toString().split(' ')[0];
  }

  //Mudar o tom da cor
  Color modifyColor(Color originalColor, int brightness) {
    int red = originalColor.red + brightness;
    int green = originalColor.green + brightness;
    int blue = originalColor.blue + brightness;

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expand) {
      return Container(
        decoration: BoxDecoration(
            color: color1, borderRadius: const BorderRadius.all(Radius.circular(20))),
        margin: const EdgeInsets.symmetric(vertical: 6),
        //height: 100,
        child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Titulo da Tarefa
                    Text(widget.title,
                        style: TextStyle(
                          fontSize: widget.title.length > 20 ? 14 : 19,
                          fontWeight: FontWeight.bold,
                          color: color2,
                        )),
                    Row(
                      children: [
                        //Data da tarefa
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: Row(
                            children: [
                              //Dia
                              Text(
                                '${DateFormat.E().format(widget.date)} ${widget.date.day}/${widget.date.month}',
                                style: TextStyle(
                                    color: color2,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(
                                indent: 4,
                              ),
                              Icon(Icons.alarm, color: color2, size: 13),
                              const Divider(
                                indent: 2,
                              ),
                              //hora
                              Text(
                                widget.startTime,
                                style: TextStyle(
                                    color: color2,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        widget.isCompleted == 0
                            ? Row(
                                children: [
                                  //isComplete
                                  Icon(
                                    Icons.hourglass_empty_rounded,
                                    size: 13,
                                    color: color2,
                                  ),
                                  const Divider(
                                    indent: 2,
                                  ),
                                  Text(
                                    "Pendente",
                                    style:
                                        TextStyle(color: color2, fontSize: 13),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  //isComplete
                                  Icon(
                                    Icons.task_alt,
                                    size: 15,
                                    color: color2,
                                  ),
                                  const Divider(
                                    indent: 2,
                                  ),
                                  Text(
                                    "Concluído",
                                    style:
                                        TextStyle(color: color2, fontSize: 13),
                                  )
                                ],
                              )
                      ],
                    )
                  ],
                ),
                //Icone
                Icon(
                  IconLabel.values[widget.icon].icon,
                  size: 55,
                  color: color2.withOpacity(0.4),
                ),
              ],
            )),
      );

      //EXPANDIDO
    } else {
      return Container(
          decoration: BoxDecoration(
              color: color1,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          margin: const EdgeInsets.symmetric(vertical: 6),
          //height: 320,
          child: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //Icone title pendente
                  children: [
                    Row(
                      children: [
                        Icon(
                          IconLabel.values[widget.icon].icon,
                          color: color2,
                          size: 34,
                        ),
                        const Divider(
                          indent: 6,
                        ),
                        Text(widget.title,
                            style: TextStyle(
                              fontSize: widget.title.length > 20 ? 14 : 20,
                              fontWeight: FontWeight.bold,
                              color: color2,
                            ))
                      ],
                    ),
                    widget.isCompleted == 0
                        ? Column(
                            children: [
                              Icon(Icons.hourglass_empty_rounded,
                                  color: color2, size: 18),
                              Text("Pendente",
                                  style: TextStyle(
                                      color: color2,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600))
                            ],
                          )
                        : Column(
                            children: [
                              Icon(Icons.task_alt, color: color2, size: 18),
                              Text("Concluído",
                                  style: TextStyle(
                                      color: color2,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600))
                            ],
                          )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '${DateFormat.E().format(widget.date)} ${widget.date.day}/${widget.date.month}',
                      style: TextStyle(
                          color: color2,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      indent: 4,
                    ),
                    Icon(Icons.alarm, color: color2, size: 13),
                    const Divider(
                      indent: 2,
                    ),
                    Text(
                      widget.startTime,
                      style: TextStyle(
                          color: color2,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              //Anotation
              Container(
                margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                padding: const EdgeInsets.all(9),
                //height: 180,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white38),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ANOTAÇÃO",
                        style: TextStyle(
                            color: color2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        endIndent: 200,
                        color: color2.withOpacity(0.3),
                      ),
                      Text(
                        widget.note,
                        style: TextStyle(color: color2.withOpacity(.8)),
                      )
                    ]),
              ),
              //Botoes
              Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.fromLTRB(15, 6, 0, 6),
                child: Row(
                  children: [
                    // Botão Apagar
                    MaterialButton(
                      onPressed: () {
                        //Confirmar apagar
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Apagar'),
                                content: const Text('Deseja apagar?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('cancelar')),
                                  TextButton(
                                      onPressed: () {
                                        db.deleteTask(widget.id);
                                        widget.onDelete(widget.indexListTask);
                                        print('APAGAR');
                                        Navigator.pop(context);
                                        Future.delayed(
                                          const Duration(milliseconds: 500),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(Icons.check,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Tarefa apagada!",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(5),
                                            elevation: 4,
                                            duration:
                                                const Duration(seconds: 4),
                                          ),
                                        );
                                      },
                                      child: const Text('sim')),
                                ],
                              );
                            });
                      },
                      minWidth: MediaQuery.of(context).size.width / 5,
                      color: color2,
                      textColor: color1,
                      child: const Text(
                        "Apagar",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    const Divider(
                      indent: 6,
                    ),
                    //EDITAR
                    MaterialButton(
                      onPressed: editWidget,
                      minWidth: MediaQuery.of(context).size.width / 5,
                      color: color2,
                      textColor: color1,
                      child: const Text(
                        "Editar",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    const Divider(
                      indent: 6,
                    ),
                    //Concluido
                    widget.isCompleted == 0
                        ? MaterialButton(
                            onPressed: () {
                              //isComplete do banco de dados
                              widget.onCompleted(widget.indexListTask);
                              db.completeTask(widget.id);
                              print('Complete');
                            },
                            minWidth: MediaQuery.of(context).size.width / 5,
                            color: color2,
                            textColor: color1,
                            child: const Text(
                              "Concluído",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            ]),
          ));
    }
  }
}
