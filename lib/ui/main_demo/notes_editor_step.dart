import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/server/api/notes_api.dart';
import 'package:passkey_demo_frontend/server/models/simple_note.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../passkey/user.dart';

class NotesEditorStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;
  final NotesAPI notesAPI;

  const NotesEditorStepWidget(
      {super.key, required this.notesAPI, required this.passkeyService});

  @override
  State<NotesEditorStepWidget> createState() => _NotesEditorStepWidgetState();
}

class _NotesEditorStepWidgetState extends State<NotesEditorStepWidget> {
  final textEditingController = TextEditingController();
  SimpleNote? serverNote;

  @override
  void initState() {
    super.initState();
    Provider.of<DemoEventBus>(context, listen: false).events.listen((event) {
      if (event == DemoEvent.reset) {
        setState(() {
          textEditingController.text = "";
          serverNote = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityState>(
        builder: (BuildContext context, IdentityState value, Widget? child) {
          if (value.user != null) {
            User user = value.user;
            return FutureBuilder<SimpleNote>(
              future: fetchNotes(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    textEditingController.text = snapshot.data!.note;
                    return BasicStep(
                      title: "Notes App - Read/Edit User Notes",
                      description:
                          "It is to demonstrate that current user [${user.userHandle}]"
                          " can read/write their secured notes. ",
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: textEditingController,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              labelText: 'Enter your text',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        StepButton("Update Notes", onTap: () {
                          updateNotes(context, user);
                        })
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return StepOutputWidget(
                        stepOutput: StepOutput(
                            timestamp: DateTime.now(),
                            output:
                                "Error fetching notes.. check server configuration.."));
                  }
                }
                return const Loading();
              },
            );
          }
          return child!;
        },
        child: const Loading());
  }

  Future<SimpleNote>? fetchNotes(User user) async {
    if (serverNote != null) {
      return serverNote!;
    }
    if (user.token != null) {
      var note = await widget.notesAPI.notesGet(user.token!);
      setState(() {
        serverNote = note;
      });
      return serverNote!;
    }
    throw Exception("User Is Not Logged In.");
  }

  updateNotes(BuildContext context, User user) async {
    if (user.token == null) {
      throw Exception("User Is Not Logged In.");
    }
    await widget.notesAPI
        .notesPut(user.token!, SimpleNote(textEditingController.text));
    setState(() {
      StepStateApi.onSuccess(context);
      NotificationUtils.notify(context, "User Notes Updated !");
    });
  }
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
