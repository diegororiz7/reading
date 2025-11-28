// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? data;

  const AddEditPage({super.key, this.docId, this.data});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _ratingController = TextEditingController();

  String _category = '';
  String _status = 'quero ler';
  DateTime _selectedDate = DateTime.now();

  final List<String> categories = ['Romance', 'Ficção', 'Técnico', 'Outros'];
  final List<String> statuses = ['lido', 'lendo', 'quero ler'];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _titleController.text = widget.data!["title"] ?? '';
      _authorController.text = widget.data!["author"] ?? '';
      _category = widget.data!["category"] ?? '';
      _status = widget.data!["status"] ?? 'quero ler';
      _ratingController.text = (widget.data!["rating"] ?? '').toString();
      _selectedDate = (widget.data!["date"] as Timestamp).toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? "Adicionar Livro" : "Editar Livro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Informe o título" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: "Autor"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Informe o autor" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _category.isNotEmpty ? _category : null,
                decoration: const InputDecoration(labelText: "Categoria"),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? ''),
                validator: (val) => val == null || val.isEmpty
                    ? "Selecione uma categoria"
                    : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status"),
                items: statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _status = val ?? 'quero ler'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ratingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Avaliação (0 a 5)",
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return null; // opcional
                  final rating = double.tryParse(val);
                  if (rating == null || rating < 0 || rating > 5)
                    return "Informe um valor entre 0 e 5";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Data: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null)
                        setState(() => _selectedDate = picked);
                    },
                    child: const Text("Selecionar data"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final data = {
                      "title": _titleController.text,
                      "author": _authorController.text,
                      "category": _category,
                      "status": _status,
                      "rating": double.tryParse(_ratingController.text) ?? 0,
                      "date": Timestamp.fromDate(_selectedDate),
                    };
                    if (widget.docId == null) {
                      FirebaseFirestore.instance
                          .collection("Readings")
                          .add(data);
                    } else {
                      FirebaseFirestore.instance
                          .collection("Readings")
                          .doc(widget.docId)
                          .update(data);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.docId == null ? "Adicionar" : "Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
