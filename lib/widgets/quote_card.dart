import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import 'glass_card.dart';

class QuoteCard extends StatefulWidget {
  final String quote;
  final String message;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.message,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _displayedQuote = '';

  @override
  void initState() {
    super.initState();
    _displayedQuote = widget.quote;
    
    _fadeController = AnimationController(
      duration: DesignTokens.durationSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
  }

  @override
  void didUpdateWidget(QuoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quote != oldWidget.quote) {
      _fadeController.reverse().then((_) {
        setState(() {
          _displayedQuote = widget.quote;
        });
        _fadeController.forward();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: AppTheme.primaryOrange,
                size: 32,
              ),
              const SizedBox(width: DesignTokens.spaceSM),
              Text(
                'Daily Motivation',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceMD),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              '"$_displayedQuote"',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceMD),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spaceSM * 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryRed.withOpacity(0.3),
                  AppTheme.primaryOrange.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  color: AppTheme.accentYellow,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spaceSM),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
