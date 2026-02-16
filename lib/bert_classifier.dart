import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime_v2/onnxruntime_v2.dart';

class BertClassifier {
  late final OrtSession _session;
  late final Map<String, int> _vocab;
  final int maxLength;

  BertClassifier({this.maxLength = 128});

  Future<void> loadModel() async {
    final vocabData = await rootBundle.loadString('assets/model/vocab.txt');
    _vocab = {};
    int index = 0;
    for (var line in vocabData.split('\n')) {
      final token = line.trim();
      if (token.isNotEmpty) _vocab[token] = index++;
    }
    print("Vocab carregado: ${_vocab.length} tokens");

    final rawAsset = await rootBundle.load('assets/model/bert_ekman_int8.onnx');
    final bytes = rawAsset.buffer.asUint8List();

    final options = OrtSessionOptions();
    options.appendDefaultProviders();
    _session = OrtSession.fromBuffer(bytes, options);

    print("✅ Modelo ONNX carregado (CPU)");
  }

  Map<String, List<int>> _tokenize(String text) {
    final tokens = ['[CLS]'];
    final words = text.toLowerCase().split(RegExp(r'\s+'));

    for (var word in words) {
      if (word.isEmpty) continue;
      int start = 0;
      while (start < word.length) {
        int end = word.length;
        String curSubstr = '';
        while (start < end) {
          final sub = (start == 0 ? '' : '##') + word.substring(start, end);
          if (_vocab.containsKey(sub)) {
            curSubstr = sub;
            break;
          }
          end--;
        }
        if (curSubstr.isEmpty) {
          tokens.add('[UNK]');
          break;
        } else {
          tokens.add(curSubstr);
          start = end;
        }
      }
    }

    tokens.add('[SEP]');

    final inputIds = List<int>.filled(maxLength, 0);
    for (var i = 0; i < tokens.length && i < maxLength; i++) {
      inputIds[i] = _vocab[tokens[i]] ?? _vocab['[UNK]']!;
    }

    final attentionMask = List<int>.filled(maxLength, 0);
    for (var i = 0; i < tokens.length && i < maxLength; i++) {
      attentionMask[i] = 1;
    }

    return {
      "input_ids": inputIds,
      "attention_mask": attentionMask,
    };
  }

  Future<Map<String, dynamic>> classify(String text) async {
    final inputs = _tokenize(text);

    final inputIdsTensor = OrtValueTensor.createTensorWithDataList(
      [Int64List.fromList(inputs["input_ids"]!)],
      [1, maxLength],
    );

    final maskTensor = OrtValueTensor.createTensorWithDataList(
      [Int64List.fromList(inputs["attention_mask"]!)],
      [1, maxLength],
    );

    final outputs = await _session.runAsync(
      OrtRunOptions(),
      {
        "input_ids": inputIdsTensor,
        "attention_mask": maskTensor,
      },
      ["logits"],
    );

    if (outputs == null || outputs.isEmpty || outputs[0] == null) {
      throw Exception("Erro: saída do modelo vazia");
    }

    final logitsOrtValue = outputs[0]!;
    final rawList = logitsOrtValue.value as List;
    final logitsRow = rawList[0] as List;
    final logits = logitsRow.map((e) => (e as double)).toList();
    final emotions = ["feliz", "medo", "raiva", "triste"];
    final predictedIndex =
        logits.indexOf(logits.reduce((a, b) => a > b ? a : b));

    return {
      "predictedIndex": predictedIndex,
      "emotion": emotions[predictedIndex],
      "logits": logits,
    };
  }
}
