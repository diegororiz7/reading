// ignore_for_file: unused_import, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'add_edit_page.dart';
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
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
