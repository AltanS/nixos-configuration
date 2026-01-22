{ userSpecificData, ... }: {
  programs.git = {
    enable = true;
    userName = userSpecificData.gitUsername or null;
    userEmail = userSpecificData.gitEmail or null;

    extraConfig = {
      init.defaultBranch = "main";
      core.autocrlf = "input";
      pull.rebase = false;
    };
  };
}
