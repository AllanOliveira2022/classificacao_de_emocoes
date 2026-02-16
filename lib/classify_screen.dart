import 'package:flutter/material.dart';
import 'bert_classifier.dart';

class ClassifyScreen extends StatefulWidget {
  const ClassifyScreen({super.key});

  @override
  State<ClassifyScreen> createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  final TextEditingController _controller = TextEditingController();
  final BertClassifier _classifier = BertClassifier(maxLength: 128);
  bool _loading = true;
  String? _errorText;
  String? _result;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
    } catch (e) {
      setState(() => _errorText = 'Erro ao carregar modelo: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _classify() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _loading = true;
      _errorText = null;
      _result = null;
    });

    try {
      final resultData = await _classifier.classify(text);
      setState(() {
        _result = resultData['emotion'] as String;
      });
    } catch (e) {
      setState(() => _errorText = 'Erro ao classificar: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores da paleta Rosa Claro
    const Color primaryPink = Color(0xFFF472B6); // Rosa claro vibrante
    const Color lightPinkBg = Color(0xFFFDF2F8); // Fundo rosa quase branco
    const Color darkPinkText = Color(0xFF9D174D); // Rosa escuro para textos

    return Scaffold(
      backgroundColor: Colors.white, // Fundo geral branco
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: lightPinkBg, // Topo em rosa bem clarinho
            border: Border(
              bottom: BorderSide(color: Color(0xFFFCE7F3), width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPink.withOpacity(0.1),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded, 
                      color: primaryPink, 
                      size: 28
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLASSIFICADOR DE IA',
                        style: TextStyle(
                          color: primaryPink,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Análise de Emoção',
                        style: TextStyle(
                          color: darkPinkText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Digite uma mensagem para classificar:',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            // CAIXA DE TEXTO BRANCA COM RELEVO SUAVE
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
                decoration: InputDecoration(
                  hintText: 'Como foi o seu dia?',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // BOTÃO ROSA CLARO
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _loading ? null : _classify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Classificar Mensagem',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 40),

            // RESULTADO BRANCO COM RELEVO
            if (_result != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPink.withOpacity(0.06),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFFDF2F8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightPinkBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SENTIMENTO IDENTIFICADO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryPink,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _result!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: darkPinkText,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}