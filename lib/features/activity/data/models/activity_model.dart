import 'package:meta/meta.dart';

import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/activity.dart';

class ActivityItemModel extends ActivityItem {
  ActivityItemModel({
    @required final int sessionKey,
    @required final String sessionId,
    final String art, // Image path for background art
    final String audioChannelLayout, // stereo, 5.1, etc
    final String audioCodec, // Source media audio codec
    final String bandwidth, // Streaming brain estimate for bandwidth
    final String channelCallSign,
    final String channelIdentifier,
    final String container, // Source media container (MKV, etc)
    final int duration, // Length of item in milliseconds
    final String friendlyName, // Tautulli friendly name
    final int grandparentRatingKey, // Used to get TV show poster
    final String grandparentThumb,
    final String grandparentTitle, // Show name
    final int height,
    final String ipAddress,
    final int live, // 1 if live tv
    final int local, // Public or Private IP
    final String location, // lan, wan
    final int mediaIndex, // Episode number
    final String mediaType, // movie, episode,
    final int optimizedVersion, // 1 if optimized version
    final String optimizedVersionProfile,
    final String optimizedVersionTitle,
    final String originallyAvailableAt,
    final int parentMediaIndex, // Season number
    final int parentRatingKey, // Used to get album art
    final String parentThumb,
    final String parentTitle, // Album name
    final String platformName, // Player platform (Chrome, etc)
    final String player, // Name of the player (ex. PC name)
    final String product, // Player product (Plex Media Player, etc)
    final int progressPercent, // Percent watched
    final String qualityProfile, // Streaming quality
    final int ratingKey, // Used to get movie poster
    final int relayed, // 1 if using Plex Relay
    final int secure, // 1 if connection is secure
    final int streamBitrate, // Streaming bitrate in kbps
    final String
        state, // Current state of the stream (paused/playing/buffering)
    final String streamAudioChannelLayout, // stereo, 5.1, etc
    final String streamAudioCodec, // Source media audio codec
    final String streamAudioDecision, // transcode, copy, direct play
    final String
        streamContainer, // Stream media container, will be different than container if transcoding
    final String streamContainerDecision, // Transcode or Direct Play
    final String streamSubtitleDecision, // transcode, copy, burn
    final String streamSubtitleCodec, // srt, ass, etc
    final String streamVideoCodec, // h264, etc
    final String streamVideoDecision, // transcode, copy, direct play
    final String streamVideoDynamicRange, // SDR, HDR
    final String streamVideoFullResolution, // 1080p, etc
    final String subtitleCodec, // srt, ass, etc
    final int subtitles, // 1 if subtitles are on
    final String subType, // Used for clip type
    final int syncedVersion, // 1 if is synced content
    final String syncedVersionProfile,
    final String thumb,
    final String title, // Movie name or Episode name
    final String transcodeDecision, // 'Transcode' if transcoding
    final int transcodeHwEncoding, // 1 if true
    final int transcodeHwDecoding, // 1 if true
    final int transcodeThrottled, // 1 if throttling
    final int transcodeProgress, // Percent transcoded
    final double transcodeSpeed, // Value is x factor
    final int userId,
    final String username, // Plex username
    final String userThumb,
    final String videoCodec, // h264, etc
    final String videoDynamicRange, // SDR, HDR
    final String videoFullResolution, // 1080p, etc
    final int viewOffset, // Time from begining of file in milliseconds
    final int width,
    final int year, // Release year
    final String posterUrl,
  }) : super(
          sessionKey: sessionKey,
          sessionId: sessionId,
          art: art,
          audioChannelLayout: audioChannelLayout,
          audioCodec: audioCodec,
          bandwidth: bandwidth,
          channelCallSign: channelCallSign,
          channelIdentifier: channelIdentifier,
          container: container,
          duration: duration,
          friendlyName: friendlyName,
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          height: height,
          ipAddress: ipAddress,
          live: live,
          local: local,
          location: location,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          optimizedVersion: optimizedVersion,
          optimizedVersionProfile: optimizedVersionProfile,
          optimizedVersionTitle: optimizedVersionTitle,
          originallyAvailableAt: originallyAvailableAt,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          parentTitle: parentTitle,
          platformName: platformName,
          player: player,
          product: product,
          progressPercent: progressPercent,
          qualityProfile: qualityProfile,
          ratingKey: ratingKey,
          relayed: relayed,
          secure: secure,
          state: state,
          streamAudioChannelLayout: streamAudioChannelLayout,
          streamAudioCodec: streamAudioCodec,
          streamAudioDecision: streamAudioDecision,
          streamBitrate: streamBitrate,
          streamContainer: streamContainer,
          streamContainerDecision: streamContainerDecision,
          streamSubtitleCodec: streamSubtitleCodec,
          streamSubtitleDecision: streamSubtitleDecision,
          streamVideoCodec: streamVideoCodec,
          streamVideoDecision: streamVideoDecision,
          streamVideoDynamicRange: streamVideoDynamicRange,
          streamVideoFullResolution: streamVideoFullResolution,
          subtitleCodec: subtitleCodec,
          subtitles: subtitles,
          subType: subType,
          syncedVersion: syncedVersion,
          syncedVersionProfile: syncedVersionProfile,
          thumb: thumb,
          title: title,
          transcodeDecision: transcodeDecision,
          transcodeHwDecoding: transcodeHwDecoding,
          transcodeHwEncoding: transcodeHwEncoding,
          transcodeProgress: transcodeProgress,
          transcodeSpeed: transcodeSpeed,
          transcodeThrottled: transcodeThrottled,
          userId: userId,
          username: username,
          userThumb: userThumb,
          videoCodec: videoCodec,
          videoDynamicRange: videoDynamicRange,
          videoFullResolution: videoFullResolution,
          viewOffset: viewOffset,
          width: width,
          year: year,
          posterUrl: posterUrl,
        );

  factory ActivityItemModel.fromJson(Map<String, dynamic> json) {
    return ActivityItemModel(
      sessionKey: ValueHelper.cast(
        value: json['session_key'],
        type: CastType.int,
      ),
      sessionId: ValueHelper.cast(
        value: json['session_id'],
        type: CastType.string,
      ),
      art: ValueHelper.cast(
        value: json['art'],
        type: CastType.string,
      ),
      audioChannelLayout: ValueHelper.cast(
        value: json['audio_channel_layout'],
        type: CastType.string,
      ),
      audioCodec: ValueHelper.cast(
        value: json['audio_codec'],
        type: CastType.string,
      ),
      bandwidth: ValueHelper.cast(
        value: json['bandwidth'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      channelCallSign: ValueHelper.cast(
        value: json['channel_call_sign'],
        type: CastType.string,
      ),
      channelIdentifier: ValueHelper.cast(
        value: json['channel_identifier'],
        type: CastType.string,
      ),
      container: ValueHelper.cast(
        value: json['container'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      duration: ValueHelper.cast(
        value: json['duration'],
        type: CastType.int,
      ),
      friendlyName: ValueHelper.cast(
        value: json['friendly_name'],
        type: CastType.string,
      ),
      grandparentRatingKey: ValueHelper.cast(
        value: json['grandparent_rating_key'],
        type: CastType.int,
      ),
      grandparentThumb: ValueHelper.cast(
        value: json['grandparent_thumb'],
        type: CastType.string,
      ),
      grandparentTitle: ValueHelper.cast(
        value: json['grandparent_title'],
        type: CastType.string,
      ),
      height: ValueHelper.cast(
        value: json['height'],
        type: CastType.int,
      ),
      ipAddress: ValueHelper.cast(
        value: json['ip_address'],
        type: CastType.string,
      ),
      live: ValueHelper.cast(
        value: json['live'],
        type: CastType.int,
      ),
      local: ValueHelper.cast(
        value: json['local'],
        type: CastType.int,
      ),
      location: ValueHelper.cast(
        value: json['location'],
        type: CastType.string,
      ),
      mediaIndex: ValueHelper.cast(
        value: json['media_index'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['media_type'],
        type: CastType.string,
      ),
      optimizedVersion: ValueHelper.cast(
        value: json['optimized_version'],
        type: CastType.int,
      ),
      optimizedVersionProfile: ValueHelper.cast(
        value: json['optimized_version_profile'],
        type: CastType.string,
      ),
      optimizedVersionTitle: ValueHelper.cast(
        value: json['optimized_version_title'],
        type: CastType.string,
      ),
      originallyAvailableAt: ValueHelper.cast(
        value: json['originally_available_at'],
        type: CastType.string,
      ),
      parentMediaIndex: ValueHelper.cast(
        value: json['parent_media_index'],
        type: CastType.int,
      ),
      parentRatingKey: ValueHelper.cast(
        value: json['parent_rating_key'],
        type: CastType.int,
      ),
      parentThumb: ValueHelper.cast(
        value: json['parent_thumb'],
        type: CastType.string,
      ),
      parentTitle: ValueHelper.cast(
        value: json['parent_title'],
        type: CastType.string,
      ),
      platformName: ValueHelper.cast(
        value: json['platform_name'],
        type: CastType.string,
      ),
      player: ValueHelper.cast(
        value: json['player'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      product: ValueHelper.cast(
        value: json['product'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      progressPercent: ValueHelper.cast(
        value: json['progress_percent'],
        type: CastType.int,
      ),
      qualityProfile: ValueHelper.cast(
        value: json['quality_profile'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
        type: CastType.int,
      ),
      relayed: ValueHelper.cast(
        value: json['relayed'],
        type: CastType.int,
      ),
      secure: ValueHelper.cast(
        value: json['secure'],
        type: CastType.int,
      ),
      state: ValueHelper.cast(
        value: json['state'],
        type: CastType.string,
      ),
      streamAudioChannelLayout: ValueHelper.cast(
        value: json['stream_audio_channel_layout'],
        type: CastType.string,
      ),
      streamAudioCodec: ValueHelper.cast(
        value: json['stream_audio_codec'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      streamAudioDecision: ValueHelper.cast(
        value: json['stream_audio_decision'],
        type: CastType.string,
      ),
      streamBitrate: ValueHelper.cast(
        value: json['stream_bitrate'],
        type: CastType.int,
      ),
      streamContainer: ValueHelper.cast(
        value: json['stream_container'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      streamContainerDecision: ValueHelper.cast(
        value: json['stream_container_decision'],
        type: CastType.string,
      ),
      streamSubtitleCodec: ValueHelper.cast(
        value: json['stream_subtitle_codec'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      streamSubtitleDecision: ValueHelper.cast(
        value: json['stream_subtitle_decision'],
        type: CastType.string,
      ),
      streamVideoCodec: ValueHelper.cast(
        value: json['stream_video_codec'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      streamVideoDecision: ValueHelper.cast(
        value: json['stream_video_decision'],
        type: CastType.string,
      ),
      streamVideoDynamicRange: ValueHelper.cast(
        value: json['stream_video_dynamic_range'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      streamVideoFullResolution: ValueHelper.cast(
        value: json['stream_video_full_resolution'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      subtitleCodec: ValueHelper.cast(
        value: json['subtitle_codec'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      subtitles: ValueHelper.cast(
        value: json['subtitles'],
        type: CastType.int,
      ),
      subType: ValueHelper.cast(
        value: json['sub_type'],
        type: CastType.string,
      ),
      syncedVersion: ValueHelper.cast(
        value: json['synced_version'],
        type: CastType.int,
      ),
      syncedVersionProfile: ValueHelper.cast(
        value: json['synced_version_profile'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      thumb: ValueHelper.cast(
        value: json['thumb'],
        type: CastType.string,
      ),
      title: ValueHelper.cast(
        value: json['title'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      transcodeDecision: ValueHelper.cast(
        value: json['transcode_decision'],
        type: CastType.string,
      ),
      transcodeHwDecoding: ValueHelper.cast(
        value: json['transcode_hw_decoding'],
        type: CastType.int,
      ),
      transcodeHwEncoding: ValueHelper.cast(
        value: json['transcode_hw_encoding'],
        type: CastType.int,
      ),
      transcodeProgress: ValueHelper.cast(
        value: json['transcode_progress'],
        type: CastType.int,
      ),
      transcodeSpeed: ValueHelper.cast(
        value: json['transcode_speed'],
        type: CastType.double,
      ),
      transcodeThrottled: ValueHelper.cast(
        value: json['transcode_throttled'],
        type: CastType.int,
      ),
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
      username: ValueHelper.cast(
        value: json['username'],
        type: CastType.string,
      ),
      userThumb: ValueHelper.cast(
        value: json['user_thumb'],
        type: CastType.string,
      ),
      videoCodec: ValueHelper.cast(
        value: json['video_codec'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      videoDynamicRange: ValueHelper.cast(
        value: json['video_dynamic_range'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      videoFullResolution: ValueHelper.cast(
        value: json['video_full_resolution'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      viewOffset: ValueHelper.cast(
        value: json['view_offset'],
        type: CastType.int,
      ),
      width: ValueHelper.cast(
        value: json['width'],
        type: CastType.int,
      ),
      year: ValueHelper.cast(
        value: json['year'],
        type: CastType.int,
      ),
    );
  }
}
