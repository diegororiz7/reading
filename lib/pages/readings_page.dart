import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_page.dart';

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  String searchText = '';
  String filterStatus = 'todos'; // 'todos', 'lido', 'lendo', 'quero ler'

  final Map<String, IconData> categoryIcons = {
    'Romance': Icons.favorite,
    'Ficção': Icons.auto_stories,
    'Técnico': Icons.code,
    'Biografia': Icons.person,
    'Outros': Icons.menu_book,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Leituras"), centerTitle: true),
      body: Column(
        children: [
          // Filtros e pesquisa
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: filterStatus,
                  items: const [
                    DropdownMenuItem(value: 'todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'lido', child: Text('Lidos')),
                    DropdownMenuItem(value: 'lendo', child: Text('Lendo')),
                    DropdownMenuItem(
                      value: 'quero ler',
                      child: Text('Quero Ler'),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      filterStatus = val!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar por título...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        searchText = val.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Lista de leituras
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Readings")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erro: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data["status"] ?? '';
                  final title = (data["title"] ?? '').toString().toLowerCase();
                  final statusMatch =
                      filterStatus == 'todos' || status == filterStatus;
                  final searchMatch = title.contains(searchText);
                  return statusMatch && searchMatch;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("Nenhum livro encontrado."));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final title = data['title'] ?? '';
                    final author = data['author'] ?? '';
                    final category = data['category'] ?? 'Outros';
                    final status = data['status'] ?? '';
                    final rating = (data['rating'] ?? 0).toDouble();
                    final date = (data['date'] as Timestamp).toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(
                          categoryIcons[category] ?? Icons.book,
                          size: 40,
                        ),
                        title: Text(title),
                        subtitle: Text(
                          "Autor: $author\nStatus: $status - ${date.day}/${date.month}/${date.year}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            Text(rating.toStringAsFixed(1)),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddEditPage(docId: doc.id, data: data),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Excluir registro"),
                                    content: const Text(
                                      "Deseja realmente excluir este livro?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("Readings")
                                              .doc(doc.id)
                                              .delete()
                                              .then((_) => Navigator.pop(ctx));
                                        },
                                        child: const Text(
                                          "Sim",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditPage()),
          );
        },
      ),
    );
  }
}
