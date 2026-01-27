{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      # Local-only mode - no sync
      auto_sync = false;
      sync_address = "";
      # Search settings
      search_mode = "fuzzy";
      filter_mode = "global";
    };
  };
}
