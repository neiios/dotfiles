{
  writeShellScriptBin,
  fd,
  nixfmt,
}:
# because nixfmt-tree is too much
writeShellScriptBin "fmt" ''
  cd "$PRJ_ROOT"
  ${fd}/bin/fd -e nix -X "$BASH" -c '${nixfmt}/bin/nixfmt "$@" && printf "%s\n" "$@"' _
''
