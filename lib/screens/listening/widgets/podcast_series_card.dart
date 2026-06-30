import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/podcast_models.dart';

class PodcastSeriesCard extends StatelessWidget {
  final PodcastSeries series;

  const PodcastSeriesCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate based on series type
          if (series.id == 'easy-german') {
            context.push('/listening/easy-german');
          } else if (series.id == 'sprechen-b1') {
            context.push('/listening/sprechen-b1');
          } else if (series.id == 'sprechen-b2') {
            context.push('/listening/sprechen-b2');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getGradientColors(series.id),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: series.imageUrl.isNotEmpty
                  ? Image.network(series.imageUrl, fit: BoxFit.cover)
                  : Stack(
                      children: [
                        Center(
                          child: Icon(
                            _getSeriesIcon(series.id),
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              series.level,
                              style: TextStyle(
                                color: _getSeriesColor(series.id),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          series.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getGradientColors(series.id),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Học ngay',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    series.titleVi,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    series.descriptionVi,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (series.totalEpisodes > 0) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.headphones,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${series.totalEpisodes} tập',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (series.completedEpisodes > 0) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${series.completedEpisodes} đã học',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: series.totalEpisodes > 0
                          ? series.completedEpisodes / series.totalEpisodes
                          : 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        _getSeriesColor(series.id),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSeriesIcon(String id) {
    switch (id) {
      case 'easy-german':
        return Icons.record_voice_over;
      case 'sprechen-b1':
        return Icons.chat;
      case 'sprechen-b2':
        return Icons.work;
      default:
        return Icons.podcasts;
    }
  }

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'easy-german':
        return [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];
      case 'sprechen-b1':
        return [Colors.orange.shade400, Colors.orange.shade600];
      case 'sprechen-b2':
        return [Colors.red.shade400, Colors.red.shade600];
      default:
        return [AppColors.primary, AppColors.tigerOrange];
    }
  }

  Color _getSeriesColor(String id) {
    switch (id) {
      case 'easy-german':
        return const Color(0xFFFF6B6B);
      case 'sprechen-b1':
        return Colors.orange;
      case 'sprechen-b2':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}
