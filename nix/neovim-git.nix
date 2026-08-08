{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  pkg-config,
  libuv,
  luajit,
  tree-sitter,
  unibilium,
  utf8proc,
}:

let
  rev = "4975a186f26a54aee76b38eedc1d06a87599baa4";
  nvimVersion = "0.13.0-dev";

  grammars = {
    bash.rev = "a06c2e4415e9bc0346c6b86d401879ffb44058f7";
    bash.hash = "sha256-ONQ1Ljk3aRWjElSWD2crCFZraZoRj3b3/VELz1789GE=";

    c.rev = "ae19b676b13bdcc13b7665397e6d9b14975473dd";
    c.hash = "sha256-i40dlg12UNR3dUWtdlYLZKsusYUWzu+QgC2iedRk968=";

    diff.owner = "tree-sitter-grammars";
    diff.rev = "2520c3f934b3179bb540d23e0ef45f75304b5fed";
    diff.hash = "sha256-8rYLNGgoZSvvfqO2++nAgFKmvbkKJ3m+9B8bTXp6Us4=";

    dockerfile.owner = "camdencheek";
    dockerfile.rev = "971acdd908568b4531b0ba28a445bf0bb720aba5";
    dockerfile.hash = "sha256-WJJ/rjFea1sudGIyjKGupwm39TJ1zbyWlLgoRf1KCBI=";

    go.rev = "2346a3ab1bb3857b48b29d779a1ef9799a248cd7";
    go.hash = "sha256-fifTM/m2Mxd7kpJBlzwWGheAKGq6QbbzyxpBSyplYa0=";

    java.rev = "e10607b45ff745f5f876bfa3e94fbcc6b44bdc11";
    java.hash = "sha256-XoaHRQ0esrV9e5JFSZkVR7QkGfky9NMnXaLQl8lohAM=";

    javascript.rev = "58404d8cf191d69f2674a8fd507bd5776f46cb11";
    javascript.hash = "sha256-+fbTNX7qz6Ew1NrXF49wQh3RVl2ZQ3R7YXMkclUoNT8=";

    json.rev = "001c28d7a29832b06b0e831ec77845553c89b56d";
    json.hash = "sha256-cUjbN+e8UtoLRm8ZnxG7iRGD5YIc032RbHBIlmV8aLc=";

    lua.owner = "tree-sitter-grammars";
    lua.rev = "10fe0054734eec83049514ea2e718b2a56acd0c9";
    lua.hash = "sha256-VzaaN5pj7jMAb/u1fyyH6XmLI+yJpsTlkwpLReTlFNY=";

    nix.owner = "nix-community";
    nix.rev = "eabf96807ea4ab6d6c7f09b671a88cd483542840";
    nix.hash = "sha256-cSiBd0XkSR8l1CF2vkThWUtMxqATwuxCNO5oy2kyOZY=";

    python.rev = "v0.25.0";
    python.hash = "sha256-F5XH21PjPpbwYylgKdwD3MZ5o0amDt4xf/e5UikPcxY=";

    query.owner = "tree-sitter-grammars";
    query.rev = "fc5409c6820dd5e02b0b0a309d3da2bfcde2db17";
    query.hash = "sha256-51dMHH50zVP/N0ljZs7J2wh0EiNtsr2+UvM/S3LkP10=";

    scala.rev = "14c5cfd2b8e0f057ba0f4f72ee4812b0ae6cdce3";
    scala.hash = "sha256-xDp1+i0QLnY18EtiwurW1B4bbeS1qZKNJRxS6Qeb3pw=";

    starlark.owner = "tree-sitter-grammars";
    starlark.rev = "a453dbf3ba433db0e5ec621a38a7e59d72e4dc69";
    starlark.hash = "sha256-iBchBq9NE4QqHc8MbWs4YgzUH6EB0W7RCIk07I6Zm+I=";

    toml.owner = "tree-sitter-grammars";
    toml.rev = "64b56832c2cffe41758f28e05c756a3a98d16f41";
    toml.hash = "sha256-m9RlGkHiOL/PNENrdEPqtPlahSqGymsx7gZrCoN/Lsk=";

    vim.owner = "tree-sitter-grammars";
    vim.rev = "3092fcd99eb87bbd0fc434aa03650ba58bd5b43b";
    vim.hash = "sha256-MnLBFuJCJbetcS07fG5fkCwHtf/EcNP+Syf0Gn0K39c=";

    vimdoc.owner = "neovim";
    vimdoc.rev = "f061895a0eff1d5b90e4fb60d21d87be3267031a";
    vimdoc.hash = "sha256-K3nzoLlzbgIJc7EnqgYgNDLCBXOg7oy9eV2lI0duwaE=";

    yaml.owner = "tree-sitter-grammars";
    yaml.rev = "4463985dfccc640f3d6991e3396a2047610cf5f8";
    yaml.hash = "sha256-nCyGepZg6n2a/Clc0NFxTSt3Pm1z4OHIzJSjrjGudmw=";

    markdown.owner = "tree-sitter-grammars";
    markdown.rev = "f969cd3ae3f9fbd4e43205431d0ae286014c05b5";
    markdown.hash = "sha256-WUVN7+lzDI+VC5PuJjhHiS4JpVr1x0Ic30i2tVrI6W8=";
    markdown.location = "tree-sitter-markdown";

    markdown_inline.owner = "tree-sitter-grammars";
    markdown_inline.repo = "tree-sitter-markdown";
    markdown_inline.rev = "f969cd3ae3f9fbd4e43205431d0ae286014c05b5";
    markdown_inline.hash = "sha256-WUVN7+lzDI+VC5PuJjhHiS4JpVr1x0Ic30i2tVrI6W8=";
    markdown_inline.location = "tree-sitter-markdown-inline";

    typescript.rev = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
    typescript.hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
    typescript.location = "typescript";

    tsx.repo = "tree-sitter-typescript";
    tsx.rev = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
    tsx.hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
    tsx.location = "tsx";
  };

  parsers = lib.mapAttrs (
    language: args:
    tree-sitter.buildGrammar {
      inherit language;
      version = nvimVersion;
      location = args.location or null;
      src =
        args.src or (fetchFromGitHub {
          owner = args.owner or "tree-sitter";
          repo = args.repo or "tree-sitter-${language}";
          inherit (args) rev hash;
        });
    }
  ) grammars;

  parserNames = lib.generators.toLua { multiline = false; } (lib.attrNames parsers);
in

stdenv.mkDerivation {
  pname = "neovim-git";
  version = "${nvimVersion}-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    inherit rev;
    hash = "sha256-1QbCKLCGziXCfbQxh6DEQZGI2/Erydt+aEVYjVUVtpc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    luajit
    pkg-config
  ];

  buildInputs = [
    libuv
    luajit
    luajit.pkgs.libluv
    luajit.pkgs.lpeg
    tree-sitter
    unibilium
    utf8proc
  ];

  cmakeFlags = [ (lib.cmakeBool "ENABLE_TRANSLATIONS" true) ];

  postInstall = lib.concatMapAttrsStringSep "\n" (
    language: grammar: "install -Dm555 ${grammar}/parser $out/lib/nvim/parser/${language}.so"
  ) parsers;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/nvim --version | grep -F "NVIM v${nvimVersion}"

    cat > smoke.lua <<'EOF'
    for _, lang in ipairs(${parserNames}) do
      assert(vim.treesitter.language.add(lang), "parser failed to load: " .. lang)
    end
    EOF
    $out/bin/nvim --headless -l smoke.lua

    runHook postInstallCheck
  '';

  meta = {
    description = "Vim text editor fork focused on extensibility and agility, built from master";
    homepage = "https://neovim.io";
    changelog = "https://github.com/neovim/neovim/commits/${rev}";
    license = with lib.licenses; [
      asl20
      vim
    ];
    mainProgram = "nvim";
    platforms = lib.platforms.linux;
  };
}
