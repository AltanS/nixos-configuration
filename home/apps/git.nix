{ userSpecificData, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userSpecificData.gitUsername or null;
        email = userSpecificData.gitEmail or null;
      };
      init.defaultBranch = "main";
      core.autocrlf = "input";
      pull.rebase = false;
    };
  };
}
