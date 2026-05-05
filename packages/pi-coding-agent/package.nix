{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  ripgrep,
  makeBinaryWrapper,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.73.0";

  src = fetchFromGitHub {
    owner = "badlogic";
    repo = "pi-mono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oE4zMH5KEH185Vdp0CE221sa9rJJw35jFLlfhTa3Sg4=";
  };

  npmDepsHash = "sha256-rBlAzAnP9aif1tZ984AO4HftIJsDgLQ+02J3td4jcRg=";

  npmWorkspace = "packages/coding-agent";

  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    npx tsgo -p packages/ai/tsconfig.build.json
    npx tsgo -p packages/tui/tsconfig.build.json
    npx tsgo -p packages/agent/tsconfig.build.json
    npm run build --workspace=packages/coding-agent

    runHook postBuild
  '';

  postInstall = ''
    local nm="$out/lib/node_modules/pi-monorepo/node_modules"

    for ws in @mariozechner/pi-ai:packages/ai \
              @mariozechner/pi-agent-core:packages/agent \
              @mariozechner/pi-tui:packages/tui; do
      IFS=: read -r pkg src <<< "$ws"
      rm "$nm/$pkg"
      cp -r "$src" "$nm/$pkg"
    done

    find "$nm" -type l -lname '*/packages/*' -delete

    find "$nm/.bin" -xtype l -delete
  '';
  postFixup = "wrapProgram $out/bin/pi --prefix PATH : ${lib.makeBinPath [ ripgrep ]}";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgram = "${placeholder "out"}/bin/pi";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://shittycodingagent.ai/";
    downloadPage = "https://www.npmjs.com/package/@mariozechner/pi-coding-agent";
    changelog = "https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "pi";
  };
})
