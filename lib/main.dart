import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do MinimaList',
      // identidade visual
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(0xFF00BFA5),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
            ),
        )
      ),      
      home: const TarefaScreen(),
    );
  }
}

class Tarefa {
  final String id;
  String titulo;
  bool concluida;

    Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false});
}

class TarefaScreen extends StatefulWidget{
     const TarefaScreen({super.key});
     @override
     State<TarefaScreen> createState() => _TarefaScreen();
}

class _TarefaScreen extends State<TarefaScreen> {

  final List<Tarefa> _tarefas = [
    Tarefa(id: '1', titulo: 'Comprar pão, leite e ovo'),
    Tarefa(id: '2', titulo: 'Responder e-mails do trabalho', concluida: true),
    Tarefa(id: '3', titulo: 'Acadêmia às 18h'),
  ];

  final TextEditingController _controller =TextEditingController();
  
  //um painel que aparece em cima da tela principal
  void _abrirBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
      ),
      builder: (context){
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                ),
                Text(
                  'Nova Tarefa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2d2d2d),
                  ),
                ),
                SizedBox(height: 16,),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'O que precisa ser feito?',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF00BFA5),
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _adicionarTarefa()
                ),
                SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: _adicionarTarefa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFA5),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    )
                  ),
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],

            ),
          );
      }

    );
  }
  //método que adiciona tarefa na lista
  void _adicionarTarefa(){
    final texto = _controller.text.trim();
    if(texto.isEmpty) return;

    setState(() {
      //.add método de lista para adicionar elementos
      _tarefas.add(Tarefa(
        id: DateTime.now().toString(),
        titulo: texto,
      ));
    });
    _controller.clear();
    Navigator.pop(context);
  } 
  //alterna o status da tarefa através do ID
  void _alternarStatus(String id){
    setState(() {
      final tarefa = _tarefas.firstWhere((t)=> t.id == id);
      tarefa.concluida = !tarefa.concluida;
    });
  }

  void _deletarTarefa(String id){
    final index = _tarefas.indexWhere((t)=> t.id == id);
    final tarefaRemovida = _tarefas[index];

    setState(()=> _tarefas.removeAt(index));
  }
//Toda Classe que tenha um Stateless ou statefull 
//Precisa ter um Widget build(BuildContext context)
//A estrutura vísivel da nossa página
// toda classe que tenha um stateless ou stateful widget precisa ter um widget build build(BuildContext context)
  @override
  Widget build(BuildContext context){
    return Scaffold(
// por aqui podemos definir algumas caracteristicas como cor de fundo app, tamanho fonte, cor letra,
      backgroundColor: const Color(0xFFF5F5F5),
      // quase todos os elementos
      // appbar - funciona como um header do html
      appBar: AppBar(
        title: Text('2Do MinimaList'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_tarefas.where((t)=> !t.concluida).length} pendentes',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ) 
          ),
        ],
      ),
      // listview - visualização na tela em formato de lista como o Zap
      // o listview possui itens, e os itens possuem atributos como nome, foto
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        itemCount: _tarefas.length,
        itemBuilder:(context, index) {
          final tarefa = _tarefas[index];
          //Aqui se encontra o método para gesticular e o celular entender as coisa
          return Dismissible(
            key: Key(tarefa.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deletarTarefa(tarefa.id),
            child: Card(
              child:GestureDetector(

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8,
              ),
              leading: Checkbox(
                value: tarefa.concluida,
                activeColor: const Color(0xFF00BFA5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(4),
                ),
                onChanged: (_) => _alternarStatus(tarefa.id) ,
              ),
              title: Text(
                tarefa.titulo,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: tarefa.concluida ? TextDecoration.lineThrough : TextDecoration.none,
                  color: tarefa.concluida ? Colors.grey : const Color(0xFF2D2D2D),
                ),
              ),
              subtitle: Text(
                tarefa.concluida ? 'Concluida' : 'Pendente',
                style: TextStyle(
                  fontSize: 12,
                  color: tarefa.concluida ? const Color(0xFF00BFA5) : Colors.grey
                ),
              ),
            ),
          ),
        ),
      );
    },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirBottomSheet,
        backgroundColor: const Color(0xFF00BFA5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}