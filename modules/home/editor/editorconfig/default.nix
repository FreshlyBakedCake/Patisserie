{ config, lib, ... }:
{
  options.chimera.editor.editorconfig = {
    enable = lib.mkEnableOption "Enable default .editorconfig file";
  };

  config = lib.mkIf config.chimera.editor.editorconfig.enable {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
          indent_style = "tab";
        };
        # JS Files
        "*.{ts,js,cjs,mjs}" = {
          indent_size = 4;
        };
        "*.{jsx,tsx}" = {
          indent_size = 2;
        };
        # Python
        "*.py" = {
          indent_size = 4;
        };
        # Nix
        "*.nix" = {
          indent_style = "space";
          indent_size = 2;
        };
        # Web Files
        "*.{htm,html,less,svg,vue}" = {
          indent_size = 2;
        };
        # Rust
        "*.rs" = {
          indent_size = 4;
        };
        # C Files
        "*.{c,cpp,cs,h,hpp,C,H,cxx,hxx}" = {
          indent_size = 4;
        };
        "*.{sln,csproj,vbproj,vcxproj.filters,proj,projitems,shproj}" = {
          indent_size = 2;
        };
        # CSS Files
        "*.{css,sass,scss,less}" = {
          indent_size = 2;
        };
        # Script Files
        "*.{sh,zsh,bash,bat,cmd,ps1,psm1}" = {
          indent_size = 4;
        };
        # Git Files
        "*.{diff,patch}" = {
          end_of_line = "unset";
          insert_final_newline = "unset";
          trim_trailing_whitespace = "unset";
        };
        ".{gitignore,gitreview,gitmodules}" = {
          indent_style = "unset";
          indent_size = 0;
        };
        # Key Files
        "*.{asc,key,ovpn}" = {
          end_of_line = "unset";
          insert_final_newline = "unset";
          trim_trailing_whitespace = "unset";
        };
        # Lockfile
        "*.lock" = {
          indent_style = "unset";
          insert_final_newline = "unset";
        };
        # Markdown
        "*.md" = {
          indent_size = 2;
          trim_trailing_whitespace = false;
        };
        # JSON a/ YAML Files
        "*.{json,json5,webmanifest,yaml,yml}" = {
          indent_style = "space";
          indent_size = 2;
        };
        # TOML
        "*.toml" = {
          indent_style = "unset";
          indent_size = 0;
        };
        # *RC Files
        ".*rc" = {
          indent_size = 2;
        };
      };
    };
  };
}
