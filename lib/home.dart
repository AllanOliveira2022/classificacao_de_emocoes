import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFAFAFA),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Elementos decorativos de fundo
            Positioned(
              top: 50,
              right: 30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD946EF).withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD946EF).withOpacity(0.05),
                ),
              ),
            ),
            // Conteúdo principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    // Conteúdo animado
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Título principal com destaque
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A1A),
                                  height: 1.3,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Deixe a IA descobrir\no que ',
                                  ),
                                  TextSpan(
                                    text: 'importa',
                                    style: const TextStyle(
                                      color: Color(0xFFD946EF),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' nas\nsuas mensagens',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Subtítulo
                            Text(
                              'SmartText IA analisa e identifica\nautomaticamente mensagens importantes\ne desnecessárias.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.7,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Espaçador flexível para empurrar o botão para baixo
                    const Expanded(
                      child: SizedBox(),
                    ),
                    // Botão "Começar agora" com animação
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isButtonPressed = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isButtonPressed = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              // Navegar para a tela de classificação
                              Navigator.of(context).pushNamed('/classify');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isButtonPressed
                                      ? [
                                          const Color(0xFFD946EF)
                                              .withOpacity(0.9),
                                          const Color(0xFFEC4899)
                                              .withOpacity(0.9),
                                        ]
                                      : [
                                          const Color(0xFFD946EF),
                                          const Color(0xFFEC4899),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD946EF)
                                        .withOpacity(_isButtonPressed ? 0.5 : 0.3),
                                    blurRadius:
                                        _isButtonPressed ? 16 : 12,
                                    offset: Offset(0, _isButtonPressed ? 6 : 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Começar agora',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Transform.translate(
                                    offset: Offset(
                                        _isButtonPressed ? 4 : 0, 0),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
