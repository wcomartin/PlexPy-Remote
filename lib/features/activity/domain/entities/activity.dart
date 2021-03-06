import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ActivityItem extends Equatable {
  final int sessionKey;
  final String sessionId;
  final String art; // Image path for background art
  final String audioChannelLayout; // stereo, 5.1, etc
  final String audioCodec; // Source media audio codec
  final String bandwidth; // Streaming brain estimate for bandwidth
  final String channelCallSign;
  final String channelIdentifier;
  final String container; // Source media container (MKV, etc)
  final int duration; // Length of item in milliseconds
  final String friendlyName; // Tautulli friendly name
  final int grandparentRatingKey; // Used to get TV show poster
  final String grandparentThumb;
  final String grandparentTitle; // Show name or music artist name
  final int height;
  final String ipAddress;
  final int live; // 1 if live tv
  final int local; // Private or Public IP
  final String location; // lan, wan
  final int mediaIndex; // Episode number
  final String mediaType; // movie, episode,
  final int optimizedVersion; // 1 if optimized version
  final String optimizedVersionProfile;
  final String optimizedVersionTitle;
  final String originallyAvailableAt;
  final int parentMediaIndex; // Season number
  final int parentRatingKey; // Used to get album art
  final String parentThumb;
  final String parentTitle; // Album name
  final String platformName; // Player platform (Chrome, etc)
  final String player; // Name of the player (ex. PC name)
  final String product; // Player product (Plex Media Player, etc)
  final int progressPercent; // Percent watched
  final String qualityProfile; // Streaming quality
  final int ratingKey; // Used to get movie poster
  final int relayed; // 1 if using Plex Relay
  final int secure; // 1 if connection is secure
  final String state; // Current state of the stream (paused/playing/buffering)
  final String streamAudioChannelLayout; // stereo, 5.1, etc
  final String streamAudioCodec; // Source media audio codec
  final String streamAudioDecision; // transcode, copy, direct play
  final int streamBitrate; // Streaming bitrate in kbps
  final String
      streamContainer; // Stream media container, will be different than container if transcoding
  final String streamContainerDecision; // Transcode or Direct Play
  final String streamSubtitleDecision; // transcode, copy, burn
  final String streamSubtitleCodec; // srt, ass, etc
  final String streamVideoCodec; // h264, etc
  final String streamVideoDecision; // transcode, copy, direct play
  final String streamVideoDynamicRange; // SDR, HDR
  final String streamVideoFullResolution; // 1080p, etc
  final String subtitleCodec; // srt, ass, etc
  final int subtitles; // 1 if subtitles are on
  final String subType; // Used for clip type
  final int syncedVersion; // 1 if is synced content
  final String syncedVersionProfile;
  final String title; // Movie name or Episode name
  final String thumb;
  final String transcodeDecision; // 'Transcode' if transcoding
  final int transcodeHwDecoding; // 1 if true
  final int transcodeHwEncoding; // 1 if true
  final int transcodeProgress; // Percent transcoded
  final double transcodeSpeed; // Value is x factor
  final int transcodeThrottled; // 1 if throttling
  final int userId;
  final String username; // Plex username
  final String userThumb;
  final String videoCodec; // h264, etc
  final String videoDynamicRange; // SDR, HDR
  final String videoFullResolution; // 1080p, etc
  final int viewOffset; // Time from begining of file in milliseconds
  final int width;
  final int year; // Release year
  final String posterUrl;

  ActivityItem({
    @required this.sessionKey,
    @required this.sessionId,
    this.art,
    this.audioChannelLayout,
    this.audioCodec,
    this.bandwidth,
    this.channelCallSign,
    this.channelIdentifier,
    this.container,
    this.duration,
    this.friendlyName,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.height,
    this.ipAddress,
    this.live,
    this.local,
    this.location,
    this.mediaIndex,
    this.mediaType,
    this.optimizedVersion,
    this.optimizedVersionProfile,
    this.optimizedVersionTitle,
    this.originallyAvailableAt,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.platformName,
    this.player,
    this.product,
    this.progressPercent,
    this.qualityProfile,
    this.ratingKey,
    this.relayed,
    this.secure,
    this.streamBitrate,
    this.state,
    this.streamAudioChannelLayout,
    this.streamAudioCodec,
    this.streamAudioDecision,
    this.streamContainer,
    this.streamContainerDecision,
    this.streamSubtitleDecision,
    this.streamSubtitleCodec,
    this.streamVideoCodec,
    this.streamVideoDecision,
    this.streamVideoDynamicRange,
    this.streamVideoFullResolution,
    this.subtitleCodec,
    this.subtitles,
    this.subType,
    this.syncedVersion,
    this.syncedVersionProfile,
    this.thumb,
    this.title,
    this.transcodeDecision,
    this.transcodeHwEncoding,
    this.transcodeHwDecoding,
    this.transcodeThrottled,
    this.transcodeProgress,
    this.transcodeSpeed,
    this.userId,
    this.username,
    this.userThumb,
    this.videoCodec,
    this.videoDynamicRange,
    this.videoFullResolution,
    this.viewOffset,
    this.width,
    this.year,
    this.posterUrl,
  });

  @override
  List<Object> get props => [
        sessionKey,
        sessionId,
        art,
        audioChannelLayout,
        audioCodec,
        bandwidth,
        channelCallSign,
        channelIdentifier,
        container,
        duration,
        friendlyName,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        height,
        ipAddress,
        live,
        local,
        location,
        mediaIndex,
        mediaType,
        originallyAvailableAt,
        optimizedVersion,
        optimizedVersionProfile,
        optimizedVersionTitle,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        platformName,
        player,
        product,
        progressPercent,
        qualityProfile,
        ratingKey,
        relayed,
        secure,
        state,
        streamAudioChannelLayout,
        streamAudioCodec,
        streamAudioDecision,
        streamBitrate,
        streamContainer,
        streamContainerDecision,
        streamSubtitleCodec,
        streamSubtitleDecision,
        streamVideoCodec,
        streamVideoDecision,
        streamVideoDynamicRange,
        streamVideoFullResolution,
        subtitleCodec,
        subtitles,
        syncedVersion,
        syncedVersionProfile,
        thumb,
        title,
        transcodeDecision,
        transcodeHwDecoding,
        transcodeHwEncoding,
        transcodeProgress,
        transcodeSpeed,
        transcodeThrottled,
        userId,
        username,
        userThumb,
        videoCodec,
        videoDynamicRange,
        videoFullResolution,
        viewOffset,
        width,
        year,
        posterUrl,
      ];

  ActivityItem copyWith({
    String posterUrl,
  }) {
    return ActivityItem(
      sessionKey: this.sessionKey,
      sessionId: this.sessionId,
      art: this.art,
      audioChannelLayout: this.audioChannelLayout,
      audioCodec: this.audioCodec,
      bandwidth: this.bandwidth,
      channelCallSign: this.channelCallSign,
      channelIdentifier: this.channelIdentifier,
      container: this.container,
      duration: this.duration,
      friendlyName: this.friendlyName,
      grandparentRatingKey: this.grandparentRatingKey,
      grandparentThumb: this.grandparentThumb,
      grandparentTitle: this.grandparentTitle,
      height: this.height,
      ipAddress: this.ipAddress,
      live: this.live,
      local: this.local,
      location: this.location,
      mediaIndex: this.mediaIndex,
      mediaType: this.mediaType,
      optimizedVersion: this.optimizedVersion,
      optimizedVersionProfile: this.optimizedVersionProfile,
      optimizedVersionTitle: this.optimizedVersionTitle,
      originallyAvailableAt: this.originallyAvailableAt,
      parentMediaIndex: this.parentMediaIndex,
      parentRatingKey: this.parentRatingKey,
      parentThumb: this.parentThumb,
      parentTitle: this.parentTitle,
      platformName: this.platformName,
      player: this.player,
      product: this.product,
      progressPercent: this.progressPercent,
      qualityProfile: this.qualityProfile,
      ratingKey: this.ratingKey,
      relayed: this.relayed,
      secure: this.secure,
      state: this.state,
      streamAudioChannelLayout: this.streamAudioChannelLayout,
      streamAudioCodec: this.streamAudioCodec,
      streamAudioDecision: this.streamAudioDecision,
      streamBitrate: this.streamBitrate,
      streamContainer: this.streamContainer,
      streamContainerDecision: this.streamContainerDecision,
      streamSubtitleCodec: this.streamSubtitleCodec,
      streamSubtitleDecision: this.streamSubtitleDecision,
      streamVideoCodec: this.streamVideoCodec,
      streamVideoDecision: this.streamVideoDecision,
      streamVideoDynamicRange: this.streamVideoDynamicRange,
      streamVideoFullResolution: this.streamVideoFullResolution,
      subtitleCodec: this.subtitleCodec,
      subtitles: this.subtitles,
      subType: this.subType,
      syncedVersion: this.syncedVersion,
      syncedVersionProfile: this.syncedVersionProfile,
      thumb: this.thumb,
      title: this.title,
      transcodeDecision: this.transcodeDecision,
      transcodeHwDecoding: this.transcodeHwDecoding,
      transcodeHwEncoding: this.transcodeHwEncoding,
      transcodeProgress: this.transcodeProgress,
      transcodeSpeed: this.transcodeSpeed,
      transcodeThrottled: this.transcodeThrottled,
      userId: this.userId,
      username: this.username,
      userThumb: this.userThumb,
      videoCodec: this.videoCodec,
      videoDynamicRange: this.videoDynamicRange,
      videoFullResolution: this.videoFullResolution,
      viewOffset: this.viewOffset,
      width: this.width,
      year: this.year,
      posterUrl: posterUrl,
    );
  }

  @override
  bool get stringify => true;
}
