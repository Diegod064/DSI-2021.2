import 'package:flutter/material.dart';
import 'package:startup_namer/main.dart';

class PaginaEditar extends StatefulWidget {
  static const routeName = '/editar';

  // final String title;
  PaginaEditar({super.key});

  @override
  State<PaginaEditar> createState() => _PaginaEditarState();
}

class _PaginaEditarState extends State<PaginaEditar> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as Argumentos;
    query = argumentos.nome.asPascalCase;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 22),
        child: Column(
          children: [
            const Center(
              child: Text("Palavra editada:",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400)),
            ),
            Center(
              child: Text(
                argumentos.nome.asPascalCase,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            buildTextBox()
          ],
        ),
      ),
    );
  }

  Widget buildTextBox() => TextBoxWidget(
        text: query,
        onChanged: asdasdasd,
        hintText: 'Digite um nome',
      );

  void asdasdasd(String query) {
    this.query = query;
  }
}

class TextBoxWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const TextBoxWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _TextBoxWidgetState createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 48,
      // margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        // border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.edit, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
