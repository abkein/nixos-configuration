let 
  tools = {
    code = [
      "org.x.editor.desktop"     # xed-editor
      "code.desktop"  # Microsoft Visual Studio Code
    ];
    general_image = [
        "swayimg.desktop"
        "gimp.desktop"
    ];
  };
in
with tools; {

  ### application ###
  
  "application/pdf" = [
    "org.gnome.Evince.desktop"  # evince pdf viewer
    "draw.desktop"    # LibreOffice Draw
  ];
  "application/postscript" = [
    "swayimg.desktop"
    "org.inkscape.Inkscape.desktop"
    "org.gnome.Evince.desktop"  # evince pdf viewer
  ];
  "application/json" = code;
  "application/javascript" = code;
  "application/xml" = code;
  "application/x-yaml" = code;
  "application/msword" = "writer.desktop";
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
  "application/vnd.ms-excel" = "calc.desktop";
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
  "application/vnd.ms-powerpoint" = "impress.desktop";
  "application/vnd.openxmlformats-officedocument.presentationml.presentation: PPTX" = "impress.desktop";

  # "application/zip" = "nemo-fileroller";
  # "application/gzip" = "nemo-fileroller";
  # "application/x-tar" = "nemo-fileroller";
  # "application/x-rar-compressed" = "nemo-fileroller";

  ### image ###

  "image/tiff" = "swayimg.desktop";
  "image/gif" = "swayimg.desktop";
  "image/webp" = "swayimg.desktop";
  "image/heif" = "swayimg.desktop";
  "image/heic" = "swayimg.desktop";
  "image/avif" = "swayimg.desktop";
  "image/jpeg" = general_image;
  "image/pjpeg" = general_image;
  "image/png" = general_image;
  "image/svg+xml" = [
    "swayimg.desktop"
    "org.inkscape.Inkscape.desktop"
  ];

  ### text ###

  "text/cmd" = code;
  "text/css" = code;
  "text/html" = code;
  "text/plain" = code;
  "text/php" = code;
  "text/xml" = code;
  "text/markdown" = [ "obsidian.desktop" ] ++ code;
  "text/x-markdown" = [ "obsidian.desktop" ] ++ code;
  "text/rtf" = code;
  "text/x-java-source" = code;
  "text/x-python" = code;
  "text/x-c" = code;
  "text/x-c++" = code;
  "text/x-perl" = code;
  "text/x-r" = code;
  "text/x-shellscript" = code;
  "text/x-yaml" = code;
  "text/x-asm" = code;
  "text/x-sass" = code;
  "text/x-scss" = code;
  "text/x-handlebars-template" = code;
  "text/x-lua" = code;
  "text/x-vue" = code;
  "text/x-go" = code;
  "text/x-rustsrc" = code;

  ### video ###

  "video/mpeg" = "vlc.desktop";
  "video/mp4" = "vlc.desktop";
  "video/ogg" = "vlc.desktop";
  "video/quicktime" = "vlc.desktop";
  "video/webm" = "vlc.desktop";
  "video/x-ms-wmv" = "vlc.desktop";
  "video/x-flv" = "vlc.desktop";
  "video/x-msvideo" = "vlc.desktop";
  "video/3gpp" = "vlc.desktop";
  "video/3gpp2" = "vlc.desktop";
  "video/x-matroska" = "vlc.desktop";
  "video/x-f4v" = "vlc.desktop";
  "video/x-m4v" = "vlc.desktop";
  "video/h264" = "vlc.desktop";
  "video/h265" = "vlc.desktop";
  "video/avi" = "vlc.desktop";
  "video/divx" = "vlc.desktop";
  "video/x-vob" = "vlc.desktop";
  "video/x-anim" = "vlc.desktop";
  "video/x-sgi-movie" = "vlc.desktop";
  "video/x-ms-asf" = "vlc.desktop";
  "video/x-ogm" = "vlc.desktop";
  "video/x-mjpeg" = "vlc.desktop";
  "video/x-pn-realvideo" = "vlc.desktop";
}