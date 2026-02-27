# Aplicação Mobile para Classificação de Emoções em Mensagens com Inteligência Artificial

Hoje em dia, grande parte da comunicação entre pessoas acontece através de mensagens de texto, em aplicativos de conversa, redes sociais e plataformas digitais, onde é comum mensagens ofensivas. o que pode causar conflitos, prejudicar relacionamentos e até mesmo a saúde mental dos usuários.

Devido ao grande volume de mensagens trocadas diariamente, é difícil identificar manualmente quais carregam emoções como raiva, tristeza, medo ou felicidade. O que é importante em contextos como atendimento ao cliente, redes sociais, ambientes escolares e plataformas corporativas. 

Dessa forma, esse aplicativo utiliza IA para analisar o texto da mensagem inserida pelo usuário e identificar a emoção nela contida, oferecendo uma ferramenta simples que auxilie na interpretação emocional de mensagens.

## 💻 Como Rodar

```bash
flutter pub get
flutter run
```

## 🤖 Modelo de IA

Para realizar a classificação das emoções nas mensagens, foi utilizado o modelo BERTimbau, uma versão do modelo BERT pré-treinada para o idioma português.

Após o treinamento, o modelo foi exportado para o formato ONNX, um formato otimizado para execução em aplicações mobile.

No aplicativo desenvolvido em Flutter, o modelo é carregado localmente, permitindo que a classificação seja feita diretamente no dispositivo do usuário, sem necessidade de conexão com a internet.

Quando o usuário digita ou cola uma mensagem no aplicativo, ocorre o seguinte processo:

- O texto é convertido em tokens usando o mesmo vocabulário utilizado no treinamento

- Esses tokens são transformados em dados numéricos

- Os dados são enviados para o modelo BERT

- O modelo retorna as probabilidades para cada emoção

- O aplicativo exibe a emoção com maior probabilidade com resultado
