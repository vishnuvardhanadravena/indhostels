
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/support/support_bloc.dart';
import 'package:indhostels/data/repo/reviews_support_repo.dart';
import 'package:intl/intl.dart';

const _kPrimary = Color(0xFF1A6FE8);
const _kPrimaryLight = Color(0xFFE8F0FD);
const _kAccent = Color(0xFF00C6AE);
const _kBg = Color(0xFFF5F7FA);
const _kSurface = Colors.white;
const _kTextDark = Color(0xFF1C2331);
const _kTextMid = Color(0xFF6B7280);
const _kTextLight = Color(0xFFB0B8C4);
const _kAdmin = Color(0xFFF0F1F3);
const _kUser = Color(0xFF1A6FE8);
const _kResolvedBadge = Color(0xFFE6FAF7);
const _kResolvedText = Color(0xFF059669);
const _kOpenBadge = Color(0xFFFFF3E0);
const _kOpenText = Color(0xFFF59E0B);


class SupportTicketsScreen extends StatelessWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupportBloc>().add(const FetchTicketsRequested());

    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(context),
      body: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          if (state.isLoadingTickets) {
            return const Center(
              child: CircularProgressIndicator(color: _kPrimary),
            );
          }

          if (state.ticketsError != null) {
            return _ErrorView(
              message: state.ticketsError!,
              onRetry: () =>
                  context.read<SupportBloc>().add(const FetchTicketsRequested()),
            );
          }

          if (state.tickets.isEmpty) {
            return const _EmptyView();
          }

          return Column(
            children: [
              _CategoryTabs(
                categories: state.ticketCategories,
                activeTab: state.activeTicketTab,
              ),
              Expanded(
                child: _TicketList(tickets: state.filteredTickets),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _kSurface,
      elevation: 0,
      centerTitle: false,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support Tickets',
            style: TextStyle(
              color: _kTextDark,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            'Track your requests',
            style: TextStyle(color: _kTextMid, fontSize: 12),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: _kTextDark, size: 18),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFE5E7EB)),
      ),
    );
  }
}


class _CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String activeTab;

  const _CategoryTabs({required this.categories, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSurface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: categories.map((cat) {
            final isActive = cat == activeTab;
            return GestureDetector(
              onTap: () => context
                  .read<SupportBloc>()
                  .add(TicketCategoryTabChanged(cat)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? _kPrimary : _kBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? _kPrimary : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Colors.white : _kTextMid,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

//  Ticket List

class _TicketList extends StatelessWidget {
  final List<SupportTicket> tickets;
  const _TicketList({required this.tickets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _TicketCard(ticket: tickets[index]),
    );
  }
}


class _TicketCard extends StatelessWidget {
  final SupportTicket ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isResolved = ticket.isResolved;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TicketChatScreen(ticket: ticket),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _kPrimaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _categoryIcon(ticket.category),
                  color: _kPrimary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ticket.subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _kTextDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: ticket.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _kTextMid,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _kPrimaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ticket.category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: _kPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(ticket.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: _kTextLight,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded,
                            size: 16, color: _kTextLight),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'booking issue':
        return Icons.calendar_month_rounded;
      case 'room issue':
        return Icons.bed_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'food issue':
        return Icons.restaurant_rounded;
      default:
        return Icons.support_agent_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return DateFormat('hh:mm a').format(date);
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(date);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Status Badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isResolved = status == 'Resolved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isResolved ? _kResolvedBadge : _kOpenBadge,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: isResolved ? _kResolvedText : _kOpenText,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isResolved ? _kResolvedText : _kOpenText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN : Chat View for a single ticket
// ─────────────────────────────────────────────────────────────────────────────

class TicketChatScreen extends StatelessWidget {
  final SupportTicket ticket;
  const TicketChatScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Ticket info strip
          _TicketInfoStrip(ticket: ticket),

          // Messages
          Expanded(
            child: ticket.messages.isEmpty
                ? const _EmptyChatView()
                : _MessageList(messages: ticket.messages),
          ),

          // Resolved footer or locked bar
          if (ticket.isResolved)
            const _ResolvedBar()
          else
            const _LockedInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _kSurface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: _kTextDark, size: 18),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: _kPrimary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kTextDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  ticket.category,
                  style: const TextStyle(color: _kTextMid, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _StatusBadge(status: ticket.status),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFE5E7EB)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Ticket Info Strip (shown below app bar in chat view)
// ─────────────────────────────────────────────────────────────────────────────

class _TicketInfoStrip extends StatelessWidget {
  final SupportTicket ticket;
  const _TicketInfoStrip({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kPrimaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 14, color: _kPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Ticket #${ticket.id.substring(ticket.id.length - 6).toUpperCase()}  •  '
              'Opened ${DateFormat('dd MMM yyyy').format(ticket.createdAt)}',
              style: const TextStyle(
                fontSize: 11,
                color: _kPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${ticket.messages.length} msg${ticket.messages.length == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 11,
              color: _kPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Message List
// ─────────────────────────────────────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final List<TicketMessage> messages;
  const _MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.sender == 'user';

        // Show sender label when sender changes
        final showLabel = index == 0 ||
            messages[index - 1].sender != msg.sender;

        return _MessageBubble(
          message: msg,
          isUser: isUser,
          showLabel: showLabel,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Single Message Bubble
// ─────────────────────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final TicketMessage message;
  final bool isUser;
  final bool showLabel;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.showLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: EdgeInsets.only(
                bottom: 4,
                top: 6,
                left: isUser ? 0 : 4,
                right: isUser ? 4 : 0,
              ),
              child: Text(
                isUser ? 'You' : 'Support Team',
                style: const TextStyle(
                  fontSize: 11,
                  color: _kTextMid,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                _AdminAvatar(),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? _kUser : _kAdmin,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : _kTextDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 6),
                _UserAvatar(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _kPrimaryLight,
        shape: BoxShape.circle,
        border: Border.all(color: _kPrimary.withOpacity(0.2)),
      ),
      child: const Icon(Icons.support_agent_rounded,
          size: 15, color: _kPrimary),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _kUser.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person_rounded, size: 15, color: _kUser),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom bars
// ─────────────────────────────────────────────────────────────────────────────

class _ResolvedBar extends StatelessWidget {
  const _ResolvedBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSurface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _kResolvedBadge,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: _kResolvedText, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'This ticket has been resolved',
            style: TextStyle(
              color: _kResolvedText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Locked input bar shown for open tickets in read-only view mode.
/// Replace this with a real TextField if you want to allow replies.
class _LockedInputBar extends StatelessWidget {
  const _LockedInputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Replies handled by support team…',
                style: TextStyle(color: _kTextLight, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded,
                color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Empty / Error states
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_rounded,
                color: _kPrimary, size: 38),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tickets yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your support requests will appear here.',
            style: TextStyle(color: _kTextMid, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatView extends StatelessWidget {
  const _EmptyChatView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No messages yet.',
        style: TextStyle(color: _kTextMid, fontSize: 13),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _kTextMid, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}