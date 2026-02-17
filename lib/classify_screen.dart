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

  bool _modelLoading = true;
  bool _classifying = false;
  bool _hasText = false;

  String? _errorText;
  String? _result;

  @override
  void initState() {
    super.initState();
    _loadModel();

    // Detecta se existe texto digitado
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
    } catch (e) {
      setState(() => _errorText = 'Erro ao carregar modelo: $e');
    } finally {
      setState(() => _modelLoading = false);
    }
  }

  Future<void> _classify() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _classifying = true;
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
      setState(() => _classifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.lightBlueAccent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "CLASSIFICADOR",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),

                        Text(
                          "Análise de Emoção",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// TEXTO
                const Text(
                  "Digite sua mensagem",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                // INPUT
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Ex: Estou muito feliz hoje!",
                      hintStyle: TextStyle(
                        color: Colors.white38,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOTÃO
                GestureDetector(
                  onTap: (_modelLoading || _classifying || !_hasText)
                      ? null
                      : _classify,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (_modelLoading || _classifying || !_hasText)
                            ? [
                                Colors.grey.shade800,
                                Colors.grey.shade900,
                              ]
                            : [
                                const Color(0xFF334155),
                                const Color(0xFF1E293B),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Center(
                      child: _classifying
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Classificar Emoção",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // LOADING
                if (_classifying)
                  Center(
                    child: Column(
                      children: const [

                        CircularProgressIndicator(
                          color: Colors.white,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "Analisando emoção...",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),

                // RESULTADO
                if (_result != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      children: [

                        const Text(
                          "EMOÇÃO IDENTIFICADA",
                          style: TextStyle(
                            color: Colors.white60,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          _result!,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                /// ERRO
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
