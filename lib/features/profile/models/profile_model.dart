class AppSettings {
  bool notificationsEnabled;
  bool soundEnabled;
  bool darkModeEnabled;
  String language;

  AppSettings({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.darkModeEnabled = false,
    this.language = "Tiếng Việt",
  });
}