import 'package:music_app/imports_bindings.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songModel,
    required this.isSelected,
    required this.onTap,
  });
  final bool isSelected;
  final SongModel songModel;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      tileColor: AppColors.transparent,
      selectedTileColor: context.theme.colorScheme.primary,
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: FutureBuilder(
          future: OnAudioQuery.platform.queryArtwork(songModel.id, ArtworkType.AUDIO),
          builder: (context, snapshot) {
            if (snapshot.data == null || (snapshot.data?.isEmpty ?? false)) {
              return Image.asset(noQyeryImg(isSelected, context), height: 35.h);
            } else {
              return Image.memory(snapshot.data!, height: 35.h, width: 35.h, fit: BoxFit.cover);
            }
          },
        ),
      ),
      trailing: trailing(isSelected, context),
      title: Text(
        songModel.title,
        style: context.textTheme.headline2!.copyWith(color: isSelected ? context.theme.colorScheme.background : context.theme.colorScheme.primary, overflow: TextOverflow.ellipsis),
        maxLines: 1,
      ),
      subtitle: Text(
        songModel.artist ?? 'unknown',
        style: context.textTheme.headline2!.copyWith(color: isSelected ? context.theme.colorScheme.background : context.theme.colorScheme.primary, overflow: TextOverflow.ellipsis),
        maxLines: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ).paddingSymmetric(horizontal: 16.r);
  }

  String noQyeryImg(bool isSelected, BuildContext context) {
    return isSelected
        ? context.isDarkMode
            ? AssetHelper.darkIcon
            : AssetHelper.lightIcon
        : appIcon;
  }

  Widget trailing(bool isSelected, BuildContext context) {
    return IconButton(
      onPressed: () {
        isSelected ? PlayerServices().pauseOrPlay() : null;
      },
      icon: isSelected
          ? StreamBuilder(
              stream: PlayerServices().player.playingStream,
              builder: (context, snapshot) => Icon(
                (snapshot.data == null || snapshot.data != true) ? Icons.play_arrow : Icons.pause,
                color: context.theme.scaffoldBackgroundColor,
              ),
            )
          : PopupMenuButton<String>(
              child: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'Delete' || value == 'Rename') {
                  Get.snackbar(snackPosition: SnackPosition.BOTTOM, 'Oops !', 'Can\'t make action right now .');
                }
                if (value == 'Details') {
                  Kwidgets.songDetails(context);
                }
              },
              itemBuilder: (context) => AppData.offlineSongMore
                  .map((e) => PopupMenuItem<String>(
                      value: e.label, child: Button.label(label: e.label, icon: e.icon, iconColor: context.theme.scaffoldBackgroundColor, labelColor: context.theme.scaffoldBackgroundColor)))
                  .toList()).paddingSymmetric(horizontal: 8.r),
    );
  }
}
