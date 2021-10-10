import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const NoteApp(),
    );
  }
}

class NoteApp extends StatefulWidget {
  const NoteApp({Key? key}) : super(key: key);
  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  var notes = [];
  var checkedList = [];
  String createdDate = '';
  @override
  void initState() {
    super.initState();
  }

  void removeNote(NoteModel note) {
    notes.remove(note);
    setState(() {});
  }

  bool? isChecked = false;
  TextDecoration decoration = TextDecoration.none;

  Widget noteItemView(
      {NoteModel? note,
      void Function(bool?)? onChanged,
      bool? value,
      TextDecoration? decoration}) {
    return Card(
      child: InkWell(
        onTap: () {
          openNote(noteModel: note);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      note!.content,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        decoration: decoration,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      // ignore: unnecessary_string_interpolations
                      note.date,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        decoration: decoration,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => removeNote(note),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotesList() {
    return ListView.builder(
      itemBuilder: (_context, index) {
        return noteItemView(
          note: notes[index],
          onChanged: (val) {
            notes[index].isChecked = val;
            isChecked = notes[index].isChecked;
            setState(() {
              if (isChecked == true) {
                checkedList.add(notes[index]);
              } else {
                checkedList.remove(notes[index]);
              }
            });
          },
          decoration: notes[index].isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          value: notes[index].isChecked,
        );
      },
      itemCount: notes.length,
    );
  }

  Widget buildCheckList() {
    return ListView.builder(
      itemBuilder: (_context, index) {
        return noteItemView(
          note: checkedList[index],
          decoration: checkedList[index].isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          value: checkedList[index].isChecked,
        );
      },
      itemCount: checkedList.length,
    );
  }

  void insertNote() {
    notes.add(NoteModel(' note ${notes.length}', createdDate, isChecked!));
    setState(() {});
  }

  void openNote({NoteModel? noteModel}) {
    int? createdYear = DateTime.now().year;
    int? createdMonth = DateTime.now().month;
    int? createdDay = DateTime.now().day;
    int? createdHour = DateTime.now().hour;
    int? createdMinute = DateTime.now().minute;
    int? createdSecond = DateTime.now().second;
    createdDate =
        '$createdYear-$createdMonth-$createdDay $createdHour:$createdMinute:$createdSecond';

    NoteModel _note =
        noteModel ?? NoteModel('going to shop', createdDate, isChecked!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNotePage(_note)),
    ).then((value) {
      if (noteModel == null) {
        debugPrint('createdDate = $createdDate');
        notes.add(_note);
      }
      setState(() {});
    });
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final widgetOptions = [
      buildNotesList(),
      buildCheckList(),
    ];
    return Scaffold(
      body: Center(child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        // ignore: prefer_const_literals_to_create_immutables
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: ' Checked Notes',
          ),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteModel {
  NoteModel(this.content, this.date, this.isChecked, [this.decoration]);
  String content;
  String date;
  bool isChecked;
  TextDecoration? decoration = TextDecoration.none;
}

class NewNotePage extends StatefulWidget {
  const NewNotePage(this.noteModel, {Key? key}) : super(key: key);

  final NoteModel noteModel;

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.noteModel.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: TextField(
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
          onSubmitted: (s) {},
          onChanged: (s) {
            widget.noteModel.content = _controller.text;
            debugPrint('s: $s');
          },
        ));
  }
}
