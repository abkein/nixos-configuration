{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.dolphin-plugins

    # Terminal
    kdePackages.konsole

    # Icons
    kdePackages.qtsvg # https://www.reddit.com/r/hyprland/comments/18ecoo3/dolphin_doesnt_work_properly_in_nixos_hyprland/

    # KIO-Fuse
    kdePackages.kio
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    kdePackages.kdf # Available size on devices
    kdePackages.kio-admin # Admin file access

    # Thumbnails
    kdePackages.qtimageformats # *.webp, *.tiff, *.tga, *.jp2 files
    kdePackages.ffmpegthumbs # video files (based on ffmpeg)
    kdePackages.kdegraphics-thumbnailers # image files, PDFs and Blender *.blend files

    # Open with
    kdePackages.plasma-workspace

    # kdePackages.qtwayland
    kdePackages.kservice
    kdePackages.plasma-integration


    # # kdePackages.breeze-icons
    # shared-mime-info
  ];
}
