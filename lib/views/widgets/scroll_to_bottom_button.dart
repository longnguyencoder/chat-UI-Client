import 'package:flutter/material.dart';

class ScrollToBottomButton extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback? onPressed;
  final double showThreshold; // Khoảng cách từ bottom để hiển thị button
  final Duration animationDuration;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final int? newMessageCount; // Số tin nhắn mới (tùy chọn)
  final bool showNewMessageBadge; // Có hiển thị badge tin nhắn mới không

  const ScrollToBottomButton({
    super.key,
    required this.scrollController,
    this.onPressed,
    this.showThreshold = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.iconColor,
    this.size = 40.0, // Giảm từ 48.0 xuống 40.0
    this.newMessageCount,
    this.showNewMessageBadge = true,
  });

  @override
  State<ScrollToBottomButton> createState() => _ScrollToBottomButtonState();
}

class _ScrollToBottomButtonState extends State<ScrollToBottomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _bounceAnimation;
  bool _isVisible = false;
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo animation controller
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Tạo scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Tạo opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Tạo bounce animation cho badge
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    ));

    // Lắng nghe scroll events
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;
    final shouldShow = currentScroll < maxScroll - widget.showThreshold;
    final isAtBottom = currentScroll >= maxScroll - 10; // 10px tolerance

    if (shouldShow != _isVisible || isAtBottom != _isAtBottom) {
      setState(() {
        _isVisible = shouldShow;
        _isAtBottom = isAtBottom;
      });

      if (_isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _scrollToBottom() {
    if (!widget.scrollController.hasClients) return;

    // Gọi callback nếu có
    widget.onPressed?.call();

    // Scroll to bottom với animation
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          bottom: 80, // Vị trí trên chat input
          right: 16,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? 
                         Theme.of(context).primaryColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _scrollToBottom,
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Icon mũi tên
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: widget.iconColor ?? Colors.white,
                          size: widget.size * 0.45, // Giảm từ 0.5 xuống 0.45
                        ),
                        
                        // Badge hiển thị số tin nhắn mới
                        if (widget.showNewMessageBadge && 
                            widget.newMessageCount != null && 
                            widget.newMessageCount! > 0 &&
                            !_isAtBottom)
                          Positioned(
                            top: 1,
                            right: 1,
                            child: Transform.scale(
                              scale: _bounceAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade500,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                child: Text(
                                  widget.newMessageCount! > 99 ? '99+' : '${widget.newMessageCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 